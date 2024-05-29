import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
//import 'ai_photo.dart';

class PhotoDialog extends StatefulWidget {
  @override
  _PhotoDialogState createState() => _PhotoDialogState();
}

class _PhotoDialogState extends State<PhotoDialog> {
  File? _image;
  final picker = ImagePicker();

  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getImage(); // Automatically opens the camera when the dialog is shown
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _getImage,
                    child: Text('Tirar Outra'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_image != null) {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Container(), //AIPhoto(image: _image!),
                          ),
                        );
                      }
                    },
                    child: Text('Aceitar'),
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
