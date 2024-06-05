//import 'dart:async';
//import 'dart:ui';
import 'package:flutter/material.dart';


// Classe HHAssetImage

class HHAssetImage extends StatefulWidget {
  final String imagePath;
  final Function(double width, double height) onImageDimensions;

  HHAssetImage({Key? key, required this.imagePath, required this.onImageDimensions}) : super(key: key);

  @override
  _HHImageState createState() => _HHImageState();
}

class _HHImageState extends State<HHAssetImage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getImageDimensions();
    });
  }

  void _getImageDimensions() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    widget.onImageDimensions(size.width, size.height);
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      widget.imagePath,
      fit: BoxFit.fitWidth,
      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
        return Container();
      },
    );
  }
}


/*class HHAssetImage extends StatefulWidget {
  final String imagePath;
  final Function(double width, double height) onImageDimensions;

  
  HHAssetImage({Key? key, required this.imagePath, required this.onImageDimensions}) : super(key: key);

  @override
  _HHImageState createState() => _HHImageState();
}

class _HHImageState extends State<HHAssetImage> {
  @override
  void initState() {
    super.initState();
    _getImageDimensions();
  }

void _getImageDimensions() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final width = context.size!.width;
    final height = context.size!.height;
    widget.onImageDimensions(width, height);
  });
}

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      widget.imagePath,
      fit: BoxFit.fitWidth,
      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {    
        return Container(); // Você também pode usar "const SizedBox()" para retornar um espaço vazio
      },
    );
  }
}*/