import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hh_2/src/config/ai/ai_xerxes.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/models/basket_model.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:hh_2/src/models/suggestion_model.dart';
import 'package:hh_2/src/pages/basket/basket_tile.dart';
import 'package:hh_2/src/services/utils.dart';


class BasketBar extends StatefulWidget {
  final ValueNotifier<double> totalPriceNotifier; // Adicione esta linha
  

  BasketBar({required this.totalPriceNotifier}); // Modifique o construtor

  @override
  _BasketBarState createState() => _BasketBarState();
}
class _BasketBarState extends State<BasketBar> {
  final innerController = ScrollController(); // Adicione esta linha.
  
  @override
  void initState() {
    super.initState();

    HHGlobals.HHBasket.value.setOnBasketChangedCallback((newTotalPrice) async {
      widget.totalPriceNotifier.value = newTotalPrice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<BasketModel>(
      valueListenable: HHGlobals.HHBasket,
      builder: (context, basketModel, child) {
        //double totalPrice = basketModel.totalPrice(); // Calcule o valor total
        //widget.totalPriceNotifier.value = totalPrice; // Atualize o totalPriceNotifier
        //HHGlobals.HHBasket.value.setOnBasketChangedCallback((newTotalPrice) async {
        //  widget.totalPriceNotifier.value = newTotalPrice;
        //});

        //double totalPrice = basketModel.totalPrice(); // Calcule o valor total
        //widget.totalPriceNotifier.value = totalPrice; // Atualize o totalPriceNotifier

        return Container(
          padding: const EdgeInsets.all(2.0),
          //height: 150,
          color: HHColors.hhColorGreyLight,
          child: Scrollbar(
            controller: innerController, // Adicione esta linha
            thumbVisibility: false, // Adicione esta linha
            child: Listener( //adicione esse listener (ChatGPT)
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  final offset = event.scrollDelta.dy;
                  innerController.jumpTo(innerController.offset + offset);
                }
              },
              child: ListView.builder(
                controller: innerController, // Adicione esta linha
                scrollDirection: Axis.horizontal,
                itemCount: HHGlobals.HHBasket.value.groupProducts().length,
                itemBuilder: (BuildContext context, int index) {
                  EanModel product = HHGlobals.HHBasket.value.groupProducts().keys.elementAt(index);
                  int count = HHGlobals.HHBasket.value.groupProducts()[product]!;
                  return BasketTile(product: product, count: count);
                },
              ),
            ),
          )
        );
      },
    );
  }
}





//anterior1
/*class BasketBar extends StatefulWidget {
  final List<EanModel> cartItems;

  BasketBar({Key? key, required this.cartItems}) : super(key: key);

  @override
  _BasketBarState createState() => _BasketBarState();
}

class _BasketBarState extends State<BasketBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, // Defina a altura da sua preferência
      child: ListView.builder(
        itemCount: widget.cartItems.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.cartItems[index].nome),
          );
        },
      ),
    );
  }
}*/
//anterior 2
/*class BasketBar extends StatefulWidget {
  @override
  _BasketBarState createState() => _BasketBarState();
}

class _BasketBarState extends State<BasketBar> {
  List<EanModel> _basketItems = [];

  void addToBasket(EanModel product) {
    setState(() {
      _basketItems.add(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: HHColors.hhColorFirst,
      child: Row(
        children: _basketItems
            .map(
              (product) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "assets/images/db/${product.imagem}",
                  fit: BoxFit.fitWidth,
                  height: 40,
                  width: 40,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}*/

//anterior 3 
/*class BasketBar extends StatefulWidget {
  @override
  _BasketBarState createState() => _BasketBarState();
}

class _BasketBarState extends State<BasketBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      color: HHColors.hhColorGreyMedium,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: HHGlobals.basketModel.products.length,
        itemBuilder: (BuildContext context, int index) {
          EanModel product = HHGlobals.basketModel.products[index];
          return Padding(
            padding: const EdgeInsets.all(3.0),
            child: Row(
              children: [
                Image.asset(
                  "assets/images/db/${product.imagem}",
                  //width: 40,
                  //height: 40,
                  fit: BoxFit.cover,
                ),
                /*SizedBox(width: 8),
                Text(
                  UtilsServices.capitalizeInitials(product.nome),
                  style: TextStyle(color: Colors.white),
                ),*/
              ],
            ),
          );
        },
      ),
    );
  }
}*/

//anterior 4
/*class BasketBar extends StatefulWidget {
  final ValueNotifier<int> basketCount;

  BasketBar({Key? key, required this.basketCount}) : super(key: key);

  @override
  _BasketBarState createState() => _BasketBarState();
}

class _BasketBarState extends State<BasketBar> {
  final double minHeight = 0.0;
  final double maxHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.basketCount,
      builder: (context, int value, _) {
        return DraggableScrollableSheet(
          minChildSize: value == 0 ? minHeight : maxHeight,
          initialChildSize: value == 0 ? minHeight : maxHeight,
          maxChildSize: maxHeight,
          builder: (context, scrollController) {
            return Container(
              color: Colors.blueAccent,
              height: 120,
              child: 
              
              ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: HHGlobals.basketModelNotifier.value.groupProducts().length,
                itemBuilder: (BuildContext context, int index) {
                  EanModel product = HHGlobals.basketModelNotifier.value.groupProducts().keys.elementAt(index);
                  int count = HHGlobals.basketModelNotifier.value.groupProducts()[product]!;
                  return BasketTile(product: product, count: count);
                },
              )
            );
          },
        );
      },
    );
  }
}*/

//anterior 5 (funcionando)
/*class BasketBar extends StatefulWidget {
  @override
  _BasketBarState createState() => _BasketBarState();
}*/

   /*ListView.builder(
            itemCount: basketModel.products.length,
            scrollDirection: Axis.horizontal,
            reverse: true,
            itemBuilder: (context, index) {
              final product = basketModel.products[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 2.0),
                child: BasketTile(product: product,)
                /*Row(
                  children: [
                    Image.asset(
                      "assets/images/db/${product.imagem}",
                      //width: 40,
                      //height: 40,
                      fit: BoxFit.cover,
                    ),
                    /*SizedBox(width: 8),
                    Text(
                      UtilsServices.capitalizeInitials(product.nome),
                      style: TextStyle(color: Colors.white),
                    ),*/
                  ],
                ),*/
              );
            },
          ),*/

