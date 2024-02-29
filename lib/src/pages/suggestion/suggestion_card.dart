import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/components/hh_icon_button.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/config/common/var/hh_var.dart';
import 'package:hh_2/src/models/basket_model.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:hh_2/src/models/suggestion_model.dart';
import 'package:hh_2/src/pages/suggestion/suggestion_tile.dart';


//v1
class SuggestionCard extends StatefulWidget {
  final SuggestionModel suggestion;
  final int count;
  final bool isExpanded;
  final bool isShrunk;
  final VoidCallback onTap;
  final SourceOrigin sourceOrigin = SourceOrigin.R;

  SuggestionCard({required this.suggestion, required this.count, required this.onTap, this.isShrunk = false, this.isExpanded = false});

  @override
  _SuggestionCardState createState() => _SuggestionCardState();
}

class _SuggestionCardState extends State<SuggestionCard> {
   
   
  Widget _buildTextColumn() {
    return Container(
      //color: Colors.amber,
      width: HHVar.sugWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisSize: MainAxisSize.min, // Adicione esta linha
        children: [
          Text(
            "Sugestão ${widget.count}",
            style: TextStyle(color: Colors.white),
          ),
          Text(
            "${widget.suggestion.recipe}",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: HHIconButton(
                    icon: Icons.shopping_cart_outlined, 
                    onPressed: () {
                      HHGlobals.HHBasket.value.addProductList(widget.suggestion.dbSearchResultList, widget.sourceOrigin);  
                      //HHGlobals.HHBasket.value.groupProducts();                               
                      HHGlobals.HHBasket.notifyListeners();
                      },
                  ),
                ),
                Flexible(
                  child: HHIconButton(
                    icon: Icons.remove_shopping_cart_outlined, 
                    onPressed: () {
                      HHGlobals.HHBasket.value.removeAllOfProductList(widget.suggestion.dbSearchResultList);                           
                      //HHGlobals.HHBasket.value.groupProducts();  
                      HHGlobals.HHBasket.notifyListeners();
                      },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: widget.isExpanded 
        ? MediaQuery.of(context).size.width - HHVar.sugShrink 
        : (widget.isShrunk ? HHVar.sugShrink : HHVar.sugWidth),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue,
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: widget.isExpanded
            // w3 - expanded
            ? Row(
                children: [
                  _buildTextColumn(),
                  Expanded(
                    child: widget.isExpanded 
                      ? Container(
                        decoration: BoxDecoration(
                          color: HHColors.hhColorGreyLight,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.suggestion.dbSearchResultList.length,
                          itemBuilder: (BuildContext context, int index) {
                            EanModel product = widget.suggestion.dbSearchResultList[index];
                            print("Reais ${product.preco}");
                            return SuggestionTile(product: product);
                          },
                        ),
                      ) 
                      // w2 - expandido só texto
                      : Container(),
                  ),
                ],
              )
            : Container(
                width: widget.isShrunk ? HHVar.sugShrink : HHVar.sugWidth,
                child: 
                  widget.isShrunk ? 
                    // w1 - expandido só texto
                    Text(
                      "${widget.count}", 
                      style: const TextStyle(
                        color: Colors.white
                        )
                      ) 
                    // w2 - só texto
                    :  _buildTextColumn(),
              ),
        ),
      ),
    );
  }
}


//v0
/*
class _SuggestionCardState extends State<SuggestionCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: widget.isExpanded ? MediaQuery.of(context).size.width : widget.isExpanded ? 120 : 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: HHColors.hhColorFirst,
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: widget.isExpanded
            ? Row(
                children: [
                  Container(
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sugestão ${widget.count}",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "${widget.suggestion.recipe}",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                        itemCount: widget.suggestion.dbSearchResultList.length,
                        itemBuilder: (BuildContext context, int index) {
                          EanModel product = widget.suggestion.dbSearchResultList[index];
                          return SuggestionTile(product: product);
                        },
                      ),
                    )
                  ),
                ],
              )
            : Container(
                width: 20,
                child: Center(
                  child: Text(
                    "${widget.count}",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
        ),
      ),
    );
  }
}
*/

/*
class SuggestionCard extends StatefulWidget {
  final SuggestionModel suggestion;
  final int count;

  SuggestionCard({required this.suggestion, required this.count});

  @override
  _SuggestionCardState createState() => _SuggestionCardState();
}

class _SuggestionCardState extends State<SuggestionCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: isExpanded ? MediaQuery.of(context).size.width : 115,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: HHColors.hhColorDarkFirst, // Substitua com a cor apropriada.
        ),
        child: Padding(
          padding: EdgeInsets.all(6.0),
          child: Row(
                children: [
                  Container(
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sugestão ${widget.count}",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "${widget.suggestion.recipe}",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  isExpanded? Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: HHColors.hhColorGreyLight, // Substitua com a cor apropriada
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.suggestion.dbSearchResultList.length,
                        itemBuilder: (BuildContext context, int index) {
                          EanModel product = widget.suggestion.dbSearchResultList[index];
                          return SuggestionTile(product: product);
                        },
                      ),
                    )
                  ): Container(),
                ],
              )
        ),
      ),
    );
  }
}
*/