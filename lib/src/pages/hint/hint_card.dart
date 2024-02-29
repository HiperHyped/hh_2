import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/components/hh_icon_button.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/config/common/var/hh_notifiers.dart';
import 'package:hh_2/src/config/common/var/hh_var.dart';
import 'package:hh_2/src/config/db/db_hint.dart';
import 'package:hh_2/src/models/basket_model.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:hh_2/src/models/suggestion_model.dart';
import 'package:hh_2/src/pages/hint/components/recipe_dialog.dart';
import 'package:hh_2/src/pages/suggestion/suggestion_tile.dart';


//v1
class HintCard extends StatefulWidget {
  final SuggestionModel suggestion;
  final int count;
  final bool isExpanded;
  final bool isShrunk;
  final VoidCallback onTap;
  final SourceOrigin sourceOrigin = SourceOrigin.R;

  HintCard({required this.suggestion, required this.count, required this.onTap, this.isShrunk = false, this.isExpanded = false});

  @override
  _HintCardState createState() => _HintCardState();
}

class _HintCardState extends State<HintCard> {
  //int? userFeedback;
  //int? cartLastPressed;
  final DBHint _dbHint = DBHint();

  void _showRecipeDialog() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return RecipeDialog(
          suggestion: widget.suggestion,
          onThumbUp: () {
            _dbHint.updateUserFeedback(widget.suggestion, 1);
            setState(() {
              widget.suggestion.userFeedback = 1;
            });
          },
          onThumbDown: () {
            _dbHint.updateUserFeedback(widget.suggestion, 0);
            setState(() {
              widget.suggestion.userFeedback = 0;
            });
          },
          onShare: () {
            // Insira o código para compartilhar a receita aqui.
          },
          userFeedback: widget.suggestion.userFeedback,
          updateUserFeedback: (int? feedback) {
            setState(() {
              widget.suggestion.userFeedback = feedback;
            });
          },
        );
      },
    );
  }


   
   
  Widget _buildTextColumn() {
    return Column(
      children: [
        Flexible(
          flex: 1,
          child: SizedBox(
            //color: Colors.amber,
            width: HHVar.sugWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisSize: MainAxisSize.min, // Adicione esta linha
              children: [
                Text(
                  "Sugestão ${widget.count}",
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  widget.suggestion.recipe,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),

                Text(
                  "\n\n\n${widget.suggestion.recipeModel.catRecipe} > ",
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  widget.suggestion.recipeModel.subCatRecipe,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(  //AnimatedContainer  //duration: Duration(milliseconds: 300),
        width: widget.isExpanded 
          ? MediaQuery.of(context).size.width - 8
          : (widget.isShrunk ? HHVar.sugShrink : HHVar.sugWidth),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: HHColors.hhColorDarkFirst,
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: widget.isExpanded
            // w3 - expanded
            ? Row(
                children: [
                  _buildTextColumn(),
                  Expanded(
                    child: widget.isExpanded 
                      ? Column(
                        children: [
                          /////////RECIPES
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 2),
                                    width: 25,
                                    color: HHColors.hhColorGreyLight,
                                    child: Column(
                                      children: [
                                        //Flexible(child: HHIconButton(icon: Icons.thumb_up_alt_outlined, onPressed: (){})),
                                        //Flexible(child: HHIconButton(icon: Icons.thumb_down_alt_outlined, onPressed: (){}))
                                        Flexible(
                                          child: HHIconButton(
                                            icon: Icons.thumb_up_alt_outlined,
                                            iconColor: widget.suggestion.userFeedback == 1 ? HHColors.hhColorDarkFirst : HHColors.hhColorGreyDark,
                                            onPressed: () {
                                              _dbHint.updateUserFeedback(widget.suggestion, 1);
                                              setState(() {
                                                widget.suggestion.userFeedback = 1;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: HHIconButton(
                                            icon: Icons.thumb_down_alt_outlined,
                                            iconColor: widget.suggestion.userFeedback == 0 ? HHColors.hhColorBack : HHColors.hhColorGreyDark,
                                            onPressed: () {
                                              _dbHint.updateUserFeedback(widget.suggestion, 0);
                                              setState(() {
                                                widget.suggestion.userFeedback = 0;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: HHIconButton(
                                            icon: Icons.visibility_outlined,
                                            iconColor: HHColors.hhColorGreyDark,
                                            onPressed: _showRecipeDialog,
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
                                      child: SingleChildScrollView( // adicionado para permitir a rolagem
                                        child: Column(
                                          children: List.generate(
                                            widget.suggestion.recipeModel.description.length,
                                            (index) {
                                              String step = widget.suggestion.recipeModel.description[index];
                                              return Padding(
                                                padding: const EdgeInsets.all(4.0),
                                                child: Container(
                                                  width: double.infinity,
                                                  padding: const EdgeInsets.all(4.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  child: Text(
                                                    step,
                                                    style: const TextStyle(fontSize: 18),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          ///////SUGESTIONS
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 2),
                                    width: 25,
                                    color: HHColors.hhColorGreyLight,
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            flex: 1,
                                            child: HHIconButton(
                                              iconSize: 22,
                                              iconColor: widget.suggestion.cartLastPressed == 1 ? HHColors.hhColorDarkFirst : HHColors.hhColorGreyDark,
                                              icon: Icons.shopping_cart_outlined, 
                                              onPressed: () {
                                                HHGlobals.HHBasket.value.addProductList(widget.suggestion.dbSearchResultList, widget.sourceOrigin);  
                                                //HHGlobals.HHBasket.value.groupProducts();                               
                                                HHNotifiers.counter[CounterType.BasketCount]!.value = HHGlobals.HHBasket.value.groupProducts().length;
                                                setState(() {
                                                  widget.suggestion.cartLastPressed = 1;
                                                });
                                                },
                                            ),
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: HHIconButton(
                                              iconSize: 22,
                                              iconColor: widget.suggestion.cartLastPressed == 0 ? HHColors.hhColorBack : HHColors.hhColorGreyDark,
                                              icon: Icons.remove_shopping_cart_outlined, 
                                              onPressed: () {
                                                HHGlobals.HHBasket.value.removeAllOfProductList(widget.suggestion.dbSearchResultList);  
                                                HHNotifiers.counter[CounterType.BasketCount]!.value = HHGlobals.HHBasket.value.groupProducts().length;                         
                                                //HHGlobals.HHBasket.value.groupProducts();  
                                                //HHGlobals.HHBasket.notifyListeners();
                                                setState(() {
                                                  widget.suggestion.cartLastPressed = 0;
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
                                          itemCount: widget.suggestion.dbSearchResultList.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            EanModel product = widget.suggestion.dbSearchResultList[index];
                                            //print("Reais ${product.preco}");
                                            return SuggestionTile(product: product);
                                          },
                                        ),
                                      ),
                                  ),
                                ],
                              ),
                            ),
                          ), 
                        ],
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



        /*Flexible(
          flex: 1, 
          child: Container(
            width: HHVar.sugWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  "Ingredientes",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                
              ],
            ),
          ),
        ),*/