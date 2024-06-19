import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart'; // Importação do HHGlobals
import 'package:hh_2/src/config/common/var/hh_notifiers.dart'; // Importação do HHNotifiers
import 'dart:html' as html;
import 'package:path_provider/path_provider.dart';


class PhotoDialog {
  static final picker = ImagePicker();

  static Future<void> getImage(BuildContext context) async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        final Uint8List bytes = await pickedFile.readAsBytes();
        final File image = await _createFileFromBytes(context, bytes);
        final File resizedImage = _resizeAndFixOrientation(image);

        HHGlobals.pictureFile = resizedImage;
        HHNotifiers.increment(CounterType.PictureCount);

        showSuccessDialog(context, 'Imagem carregada com sucesso!');
      } else {
        showWarningDialog(context, 'Nenhuma imagem foi selecionada');
      }
    } catch (e) {
      showErrorDialog(context, 'Erro ao carregar imagem: $e');
    }
  }

  static Future<File> _createFileFromBytes(BuildContext context, Uint8List bytes) async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File(path.join(tempDir.path, '${DateTime.now().millisecondsSinceEpoch}.jpg'));
    await tempFile.writeAsBytes(bytes);
    return tempFile;
  }

  static File _resizeAndFixOrientation(File imageFile) {
    final image = img.decodeImage(imageFile.readAsBytesSync());
    final resizedImage = img.copyResize(image!, width: 600);
    final correctedImage = img.bakeOrientation(resizedImage);

    final dir = Directory.systemTemp;
    final targetPath = path.join(dir.path, '${path.basename(imageFile.path)}_resized.jpg');
    final resizedImageFile = File(targetPath)
      ..writeAsBytesSync(img.encodeJpg(correctedImage, quality: 80));

    return resizedImageFile;
  }

  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Erro'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  static void showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sucesso'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  static void showWarningDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Aviso'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}


/*
////VERSAO FUNCIONAL COM PROBLEMAS 18/06
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart'; // Importação do HHGlobals
import 'package:hh_2/src/config/common/var/hh_notifiers.dart'; // Importação do HHNotifiers

class PhotoDialog {
  static final picker = ImagePicker();

  static Future<void> getImage(BuildContext context) async {
    try {
      if (kIsWeb) {
        await getImageWeb(context);
      } else {
        await getImageMobile(context);
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erro'),
          content: Text('Erro ao carregar imagem: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  static Future<void> getImageWeb(BuildContext context) async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        final image = img.decodeImage(Uint8List.fromList(bytes));
        final resizedImage = img.copyResize(image!, width: 600);
        final correctedImage = img.bakeOrientation(resizedImage);

        // Salva a imagem em memória como Uint8List
        final resizedImageBytes = Uint8List.fromList(img.encodeJpg(correctedImage, quality: 80));

        // Salva o caminho da imagem reduzida em HHGlobals.pictureFileBytes
        HHGlobals.pictureFileBytes = resizedImageBytes;

        // Ativa o HHNotifier do tipo CounterType.PictureCount
        HHNotifiers.increment(CounterType.PictureCount);

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Sucesso'),
            content: Text('Imagem carregada com sucesso da web!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Aviso'),
            content: Text('Nenhuma imagem foi selecionada'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erro'),
          content: Text('Erro ao carregar imagem da web: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  static Future<void> getImageMobile(BuildContext context) async {
    try {
      final status = await Permission.camera.request();
      if (status.isGranted) {
        final pickedFile = await picker.pickImage(source: ImageSource.camera);
        if (pickedFile != null) {
          final File image = File(pickedFile.path);
          final File resizedImage = _resizeAndFixOrientation(image);

          HHGlobals.pictureFile = resizedImage;
          HHNotifiers.increment(CounterType.PictureCount);

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Sucesso'),
              content: Text('Imagem capturada com sucesso! ${HHGlobals.pictureFileBytes}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Aviso'),
              content: Text('Nenhuma imagem foi capturada'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Permissão Negada'),
            content: Text('Permissão de câmera negada'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erro'),
          content: Text('Erro ao capturar imagem: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  static File _resizeAndFixOrientation(File imageFile) {
    final image = img.decodeImage(imageFile.readAsBytesSync());
    final resizedImage = img.copyResize(image!, width: 600);
    final correctedImage = img.bakeOrientation(resizedImage);

    final dir = Directory.systemTemp;
    final targetPath = path.join(dir.path, '${path.basename(imageFile.path)}_resized.jpg');
    final resizedImageFile = File(targetPath)
      ..writeAsBytesSync(img.encodeJpg(correctedImage, quality: 80));

    return resizedImageFile;
  }
}*/











/*


import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:hh_2/src/config/common/var/hh_globals.dart'; // Importação do HHGlobals
import 'package:hh_2/src/config/common/var/hh_notifiers.dart'; // Importação do HHNotifiers

class PhotoDialog {
  static final picker = ImagePicker();

  static Future<void> getImage(BuildContext context) async {
    final status = await Permission.camera.request();

    if (status.isGranted) {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        final File image = File(pickedFile.path);
        final File resizedImage = _resizeAndFixOrientation(image);

        // Salva o caminho da imagem reduzida em HHGlobals.pictureFile
        HHGlobals.pictureFile = resizedImage;

        // Ativa o HHNotifier do tipo CounterType.ImageCount
        HHNotifiers.increment(CounterType.PictureCount);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nenhuma imagem foi selecionada')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permissão de câmera negada')),
      );
    }
  }

  static File _resizeAndFixOrientation(File imageFile) {
    final image = img.decodeImage(imageFile.readAsBytesSync());
    final resizedImage = img.copyResize(image!, width: 600);
    final correctedImage = img.bakeOrientation(resizedImage);

    final dir = Directory.systemTemp;
    final targetPath = path.join(dir.path, '${path.basename(imageFile.path)}_resized.jpg');
    final resizedImageFile = File(targetPath)..writeAsBytesSync(img.encodeJpg(correctedImage, quality: 80));

    return resizedImageFile;
  }
}

*/