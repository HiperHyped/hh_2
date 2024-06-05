import 'package:flutter/material.dart';
//import 'package:badges/badges.dart' as badges;
//import 'package:hh_2/src/config/common/var/hh_globals.dart';
//import 'package:hh_2/src/config/common/components/hh_price_tag.dart';
import 'package:hh_2/src/config/common/image/hh_url_image.dart';
import 'package:hh_2/src/models/basket_model.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:hh_2/src/pages/grid/components/prod_card.dart';


class SuggestionTile extends StatelessWidget {
  final EanModel product;
  final SourceOrigin sourceOrigin = SourceOrigin.R;

  SuggestionTile({required this.product});

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



/*
class SuggestionTile extends StatefulWidget {
  final EanModel product;
  final int count;
  

  SuggestionTile({Key? key, required this.product, this.count = 1})
      : super(key: key);


  @override
  _SuggestionTileState createState() => _SuggestionTileState();
}

class _SuggestionTileState extends State<SuggestionTile> {
  bool _showButtons = false;
  double _imageWidth = 0.0;
  double _imageHeight = 0.0;

  void _updateImageDimensions(double width, double height) {
    setState(() {
      print("W: $width , H: $height");
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

  void _onVerticalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity! < -10) {
      HHGlobals.HHBasket.value.addProduct(widget.product);
      HHGlobals.HHBasket.notifyListeners();
    }
    if (details.primaryVelocity! > 10) {
      HHGlobals.HHBasket.value.removeProduct(widget.product);
      HHGlobals.HHBasket.notifyListeners();
    }
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      // Show Dialog Prod card
      onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ProdCard(product: widget.product);
              },
            );
          },
      onVerticalDragEnd: _onVerticalDragEnd, // Alterado aqui
      //3 Botoes + Botao Informação
      /*onTap: () {
        if (!kIsWeb) {
          setState(() {
            _showButtons = !_showButtons;
          });
        }
      },
      child: MouseRegion(
        onEnter: (event) {
          if (kIsWeb) {
            setState(() {
              _showButtons = true;
            });
          }
        },
        onExit: (event) {
          if (kIsWeb) {
            setState(() {
              _showButtons = false;
            });
          }
        },*/
        /*child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Badge(
                    badgeContent: Text(
                      widget.count.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    position: BadgePosition.topEnd(top: -2, end: 0),
                    showBadge: widget.count > 1 ? true : false,
                    child: BasketImage(
                      imagePath: "assets/images/db/${widget.product.imagem}",
                      onImageDimensions: (double width, double height) {},
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildPriceContainer(),
              ],
            ),
            if (_showButtons) _buildButtons(),
          ],
        ),*/
        child: Stack(
          children: [
            badges.Badge(
              badgeContent: Text(
                widget.count.toString(),
                style: TextStyle(color: Colors.white),
              ),
              position: badges.BadgePosition.topEnd(top: -2, end: -0),
              //position: BadgePosition.topEnd(top: -2, end: 0),
              showBadge: widget.count > 1 ? true : false,
              child: HHUrlImage(
                      product: widget.product,
                      onImageDimensions: _updateImageDimensions,),
                /*HHS3Image(
                product: widget.product, 
                onImageDimensions: (double width, double height) {
                  _imageWidth = width;
                  _imageHeight = height;
                  },
                ),*/
                /*HHImage(
                imagePath: "assets/images/db/${widget.product.imagem}",
                onImageDimensions: (double width, double height) {
                  _imageWidth = width;
                  _imageHeight = height;
                },
              ),*/
            ),
            //if (_showButtons) HHButtons(product: widget.product, iconSize: 20,), //Classe HHButtons (3 botoes)
            Align(
              alignment: Alignment.bottomCenter,
              child: HHPriceTag( //Price Tag
                price: double.parse(widget.product.preco) * widget.count,
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 7),
                fontSize: 14,
                maxWidth: _imageWidth,
              ),
            ),
          ],
        ),
      );

  }
}*/


