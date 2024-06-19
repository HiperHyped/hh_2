import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:hh_2/src/config/common/var/hh_enum.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
//import 'package:hh_2/src/config/common/components/hh_price_tag.dart';
import 'package:hh_2/src/config/common/image/hh_url_image.dart';
import 'package:hh_2/src/models/basket_model.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:hh_2/src/pages/grid/components/prod_card.dart';



class BasketTile extends StatefulWidget {
  final EanModel product;
  final int count;
  final SourceOrigin sourceOrigin = SourceOrigin.G;

  BasketTile({Key? key, required this.product, required this.count})
      : super(key: key);

  @override
  _BasketTileState createState() => _BasketTileState();
}

class _BasketTileState extends State<BasketTile> {
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
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ProdCard(
              product: widget.product,
              sourceOrigin: widget.sourceOrigin,
            );
          },
        );
      },
      onVerticalDragEnd: _onVerticalDragEnd,
      child: Stack(
        children: [
          ValueListenableBuilder<BasketModel>(
            valueListenable: HHGlobals.HHBasket,
            builder: (context, basketModel, child) {
              int count = basketModel.productQuantities[widget.product] ?? 0;
              return badges.Badge(
                badgeContent: Text(
                  count.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
                position: badges.BadgePosition.topEnd(top: -2, end: -0),
                showBadge: count > 1 ? true : false,
                child: HHUrlImage(
                  product: widget.product,
                  onImageDimensions: _updateImageDimensions,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}


          ///priceTAG
          /*Align(
            alignment: Alignment.bottomCenter,
            child: ValueListenableBuilder<BasketModel>(
              valueListenable: HHGlobals.HHBasket,
              builder: (context, basketModel, child) {
                int count = basketModel.productQuantities[widget.product] ?? 0;
                double price = double.parse(widget.product.preco) * count;
                return HHPriceTag(
                  price: price,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 7),
                  fontSize: 14,
                  maxWidth: _imageWidth,
                );
              },
            ),
          ),*/


////////////  31/10/23
///
/*
class BasketTile extends StatefulWidget {
  final EanModel product;
  final int count;
  final SourceOrigin sourceOrigin = SourceOrigin.C;
  

  BasketTile({Key? key, required this.product, required this.count})
      : super(key: key);


  @override
  _BasketTileState createState() => _BasketTileState();
}

class _BasketTileState extends State<BasketTile> {
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
    if (details.primaryVelocity! < -5) {
      HHGlobals.HHBasket.value.addProduct(widget.product, widget.sourceOrigin);
      HHGlobals.HHBasket.notifyListeners();
    }
    if (details.primaryVelocity! > 5) {
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
                return ProdCard(product: widget.product, sourceOrigin: widget.sourceOrigin);
              },
            );
          },
          
      onVerticalDragEnd: _onVerticalDragEnd, // Alterado aqui
        child: Stack(
          children: [
            badges.Badge(
              badgeContent: Text(
                widget.count.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              position: badges.BadgePosition.topEnd(top: -2, end: -0),
              showBadge: widget.count > 1 ? true : false,
              child: HHUrlImage(
                      product: widget.product,
                      onImageDimensions: _updateImageDimensions,),
            ),
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

            //if (_showButtons) HHButtons(product: widget.product, iconSize: 20,), //Classe HHButtons (3 botoes)


/*class BasketTile extends StatelessWidget {
  final EanModel product;
  final int count;

  BasketTile({Key? key, required this.product, required this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Badge(
          badgeContent: Text(
              count.toString(),
              style: TextStyle(color: Colors.white),
            ),
          position: BadgePosition.topEnd(top: -2, end: -3),
          //badgeColor: HHColors.hhColorFirst,
          showBadge: count > 1? true : false,
          child: Image.asset(
            "assets/images/db/${product.imagem}",
            fit: BoxFit.fitWidth,
          ),
        ),

        Positioned(
          top: 22,
          right:0,
          child: _buildButton(
            icon: Icons.add,
            color: Colors.green,
            onTap: () {
              HHGlobals.basketModelNotifier.value
                  .increaseProductQuantity(product);
              HHGlobals.basketModelNotifier.notifyListeners();
            },
          ),
        ),
        Positioned(
          top: 44, // Controla a distância vertical entre os botões
          right: 0,
          child: _buildButton(
            icon: Icons.remove,
            color: Colors.orange,
            onTap: () {
              HHGlobals.basketModelNotifier.value
                  .decreaseProductQuantity(product);
              HHGlobals.basketModelNotifier.notifyListeners();
            },
          ),
        ),

        Positioned(
          top: 66, // Controla a distância vertical entre os botões
          right: 0,
          child: _buildButton(
            icon: Icons.delete,
            color: Colors.purple,
            onTap: () {
              HHGlobals.basketModelNotifier.value
                  .removeAllOfProduct(product);
              HHGlobals.basketModelNotifier.notifyListeners();
            },
          ),
        ),
       /* _buildButton(
                icon: Icons.add,
                color: Colors.green,
                badgePosition: BadgePosition.topEnd(top: -20, end: -3), 
                onTap: () {
                  HHGlobals.basketModelNotifier.value.increaseProductQuantity(product);
                  HHGlobals.basketModelNotifier.notifyListeners();
                },
              ),
        _buildButton(
                icon: Icons.delete,
                color: Colors.orange,
                badgePosition: BadgePosition.topEnd(top: -10, end: -3), 
                onTap: () {
                  HHGlobals.basketModelNotifier.value.removeAllOfProduct(product);
                  HHGlobals.basketModelNotifier.notifyListeners();
                }, 
              ),*/
        
      ],
    );
  }


Widget _buildButton({
  required IconData icon,
  required Color color,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Badge(
      badgeContent: Icon(icon, size: 12, color: Colors.white),
      badgeColor: color,
      shape: BadgeShape.circle
    ),
  );
}

}*/




/*class BasketTile extends StatefulWidget {
  final EanModel product;
  final int count;

  BasketTile({Key? key, required this.product, required this.count})
      : super(key: key);



  @override
  _BasketTileState createState() => _BasketTileState();
}

class _BasketTileState extends State<BasketTile> {
  bool _showButtons = false;
  double _imageWidth = 0;
  double _imageHeight = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!kIsWeb) {
          setState(() {
            _showButtons = !_showButtons;
            print("OnTap: $_showButtons");
            print("OnTap: ${_imageWidth} x ${_imageHeight}");
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

          // Set a timer to hide the buttons after 2 seconds
          /*Timer(const Duration(seconds: 2), () {
            setState(() {
              _showButtons = false;
            });
          });*/
        },
        onExit: (event) {
          if (kIsWeb) {
            setState(() {
              _showButtons = false;
            });
          }
        },
        child: Stack(
           children: [
              Badge(
                badgeContent: Text(
                    widget.count.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                position: BadgePosition.topEnd(top: -2, end: 0),
                //badgeColor: HHColors.hhColorFirst,
                showBadge: widget.count > 1? true : false,
                //child: 
                
                
                /*Image.asset(
                  "assets/images/db/${widget.product.imagem}",
                  fit: BoxFit.fitWidth,
                ),*/
          
                child: BasketImage(
                  imagePath: "assets/images/db/${widget.product.imagem}",
                  onImageDimensions: (double width, double height) {
                    setState(() {
                      _imageWidth = width;
                      _imageHeight = height;
                      print("Basket Image: $width x $height");
                    });
                  },
                ),
              ),
          
              if (_showButtons)
                Positioned(
                  top: _imageHeight/2 - 22,
                  right: _imageWidth/2 - 10 ,
                  child: _buildButton(
                    icon: Icons.add_circle_outline,
                    color: Colors.green,
                    onTap: () {
                      HHGlobals.basketModelNotifier.value
                          .increaseProductQuantity(widget.product);
                      HHGlobals.basketModelNotifier.notifyListeners();
                      //print("Add: ${_imageWidth} x ${_imageHeight}");
                    },
                  ),
                ),
              if (_showButtons)
                Positioned(
                  top: _imageHeight/2 - 2, // Controla a distância vertical entre os botões
                  right: _imageWidth/2 - 10 ,
                  child: _buildButton(
                    icon: Icons.remove_circle_outline,
                    color: Colors.orange,
                    onTap: () {
                      HHGlobals.basketModelNotifier.value
                          .decreaseProductQuantity(widget.product);
                      HHGlobals.basketModelNotifier.notifyListeners();
                      print("Remove: ${_imageWidth} x ${_imageHeight}");
                    },
                  ),
                ),
              if (_showButtons)
                Positioned(
                  top: _imageHeight/2 + 18 , // Controla a distância vertical entre os botões
                  right: _imageWidth/2 - 10 ,
                  child: _buildButton(
                    icon: Icons.cancel_outlined,
                    color: Colors.purple,
                    onTap: () {
                      HHGlobals.basketModelNotifier.value
                          .removeAllOfProduct(widget.product);
                      HHGlobals.basketModelNotifier.notifyListeners();
                    },
                  ),
                ),
              const SizedBox(height: 8), // Adicione um espaço entre a imagem e o subtotal

              /*  Text(
                  NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
                        .format(double.parse(widget.product.preco) * widget.count),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),*/
                
              Container(
              padding: const EdgeInsets.fromLTRB(0,0,0,7),
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(2.0),
                decoration:  BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 2,
                    color: HHColors.hhColorFirst,
                      
                    ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: HHColors.hhColorFirst,
                      blurRadius: 8,
                      spreadRadius: 3,
                    )
                  ]
                ),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    //"R\$ ${product.preco}",
                    //NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(product.preco),
                    //utilsServices.priceToCurrency(0),
                    NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(double.parse(widget.product.preco) * widget.count),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: HHColors.hhColorFirst,
                      ),
                    ),
                ),
              ),

              ),
            ],
          ),
      ),  
    );   
  }

  Widget _buildButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: Icon(icon, size: 18, color: Colors.white),
      ),
    );
  }
}*/




