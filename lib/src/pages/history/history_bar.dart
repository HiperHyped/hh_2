import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/config/common/var/hh_var.dart';
import 'package:hh_2/src/models/history_model.dart';
import 'package:hh_2/src/pages/history/history_card.dart';

class HistoryBar extends StatefulWidget {
  @override
  _HistoryBarState createState() => _HistoryBarState();
}

class _HistoryBarState extends State<HistoryBar> {
  final innerController = ScrollController();
  int expandedIndex = -1;
  double pad = 2.0; 

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<HistoryModel>(
      valueListenable: HHGlobals.HHUserHistory,
      builder: (context, historyList, child) {
        return Container(
          padding: EdgeInsets.all(pad),
          color: HHColors.hhColorGreyLight,
          child: Scrollbar(
            controller: innerController,
            isAlwaysShown: false,
            child: ListView.builder(
              controller: innerController,
              scrollDirection: Axis.horizontal,
              itemCount: historyList.basketHistory.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: pad),
                  child: HistoryCard(
                    basket: historyList.basketHistory[index],
                    count: index+1,
                    isExpanded: expandedIndex == index,
                    isShrunk: expandedIndex != -1 && expandedIndex != index,
                    onTap: () {
                      setState(() {
                        if (expandedIndex == index) {
                          expandedIndex = -1;
                        } else {
                          expandedIndex = index;
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
