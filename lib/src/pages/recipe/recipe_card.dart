import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/components/hh_icon_button.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/config/common/var/hh_var.dart';
import 'package:hh_2/src/models/recipe_model.dart';

class RecipeCard extends StatefulWidget {
  final RecipeModel recipe;
  final int count;
  final bool isExpanded;
  final bool isShrunk;
  final VoidCallback onTap;

  RecipeCard({required this.recipe, required this.count, required this.onTap, this.isShrunk = false, this.isExpanded = false});

  @override
  _RecipeCardState createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
   
  Widget buildTextColumn() {
    return Container(
      width: HHVar.sugWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Receita ${widget.count}",
            style: TextStyle(color: Colors.white),
          ),
          Text(
            "${widget.recipe.recipeName}",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Row(
              children: [
                Flexible(child: HHIconButton(icon: Icons.thumb_up_alt_outlined, onPressed: (){})),
                Flexible(child: HHIconButton(icon: Icons.thumb_down_alt_outlined, onPressed: (){}))
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
        //width: widget.isExpanded ? MediaQuery.of(context).size.width : (widget.isShrunk ? HHVar.sugShrink : HHVar.sugWidth),
        width: widget.isExpanded ? MediaQuery.of(context).size.width - 20 : (widget.isShrunk ? HHVar.sugShrink : HHVar.sugWidth),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.amber,
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: widget.isExpanded
            ? Row(
              //mainAxisAlignment: MainAxisAlignment.,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildTextColumn(),
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
                        child: SingleChildScrollView( // adicionado para permitir a rolagem
                          child: Column(
                            children: List.generate(
                              widget.recipe.description.length,
                              (index) {
                                String step = widget.recipe.description[index];
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    padding: EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      step,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )

                      ) 
                      : Container(),
                  ),
                ],
              )
            : widget.isShrunk ? 
              Text(
                "${widget.count}", 
                style: const TextStyle(
                  color: Colors.white
                  )
                ) 
              :  buildTextColumn(),
        ),
      ),
    );
  }
}