/*class BasketTile extends StatelessWidget {
  final EanModel product;
  final int count;

  BasketTile({Key? key, required this.product, required this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kBottomNavigationBarHeight,
      child: Column(
        children: [
          Stack(
            children: [
              Badge(
                badgeContent: Text(
                  count.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                position: BadgePosition.topEnd(top: -2, end: -3),
                showBadge: count > 1 ? true : false,
                child: 
                  Transform.scale(
                    scale: 0.7,
                    child: Image.asset(
                      "assets/images/db/${product.imagem}",
                      fit: BoxFit.fitHeight,
                    ),
                  ),
              ),
            ],
          ),
          /*SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(
                icon: Icons.add,
                color: Colors.green,
                onTap: () {
                  HHGlobals.basketModelNotifier.value.increaseProductQuantity(product);
                  HHGlobals.basketModelNotifier.notifyListeners();
                },
              ),
              //SizedBox(width: 8.0),
              _buildButton(
                icon: Icons.remove,
                color: Colors.red,
                onTap: () {
                  HHGlobals.basketModelNotifier.value.decreaseProductQuantity(product);
                  HHGlobals.basketModelNotifier.notifyListeners();
                },
              ),
              //SizedBox(width: 8.0),
              _buildButton(
                icon: Icons.delete,
                color: Colors.orange,
                onTap: () {
                  HHGlobals.basketModelNotifier.value.removeAllOfProduct(product);
                  HHGlobals.basketModelNotifier.notifyListeners();
                },
              ),
            ],
          ),*/
        ],
      ),
    );
  }

  Widget _buildButton({required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Badge(
        badgeContent: Icon(icon, size: 12, color: Colors.white),
        badgeColor: color,
        shape: BadgeShape.circle,
      ),
    );
  }
}*/


