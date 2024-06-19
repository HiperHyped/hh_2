import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/models/picture_model.dart';
import 'picture_card.dart';

class PictureBar extends StatefulWidget {
  @override
  _PictureBarState createState() => _PictureBarState();
}

class _PictureBarState extends State<PictureBar> {
  final innerController = ScrollController();
  int expandedIndex = -1;
  double pad = 2.0;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<PictureModel>>(
      valueListenable: HHGlobals.HHPictureList,
      builder: (context, pictureList, child) {
        return Container(
          padding: EdgeInsets.all(pad),
          color: HHColors.hhColorGreyLight,
          child: Scrollbar(
            controller: innerController,
            thumbVisibility: false,
            child: ListView.builder(
              controller: innerController,
              scrollDirection: Axis.horizontal,
              itemCount: pictureList.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: pad),
                  child: PictureCard(
                    picture: pictureList[index],
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
                        // Rolando a ListView para o início sempre que um cartão é atualizado.
                        double position = expandedIndex * (90 + 2 * pad);
                        innerController.animateTo(
                          position,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
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
