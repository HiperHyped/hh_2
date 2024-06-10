import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'photo_tile.dart';

class PhotoBar extends StatefulWidget {
  final List<EanModel> eanProductList;

  PhotoBar({required this.eanProductList});

  @override
  _PhotoBarState createState() => _PhotoBarState();
}

class _PhotoBarState extends State<PhotoBar> {
  final innerController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      color: HHColors.hhColorGreyLight,
      child: Scrollbar(
        controller: innerController,
        thumbVisibility: false,
        child: Listener(
          onPointerSignal: (event) {
            if (event is PointerScrollEvent) {
              final offset = event.scrollDelta.dy;
              innerController.jumpTo(innerController.offset + offset);
            }
          },
          child: ListView.builder(
            controller: innerController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.eanProductList.length,
            itemBuilder: (BuildContext context, int index) {
              EanModel product = widget.eanProductList[index];
              return PhotoTile(product: product);
            },
          ),
        ),
      ),
    );
  }
}
