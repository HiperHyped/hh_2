import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/image/hh_url_image.dart';
import 'package:hh_2/src/models/basket_model.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:hh_2/src/pages/grid/components/prod_card.dart';

class HistoryTile extends StatelessWidget {
  final EanModel product;
  final int count;
  final SourceOrigin sourceOrigin = SourceOrigin.H;

  HistoryTile({required this.product, required this.count});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ProdCard(product: product, sourceOrigin: sourceOrigin);
          },
        );
      },
      child: HHUrlImage(
        product: product,
        onImageDimensions: (double width, double height) {},
      ),
    );
  }
}