/*
        // Badge verde (top right) com o número de vezes que o produto foi colocado na lista
        Positioned(
          top: 0,
          right: 0,
          child: Badge(
            badgeColor: Colors.green,
            badgeContent: Text(
              'X${HHGlobals.basketModel.getProductCount(product)}',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        // Badge vermelho com um X (bottom right) que remove uma unidade do produto
        Positioned(
          bottom: 0,
          right: 0,
          child: Badge(
            badgeColor: Colors.red,
            badgeContent: Icon(
              Icons.close,
              color: Colors.white,
              size: 14,
            ),
            onPressed: () {
              HHGlobals.basketModel.removeOneProduct(product);
            },
          ),
        ),

*/


/*class BasketTile extends StatelessWidget {
  final EanModel product;
  final int count;

  BasketTile({required this.product, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        children: [
          Stack(
            children: [
              Badge(
                badgeContent: Text('$count', style: TextStyle(color: Colors.white)),
                child: Image.asset(
                  "assets/images/db/${product.imagem}",
                  fit: BoxFit.fitWidth,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    HHGlobals.basketModelNotifier.value.decreaseProductQuantity(product);
                    HHGlobals.basketModelNotifier.notifyListeners();
                  },
                  child: Badge(
                    badgeContent: Icon(Icons.close, size: 12, color: Colors.white),
                    badgeColor: Colors.red,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  HHGlobals.basketModelNotifier.value.increaseProductQuantity(product);
                  HHGlobals.basketModelNotifier.notifyListeners();
                },
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Icon(Icons.add, size: 18, color: Colors.white),
                ),
              ),
              InkWell(
                onTap: () {
                  HHGlobals.basketModelNotifier.value.decreaseProductQuantity(product);
                  HHGlobals.basketModelNotifier.notifyListeners();
                },
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Icon(Icons.remove, size: 18, color: Colors.white),
                ),
              ),
              InkWell(
                onTap: () {
                  HHGlobals.basketModelNotifier.value.removeAllOfProduct(product);
                  HHGlobals.basketModelNotifier.notifyListeners();
                },
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Icon(Icons.delete, size: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}*/