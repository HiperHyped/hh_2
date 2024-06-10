import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:hh_2/src/config/common/image/hh_url_image.dart';
import 'package:hh_2/src/models/ean_model.dart';

class PhotoTile extends StatefulWidget {
  final EanModel product;

  PhotoTile({Key? key, required this.product}) : super(key: key);

  @override
  _PhotoTileState createState() => _PhotoTileState();
}

class _PhotoTileState extends State<PhotoTile> {
  double _imageWidth = 0.0;
  double _imageHeight = 0.0;

  void _updateImageDimensions(double width, double height) {
    setState(() {
      _imageWidth = width;
      _imageHeight = height;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Implementar a lógica para exibir detalhes do produto se necessário
      },
      child: Stack(
        children: [
          badges.Badge(
            badgeContent: Text(
              widget.product.nome,
              style: const TextStyle(color: Colors.white),
            ),
            position: badges.BadgePosition.topEnd(top: -2, end: -0),
            child: HHUrlImage(
              product: widget.product,
              onImageDimensions: _updateImageDimensions,
            ),
          ),
        ],
      ),
    );
  }
}
