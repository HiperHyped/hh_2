import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/config/common/var/hh_var.dart';
import 'package:hh_2/src/models/periodic_model.dart';
import 'package:hh_2/src/pages/periodic/periodic_card.dart';

class PeriodicBar extends StatefulWidget {
  @override
  _PeriodicBarState createState() => _PeriodicBarState();
}

class _PeriodicBarState extends State<PeriodicBar> {
  final innerController = ScrollController();
  int expandedIndex = -1;
  double pad = 2.0; 

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<PeriodicModel>>(
      valueListenable: HHGlobals.HHPeriodicLists,
      builder: (context, periodicList, child) {
        return Container(
          padding: EdgeInsets.all(pad),
          color: HHColors.hhColorGreyLight,
          height: 10,
          child: Scrollbar(
            controller: innerController,
            thumbVisibility: false,
            child: ListView.builder(
              controller: innerController,
              scrollDirection: Axis.horizontal,
              itemCount: periodicList.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: pad),
                  child: PeriodicCard(
                    periodic: periodicList[index],
                    count: index + 1,
                    isExpanded: expandedIndex == index,
                    isShrunk: expandedIndex != -1 && expandedIndex != index,
                    onTap: () {
                      setState(() {
                        if (expandedIndex == index) {
                          expandedIndex = -1;
                        } else {
                          expandedIndex = index;
                        }
                        double position = expandedIndex * (HHVar.sugShrink + 2 * pad);
                        innerController.animateTo(position, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                      });
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
