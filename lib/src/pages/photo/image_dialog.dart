import 'package:flutter/material.dart';
import 'package:hh_2/src/config/ai/ai_photo.dart';
import 'package:hh_2/src/config/common/components/hh_button.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

class ImageDialog extends StatefulWidget {
  @override
  _ImageDialogState createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog> {
  File? _image;
  final picker = ImagePicker();

  Future<void> _getImage() async {
    // Solicitar permissões de armazenamento
    PermissionStatus storageStatus = await Permission.storage.status;
    if (storageStatus.isDenied || storageStatus.isRestricted || storageStatus.isPermanentlyDenied) {
      storageStatus = await Permission.storage.request();
      if (storageStatus.isPermanentlyDenied) {
        bool opened = await openAppSettings();
        if (!opened) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Por favor, conceda a permissão de armazenamento nas configurações do aplicativo.')),
          );
        }
        return;
      }
    }

    // Solicitar permissão de fotos
    PermissionStatus photosStatus = await Permission.photos.status;
    if (photosStatus.isDenied || photosStatus.isRestricted || photosStatus.isPermanentlyDenied) {
      photosStatus = await Permission.photos.request();
      if (photosStatus.isPermanentlyDenied) {
        bool opened = await openAppSettings();
        if (!opened) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Por favor, conceda a permissão de fotos nas configurações do aplicativo.')),
          );
        }
        return;
      }
    }

    if (photosStatus.isGranted) {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permissão de galeria negada')),
      );
    }
  }

  File _resizeAndFixOrientation(File imageFile) {
    final image = img.decodeImage(imageFile.readAsBytesSync());
    final resizedImage = img.copyResize(image!, width: 600);
    final correctedImage = img.bakeOrientation(resizedImage);
    final dir = Directory.systemTemp;
    final targetPath = path.join(dir.path, '${path.basename(imageFile.path)}_resized.jpg');
    final resizedImageFile = File(targetPath)..writeAsBytesSync(img.encodeJpg(correctedImage, quality: 85));

    return resizedImageFile;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getImage();
    });
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
                      _getImage();
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
                            builder: (context) => AIPhoto(image: resizedImage),
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
