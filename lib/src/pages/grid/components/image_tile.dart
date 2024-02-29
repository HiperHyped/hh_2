import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/config/common/image/hh_asset_image.dart';
import 'package:hh_2/src/config/common/components/hh_price_tag.dart';
import 'package:hh_2/src/models/basket_model.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:hh_2/src/pages/grid/components/prod_card.dart';
import 'package:hh_2/src/services/utils.dart';

import '../../../config/common/image/hh_url_image.dart';



//v4 - 02/06/2023
// Classe ImageTile
class ImageTile extends StatefulWidget {
  ImageTile({
    Key? key,
    required this.product,
    required this.selected,
    required this.onPressed,
  }) : super(key: key);

  final EanModel product;
  final bool selected;
  final VoidCallback onPressed;
  final SourceOrigin sourceOrigin = SourceOrigin.G;

  @override
  _ImageTileState createState() => _ImageTileState();
}

class _ImageTileState extends State<ImageTile> {
  
  double _imageWidth = 0.0;
  double _imageHeight = 0.0;

  void _updateImageDimensions(double width, double height) {
    setState(() {
      print("W: $width , H: $height");
      _imageWidth = width;
      _imageHeight = height;
    });
  }

  /*void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (details.primaryDelta! < -10) {
      HHGlobals.basketModelNotifier.value.addProduct(widget.product);
      HHGlobals.basketModelNotifier.notifyListeners();
    }
    if (details.primaryDelta! > 10) {
      HHGlobals.basketModelNotifier.value.decreaseProductQuantity(widget.product);     //addProduct(widget.product);
      HHGlobals.basketModelNotifier.notifyListeners();
    }
  }*/

  void _onVerticalDragEnd(DragEndDetails details) {
  if (details.primaryVelocity! < -10) {
    HHGlobals.HHBasket.value.addProduct(widget.product, widget.sourceOrigin);
    HHGlobals.HHBasket.notifyListeners();
  }
  if (details.primaryVelocity! > 10) {
    HHGlobals.HHBasket.value.removeProduct(widget.product);
    HHGlobals.HHBasket.notifyListeners();
  }
}

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return GestureDetector(
          onDoubleTap: () {
            HHGlobals.HHBasket.value.addProduct(widget.product, widget.sourceOrigin);
            HHGlobals.HHBasket.notifyListeners();
          },
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ProdCard(product: widget.product, sourceOrigin: widget.sourceOrigin,);
              },
            );
          },
          //onVerticalDragUpdate: _onVerticalDragUpdate,
          onVerticalDragEnd: _onVerticalDragEnd, // Alterado aqui

          child: Stack(
            children: [
              // IMAGEM
              Padding(
                padding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: widget.selected
                          ? HHColors.hhColorFirst
                          : Colors.white,
                      width: 2,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: HHUrlImage(
                      product: widget.product,
                      onImageDimensions: _updateImageDimensions,),
                    /*child: HHS3Image(product: widget.product, onImageDimensions: _updateImageDimensions,)*/
                    /*child: HHImage(imagePath:"assets/images/db/${widget.product.imagem}",
                          onImageDimensions: _updateImageDimensions,
                    ),*/
                  ),
                ),
              ),
              // PRATELEIRA
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 20, // Defina a altura da prateleira aqui
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white,
                          Utils.getColorFromCat0(widget.product.sigla.substring(0, 1)),
                          //Colors.brown, // Sua cor inicial aqui
                          //HHColors.hhColorGreyDark
                        ],
                      ),
                    ),
                    child: Center(
                      child: HHPriceTag(
                        price: double.parse(widget.product.preco),
                        maxWidth: constraints.maxWidth,
                      ),
                    ),
                  ),
                ),
              ),

              // PREÇO
              Align(
                alignment: Alignment.bottomCenter,
                child: HHPriceTag(
                  fontSize: 12,
                  padding: EdgeInsets.all(2.0),
                  price: double.parse(widget.product.preco),
                  maxWidth: constraints.maxWidth,
                ),
              ),
            ],
          ),
          
        );
      },
    );
  }
}



