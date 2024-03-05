import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/config/common/var/hh_var.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:hh_2/src/models/suggestion_model.dart';
import 'package:hh_2/src/pages/hint/hint_card.dart';
import 'package:hh_2/src/pages/suggestion/suggestion_card.dart';



class HintBar extends StatefulWidget {
  @override
  _HintBarState createState() => _HintBarState();
}

class _HintBarState extends State<HintBar> {
  final innerController = ScrollController();
  int expandedIndex = -1; // Todos os cartões começam em w2.
  double pad = 2.0; 

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<SuggestionModel>>(
      valueListenable: HHGlobals.HHSuggestionList,
      builder: (context, suggestionList, child) {
        return Container(
          padding: EdgeInsets.all(pad),
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
                  padding: EdgeInsets.symmetric(horizontal: pad),
                  child: HintCard(
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
                        double position = expandedIndex * (HHVar.sugShrink + 2 * pad);
                        innerController.animateTo(position, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
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