import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/components/hh_icon_button.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/config/common/var/hh_enum.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/config/common/var/hh_notifiers.dart';
//import 'package:hh_2/src/models/basket_model.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:hh_2/src/models/picture_model.dart';
import 'package:hh_2/src/pages/picture/picture_tile.dart';


class PictureCard extends StatefulWidget {
  final PictureModel picture;
  final int count;
  final bool isExpanded;
  final bool isShrunk;
  final VoidCallback onTap;
  final SourceOrigin sourceOrigin = SourceOrigin.I;

  PictureCard({
    required this.picture,
    required this.count,
    required this.onTap,
    this.isShrunk = false,
    this.isExpanded = false,
  });

  @override
  _PictureCardState createState() => _PictureCardState();
}

class _PictureCardState extends State<PictureCard> {
  Widget buildTextColumn() {
    return Container(
      width: 100, // Ajustar conforme necessário
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.memory(
            widget.picture.imageRedux, // Uint8List da imagem inicial
            width: 90,
            height: 90,
          ),
          /*Text(
            DateFormat('dd/MM/yyyy').format(widget.picture.products.basketTime!),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),*/
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: widget.isExpanded
            ? MediaQuery.of(context).size.width - 8
            : (widget.isShrunk ? 20 : 100),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: HHColors.getColor(Functions.image),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: widget.isExpanded
              ? Row(
                  children: [
                    buildTextColumn(),
                    Expanded(
                      child: widget.isExpanded
                          ? Row(
                              children: [
                                Container(
                                  color: HHColors.hhColorGreyLight,
                                  padding: EdgeInsets.symmetric(horizontal: 2),
                                  width: 25,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: HHIconButton(
                                          iconColor: widget.picture.basket.cartLastPressed == 1
                                              ? HHColors.hhColorDarkFirst
                                              : HHColors.hhColorGreyDark,
                                          icon: Icons.shopping_cart_outlined,
                                          onPressed: () {
                                            HHGlobals.HHBasket.value.addProductList(
                                                widget.picture.basket.products, 
                                                widget.sourceOrigin
                                            );
                                            HHNotifiers.counter[CounterType.BasketCount]!.value =
                                                HHGlobals.HHBasket.value.groupProducts().length;
                                            setState(() {
                                              widget.picture.basket.cartLastPressed = 1;
                                            });
                                          },
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: HHIconButton(
                                          iconColor: widget.picture.basket.cartLastPressed == 0
                                              ? HHColors.hhColorBack
                                              : HHColors.hhColorGreyDark,
                                          icon: Icons.remove_shopping_cart_outlined,
                                          onPressed: () {
                                            HHGlobals.HHBasket.value.removeAllOfProductList(
                                                widget.picture.basket.products
                                            );
                                            HHNotifiers.counter[CounterType.BasketCount]!.value =
                                                HHGlobals.HHBasket.value.groupProducts().length;
                                            setState(() {
                                              widget.picture.basket.cartLastPressed = 0;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: HHColors.hhColorGreyLight,
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: widget.picture.basket.products.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        EanModel product = widget.picture.basket.products[index];
                                        int quantity = widget.picture.basket.productQuantities[product] ?? 1;
                                        return PictureTile(product: product, count: quantity);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                    ),
                  ],
                )
              : Container(
                  width: widget.isShrunk ? 20 : 100,
                  child: widget.isShrunk
                      ? Text(
                          "${widget.count}",
                          style: const TextStyle(color: Colors.white),
                        )
                      : buildTextColumn(),
                ),
        ),
      ),
    );
  }
}