// v3
/*class ImageTile extends StatefulWidget {
  ImageTile({
    Key? key,
    required this.product,
    required this.selected,
    required this.onPressed,
  }) : super(key: key);

  final EanModel product;
  final bool selected;
  final VoidCallback onPressed;

  @override
  _ImageTileState createState() => _ImageTileState();
}

class _ImageTileState extends State<ImageTile> {
  ValueNotifier<Size> _imageSizeNotifier = ValueNotifier<Size>(Size.zero);

  void _updateImageDimensions(double width, double height) {
    _imageSizeNotifier.value = Size(width, height);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        HHGlobals.basketModelNotifier.value.addProduct(widget.product);
        HHGlobals.basketModelNotifier.notifyListeners();
      },
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ProdCard(product: widget.product);
          },
        );
      },
      child: Stack(
        children: [
          // IMAGEM
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.selected ? HHColors.hhColorFirst : Colors.white,
                  width: 2,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: HHImage(
                  imagePath: "assets/images/db/${widget.product.imagem}",
                  onImageDimensions: _updateImageDimensions,
                ),
              ),
            ),
          ),
          // PREÇO
          ValueListenableBuilder<Size>(
            valueListenable: _imageSizeNotifier,
            builder: (BuildContext context, Size imageSize, Widget? child) {
              if (imageSize.width > 0 && imageSize.height > 0) {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: HHPriceTag(
                    price: double.parse(widget.product.preco),
                    maxWidth: imageSize.width,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}*/


//v2
/*class ImageTile extends StatefulWidget {
  ImageTile({
    Key? key,
    required this.product,
    required this.selected,
    required this.onPressed,
  }) : super(key: key);

  final EanModel product;
  final bool selected;
  final VoidCallback onPressed;

  @override
  _ImageTileState createState() => _ImageTileState();
}

class _ImageTileState extends State<ImageTile> {
  double _imageWidth = 0.0;
  double _imageHeight = 0.0;

  void _updateImageDimensions(double width, double height) {
    setState(() {
      _imageWidth = width;
      _imageHeight = height;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        HHGlobals.basketModelNotifier.value.addProduct(widget.product);
        HHGlobals.basketModelNotifier.notifyListeners();
      },
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ProdCard(product: widget.product);
          },
        );
      },
      child: Stack(
        children: [
          // IMAGEM
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.selected ? HHColors.hhColorFirst : Colors.white,
                  width: 2,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: HHImage(
                  imagePath: "assets/images/db/${widget.product.imagem}",
                  onImageDimensions: _updateImageDimensions,
                ),
              ),
            ),
          ),
          // PREÇO
           LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (_imageWidth > 0 && _imageHeight > 0) {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: HHPriceTag(
                    price: double.parse(widget.product.preco),
                    maxWidth: _imageWidth,
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
          /*Align(
            alignment: Alignment.bottomCenter,
            child: HHPriceTag(
              price: double.parse(widget.product.preco),
              maxWidth: _imageWidth,
            ),
          ),*/
        ],
      ),
    );
  }
}*/

//v1
/*class ImageTile extends StatelessWidget {
  
  ImageTile({
    Key? key,
    required this.product,
    required this.selected,
    required this.onPressed,
  }) : super(key: key);

  final EanModel product;
  final bool selected;
  final VoidCallback onPressed;
  double _imageWidth = 0.0;
  double _imageHeight = 0.0;


  final UtilsServices utilsServices = UtilsServices();

  //final String path = 

  @override

  
  Widget build(BuildContext context) {

    

    return GestureDetector(
      //onTap: onPressed,
      onDoubleTap: () {
        // Adiciona o produto ao carrinho quando ocorre um double tap
        HHGlobals.basketModelNotifier.value.addProduct(product);
        HHGlobals.basketModelNotifier.notifyListeners();
      },
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ProdCard(product: product);
          },
        );
},

      child: Stack(
        children: [ 
            //IMAGEM
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected? HHColors.hhColorFirst : Colors.white,
                    width: 2,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: HHImage(
                      imagePath: "assets/images/db/${product.imagem}",
                      onImageDimensions: (double width, double height) {
                        _imageWidth = width;
                        _imageHeight = height;
                      },
                    ),
                  ),
                ),
              ),
    
            //PREÇO
            HHPriceTag(
              price: double.parse(product.preco), 
              maxWidth: _imageWidth
            ),
          ],     
        ),
    );
  }
}*/