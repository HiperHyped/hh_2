import 'package:flutter/material.dart';
//import 'package:badges/badges.dart' as badges;
//import 'package:hh_2/src/config/common/var/hh_globals.dart';
//import 'package:hh_2/src/config/common/components/hh_price_tag.dart';
import 'package:hh_2/src/config/common/image/hh_url_image.dart';
import 'package:hh_2/src/config/common/var/hh_enum.dart';
import 'package:hh_2/src/models/basket_model.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:hh_2/src/pages/grid/components/prod_card.dart';




class BookTile extends StatelessWidget {
  final EanModel product;
  final SourceOrigin sourceOrigin = SourceOrigin.B;

  BookTile({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ProdCard(product: product, sourceOrigin: sourceOrigin,);
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
