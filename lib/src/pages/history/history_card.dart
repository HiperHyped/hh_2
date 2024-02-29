import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/components/hh_icon_button.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/config/common/var/hh_notifiers.dart';
import 'package:hh_2/src/config/common/var/hh_var.dart';
import 'package:hh_2/src/config/db/db_history.dart';
import 'package:hh_2/src/models/basket_model.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:hh_2/src/pages/basket/basket_tile.dart';
import 'package:intl/intl.dart';

class HistoryCard extends StatefulWidget {
  final BasketModel basket;
  final int count;
  final bool isExpanded;
  final bool isShrunk;
  final VoidCallback onTap;
  final SourceOrigin sourceOrigin = SourceOrigin.H;

  HistoryCard({
    required this.basket, 
    required this.count, 
    required this.onTap, 
    this.isShrunk = false, 
    this.isExpanded = false});

  @override
  _HistoryCardState createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {

  final DBHistory _dbHistory = DBHistory();

  void loadBasketDetails() async {
    await _dbHistory.getBasketDetails(widget.basket.basket_id, HHGlobals.HHUserHistory.value);
    setState(() {});  // Atualiza o estado para refletir as mudanças nos detalhes do cesto.
  }
   
  Widget buildTextColumn() {
    return Container(
      width: HHVar.sugWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Carrinho ${widget.count}",
            style: TextStyle(color: Colors.white),
          ),
          Text(
            DateFormat('dd/MM/yyyy').format(widget.basket.basketTime!), /////////////// COLOCAR DATA
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
                    Text(
            "${widget.basket.productQuantities.length} Produtos",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(  //AnimatedContainer(  //duration: Duration(milliseconds: 300),
        width: widget.isExpanded 
          ? MediaQuery.of(context).size.width - 8
          : (widget.isShrunk ? HHVar.sugShrink : HHVar.sugWidth),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.purple,
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: widget.isExpanded
            ? Row(
                children: [
                  buildTextColumn(),
                  Expanded(
                    child: widget.isExpanded 
                      ? 
                      Row(
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
                                    child:HHIconButton(
                                      iconColor: widget.basket.cartLastPressed == 1 ? HHColors.hhColorDarkFirst : HHColors.hhColorGreyDark, 
                                      icon: Icons.shopping_cart_outlined, 
                                      onPressed: () {
                                        HHGlobals.HHBasket.value.addProductList(widget.basket.products, widget.sourceOrigin);  
                                        HHNotifiers.counter[CounterType.BasketCount]!.value = HHGlobals.HHBasket.value.groupProducts().length;
                                        setState(() {
                                          widget.basket.cartLastPressed = 1;
                                        });
                                        },
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: HHIconButton(
                                      iconColor: widget.basket.cartLastPressed == 0 ? HHColors.hhColorBack : HHColors.hhColorGreyDark,
                                      icon: Icons.remove_shopping_cart_outlined, 
                                      onPressed: () {
                                        HHGlobals.HHBasket.value.removeAllOfProductList(widget.basket.products);  
                                        HHNotifiers.counter[CounterType.BasketCount]!.value = HHGlobals.HHBasket.value.groupProducts().length; 
                                        setState(() {
                                          widget.basket.cartLastPressed = 0;
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
                                itemCount: widget.basket.productQuantities.length,
                                itemBuilder: (BuildContext context, int index) {
                                  MapEntry<EanModel, int> entry = widget.basket.productQuantities.entries.toList()[index];
                                  EanModel product = entry.key; // a chave do mapa é o produto
                                  int quantity = entry.value; // o valor do mapa é a quantidade
                                  print(product.toString());
                                  return BasketTile(product: product, count: quantity,); // por exemplo
                                },
                              ),
                              /*child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.basket.products.length,
                                itemBuilder: (BuildContext context, int index) {
                                  EanModel product = widget.basket.products[index];
                                  print("Reais ${product.preco}");
                                  return HistoryTile(product: product);
                                },
                              ),*/
                            ),
                          ),
                        ],
                      ) 
                      : Container(),
                  ),
                ],
              )
            : Container(
                width: widget.isShrunk ? HHVar.sugShrink : HHVar.sugWidth,
                child: 
                  widget.isShrunk ? 
                    Text(
                      "${widget.count}", 
                      style: const TextStyle(
                        color: Colors.white
                      )
                    )
                    : buildTextColumn(),
              ),
        ),
      ),
    );
  }
}


/*          Expanded(
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: HHIconButton(
                    icon: Icons.shopping_cart_outlined, 
                    onPressed: () {
                      HHGlobals.HHBasket.value.addProductList(widget.basket.products);  
                      HHNotifiers.counter['basketItemCount']!.value = HHGlobals.HHBasket.value.groupProducts().length;
                      //HHGlobals.HHBasket.value.groupProducts(); 
                      /*for (EanModel product in widget.basket.products){
                        HHGlobals.HHBasket.value.addProduct(product);
                        HHGlobals.HHBasket.notifyListeners(); 
                        }*/
                      },
                  ),
                ),
                Flexible(
                  child: HHIconButton(
                    icon: Icons.remove_shopping_cart_outlined, 
                    onPressed: () {
                      HHGlobals.HHBasket.value.removeAllOfProductList(widget.basket.products);  
                      HHNotifiers.counter['basketItemCount']!.value = HHGlobals.HHBasket.value.groupProducts().length; 
                      /*for (EanModel product in widget.basket.products){
                        HHGlobals.HHBasket.value.removeAllOfProduct(product);
                        HHGlobals.HHBasket.notifyListeners(); 
                        }*/
                      },
                  ),
                ),
              ],
            ),
          ),

          */