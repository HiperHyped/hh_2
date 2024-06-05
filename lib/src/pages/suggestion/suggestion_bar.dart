import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
//import 'package:hh_2/src/models/ean_model.dart';
import 'package:hh_2/src/models/suggestion_model.dart';
import 'package:hh_2/src/pages/suggestion/suggestion_card.dart';

//import 'suggestion_tile.dart';


class SuggestionBar extends StatefulWidget {
  @override
  _SuggestionBarState createState() => _SuggestionBarState();
}

class _SuggestionBarState extends State<SuggestionBar> {
  final innerController = ScrollController();
  int expandedIndex = -1; // Todos os cartões começam em w2.

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<SuggestionModel>>(
      valueListenable: HHGlobals.HHSuggestionList,
      builder: (context, suggestionList, child) {
        return Container(
          padding: const EdgeInsets.all(2.0),
          color: HHColors.hhColorGreyLight,
          child: Scrollbar(
            controller: innerController,
            thumbVisibility: false,
            child: ListView.builder(
              controller: innerController,
              scrollDirection: Axis.horizontal,
              itemCount: suggestionList.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.0),
                  child: SuggestionCard(
                    suggestion: suggestionList[index], 
                    count: index+1,
                    isExpanded: expandedIndex == index,
                    isShrunk: expandedIndex != -1 && expandedIndex != index,
                    onTap: () {
                      setState(() {
                        if (expandedIndex == index) {
                          expandedIndex = -1; // Volta todas as cartas a w2.
                        } else {
                          expandedIndex = index; // Expande a carta clicada.
                        }
                        // Rolando a ListView para o início sempre que um cartão é atualizado.
                        innerController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
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




/*
class SuggestionBar extends StatefulWidget {
  @override
  _SuggestionBarState createState() => _SuggestionBarState();
}

class _SuggestionBarState extends State<SuggestionBar> {
  final innerController = ScrollController();
  int expandedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<SuggestionModel>>(
      valueListenable: HHGlobals.HHSuggestionList,
      builder: (context, suggestionList, child) {
        return Container(
          padding: const EdgeInsets.all(2.0),
          color: HHColors.hhColorGreyLight,
          child: Scrollbar(
            controller: innerController,
            thumbVisibility: false,
            child: ListView.builder(
              controller: innerController,
              scrollDirection: Axis.horizontal,
              itemCount: suggestionList.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.0),
                  child: SuggestionCard(
                    suggestion: suggestionList[index], 
                    count: index+1,
                    isExpanded: expandedIndex == index,
                    onTap: () {
                      setState(() {
                        expandedIndex = index;
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
}*/


/*class _SuggestionBarState extends State<SuggestionBar> {
  final innerController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<SuggestionModel>>(
      valueListenable: HHGlobals.HHSuggestionList,
      builder: (context, suggestionList, child) {
        return Container(
          padding: const EdgeInsets.all(2.0),
          color: HHColors.hhColorGreyLight,
          child: Scrollbar(
            controller: innerController,
            thumbVisibility: false,
            child: ListView.builder(
              controller: innerController,
              scrollDirection: Axis.horizontal,
              itemCount: suggestionList.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.0), // Adicione padding conforme necessário
                  child: SuggestionCard(suggestion: suggestionList[index], count: index+1),
                );
              },
            ),
          )
        );
      },
    );
  }
}*/


/*class SuggestionBar extends StatefulWidget {
  @override
  _SuggestionBarState createState() => _SuggestionBarState();
}

class _SuggestionBarState extends State<SuggestionBar> {
  final innerController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<SuggestionModel>>(
      valueListenable: HHGlobals.HHSuggestionList,
      builder: (context, suggestionList, child) {
        return Container(
          padding: const EdgeInsets.all(2.0),
          color: HHColors.hhColorGreyLight,
          child: Scrollbar(
            controller: innerController,
            thumbVisibility: false,
            child: ListView.builder(
              controller: innerController,
              scrollDirection: Axis.horizontal,
              itemCount: suggestionList.last.dbSearchResultList.length,
              itemBuilder: (BuildContext context, int index) {
                EanModel product = suggestionList.last.dbSearchResultList[index];
                return SuggestionTile(product: product);
              },
            ),
          )
        );
      },
    );
  }
}*/
