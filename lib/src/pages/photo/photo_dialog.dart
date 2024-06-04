import 'package:flutter/material.dart';
import 'package:hh_2/src/config/ai/ai_photo.dart';
import 'package:hh_2/src/config/common/components/hh_button.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class PhotoDialog extends StatefulWidget {
  @override
  _PhotoDialogState createState() => _PhotoDialogState();
}

class _PhotoDialogState extends State<PhotoDialog> {
  File? _image;
  final picker = ImagePicker();

  Future<void> _getImage() async {
    // Solicitar permissões
    final status = await Permission.camera.request();

    if (status.isGranted) {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        }
      });
    } else {
      // Se a permissão não for concedida, você pode mostrar uma mensagem ou realizar outra ação
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permissão de câmera negada')),
      );
    }
  }

  File _resizeAndFixOrientation(File imageFile) {
    // Redimensionar a imagem
    final image = img.decodeImage(imageFile.readAsBytesSync());
    final resizedImage = img.copyResize(image!, width: 600);

    // Corrigir orientação
    final correctedImage = img.bakeOrientation(resizedImage);

    final dir = Directory.systemTemp;
    final targetPath = path.join(dir.path, '${path.basename(imageFile.path)}_resized.jpg');
    final resizedImageFile = File(targetPath)..writeAsBytesSync(img.encodeJpg(correctedImage, quality: 85));

    return resizedImageFile;
  }

  @override
  void initState() {
    super.initState();
    _getImage(); // Automatically opens the camera when the dialog is shown
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
          maxHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: HHColors.hhColorFirst,
              width: 4,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: _image == null
                    ? Center(child: CircularProgressIndicator())
                    : Image.file(_image!),
              ),
              Container(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  HHButton(
                    label: 'Repetir',
                    onPressed: () {
                      _getImage(); // Voltar à câmera para tirar outra foto
                    },
                  ),
                  HHButton(
                    label: 'Aceitar',
                    onPressed: () {
                      if (_image != null) {
                        final resizedImage = _resizeAndFixOrientation(_image!);
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AIPhoto(image: resizedImage), // Certifique-se de que AIPhoto está corretamente importado e definido
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
