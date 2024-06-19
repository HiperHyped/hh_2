import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart'; // Importação do HHGlobals
import 'package:hh_2/src/config/common/var/hh_notifiers.dart'; // Importação do HHNotifiers
import 'dart:html' as html;

class UniImageDialog {
  static final picker = ImagePicker();

  static Future<void> getImage(BuildContext context, {required ImageSource source}) async {
    try {
      if (kIsWeb) {
        await getImageWeb(context, source: source);
      } else {
        await getImageMobile(context, source: source);
      }
    } catch (e) {
      showErrorDialog(context, 'Erro ao carregar imagem: $e');
    }
  }

  static Future<void> getImageWeb(BuildContext context, {required ImageSource source}) async {
    try {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        final Uint8List bytes = await pickedFile.readAsBytes();
        final html.Blob blob = html.Blob([bytes]);
        final String url = html.Url.createObjectUrlFromBlob(blob);

        HHGlobals.pictureFileBytes = bytes; // Salvar diretamente como Uint8List
        HHNotifiers.increment(CounterType.PictureCount);

        //showSuccessDialog(context, 'Imagem carregada com sucesso da web!');
      } else {
        //showWarningDialog(context, 'Nenhuma imagem foi selecionada');
      }
    } catch (e) {
      showErrorDialog(context, 'Erro ao carregar imagem da web: $e');
    }
  }

  static Future<void> getImageMobile(BuildContext context, {required ImageSource source}) async {
    try {
      final status = await Permission.photos.request();
      if (status.isGranted) {
        final pickedFile = await picker.pickImage(source: source);
        if (pickedFile != null) {
          final Uint8List bytes = await pickedFile.readAsBytes();
          final Uint8List resizedBytes = _resizeAndFixOrientation(bytes);

          HHGlobals.pictureFileBytes = resizedBytes;
          HHNotifiers.increment(CounterType.PictureCount);

          //showSuccessDialog(context, 'Imagem carregada com sucesso!');
        } else {
          //showWarningDialog(context, 'Nenhuma imagem foi selecionada');
        }
      } else if (status.isPermanentlyDenied) {
        openAppSettings();
      } else {
        //showErrorDialog(context, 'Permissão de galeria negada');
      }
    } catch (e) {
      showErrorDialog(context, 'Erro ao carregar imagem: $e');
    }
  }

  static Uint8List _resizeAndFixOrientation(Uint8List imageBytes) {
    final image = img.decodeImage(imageBytes);
    final resizedImage = img.copyResize(image!, width: 600);
    final correctedImage = img.bakeOrientation(resizedImage);

    return Uint8List.fromList(img.encodeJpg(correctedImage, quality: 80));
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
