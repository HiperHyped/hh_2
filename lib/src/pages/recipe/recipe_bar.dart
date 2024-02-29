import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/models/recipe_model.dart';
import 'package:hh_2/src/models/suggestion_model.dart';
import 'package:hh_2/src/pages/recipe/recipe_card.dart';


class RecipeBar extends StatefulWidget {
  @override
  _RecipeBarState createState() => _RecipeBarState();
}

class _RecipeBarState extends State<RecipeBar> {
  final innerController = ScrollController();
  int expandedIndex = -1;
  double padd = 2.0;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<SuggestionModel>>(
      valueListenable: HHGlobals.HHSuggestionList,
      builder: (context, suggestionList, child) {
        return Container(
          padding: EdgeInsets.all(padd),
          color: HHColors.hhColorGreyLight,
          child: Scrollbar(
            controller: innerController,
            isAlwaysShown: false,
            child: ListView.builder(
              controller: innerController,
              scrollDirection: Axis.horizontal,
              itemCount: suggestionList.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: padd),
                  child: RecipeCard(
                    recipe: suggestionList[index].recipeModel, 
                    count: index+1,
                    isExpanded: expandedIndex == index,
                    isShrunk: expandedIndex != -1 && expandedIndex != index,
                    onTap: () {
                      setState(() {
                        if (expandedIndex == index) {
                          expandedIndex = -1;
                          innerController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                        } else {
                          expandedIndex = index;
                          innerController.animateTo(
                            0.0,
                            //2* padd + (innerController.position.maxScrollExtent * index) / suggestionList.length, 
                            duration: Duration(milliseconds: 300), 
                            curve: Curves.easeInOut
                          );
                        }
                      });
                    },
                  ),
                );
              },
            ),
          )
        );
      },
    );
  }
}

//v1
/*
class RecipeBar extends StatefulWidget {
  @override
  _RecipeBarState createState() => _RecipeBarState();
}

class _RecipeBarState extends State<RecipeBar> {
  bool expanded = false;
  double recipeBarHeight = 150;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          expanded = !expanded;
          recipeBarHeight = expanded ? MediaQuery.of(context).size.height / 2 : 150;
        });
      },
      child: ValueListenableBuilder<List<SuggestionModel>>(
        valueListenable: HHGlobals.HHSuggestionList,
        builder: (context, suggestionList, child) {
          RecipeModel recipeModel = suggestionList.last.recipeModel;
          return AnimatedContainer(
            duration: Duration(milliseconds: 500),
            height: recipeBarHeight,
            padding: const EdgeInsets.all(2.0),
            color: HHColors.hhColorGreyLight,
            child: Column(
              children: [
                Text(
                  recipeModel.recipeName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: recipeModel.description.map((description) => 
                        Text(
                          description,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        )
                      ).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
*/


//v0
/*
class RecipeBar extends StatefulWidget {
  @override
  _RecipeBarState createState() => _RecipeBarState();
}

class _RecipeBarState extends State<RecipeBar> {

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<SuggestionModel>>(
      valueListenable: HHGlobals.HHSuggestionList,
      builder: (context, suggestionList, child) {
        RecipeModel recipeModel = suggestionList.last.recipeModel;
        return Container(
          padding: const EdgeInsets.all(2.0),
          color: HHColors.hhColorGreyLight,
          child: Column(
            children: [
              Text(
                recipeModel.recipeName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 10),
              for (var description in recipeModel.description)
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
            ],
          )
        );
      },
    );
  }
}
*/