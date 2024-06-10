/*import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/config/xml/xml_data.dart';
import 'package:hh_2/src/config/xml/xml_s3_data.dart';
import 'category_model.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'cat_tile.dart';*/

//DEPRECATED
//ChatGPT
/*class CatBar extends StatefulWidget {
  final Function(String) onCategorySelected;
  final bool vertical;

  const CatBar({Key? key, required this.onCategorySelected, required this.vertical,}) : super(key: key);

  @override
  State<CatBar> createState() => _CatBarState();
}



//Anterior
/*class CatBar extends StatefulWidget {
  
  const CatBar({Key? key}) : super(key: key);  

  @override
  State<CatBar> createState() => _CatBarState();
}*/

List<CategoryModel> categories = [];
String selectedCat = "";

class _CatBarState extends State<CatBar> {
  
  final innerController = ScrollController(); // Adicione esta linha

  @override
  Widget build(BuildContext context) {
    
    return Container(
      padding: const EdgeInsets.only(top: 2, bottom: 0, left: 0, right: 0),
      color: HHColors.hhColorGreyLight,
      //////width: widget.vertical ? null : MediaQuery.of(context).size.width * 0.75, // Alterado
      child: FutureBuilder(
        //future: XMLData.getCategoryFromXML(context),
        future: XMLS3Data().getCategoryFromXML(context),
        builder: (context, data) {
          if (data.hasData) {
            categories = data.requireData;
            return Scrollbar(
              controller: innerController, // Adicione esta linha
              thumbVisibility: false, // Adicione esta linha
              child: Listener(
                onPointerSignal: (event) {
                  if (event is PointerScrollEvent) {
                    final offset = event.scrollDelta.dy;
                    innerController.jumpTo(innerController.offset + offset);
                  }
                },
                child: SizedBox(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (t) {
                      if (t is ScrollUpdateNotification) {
                        //print(t.dragDetails);
                      }
                      return true;
                    },
                    child: ListView.builder(
                      controller: innerController, // Adicione esta linha
                      physics: const BouncingScrollPhysics(),
                      //scrollDirection: Axis.vertical, //Anterior
                      scrollDirection: widget.vertical ? Axis.vertical : Axis.horizontal, //ChatGPT
                      itemCount: categories.length,
                      itemBuilder: (context, index) => Stack(children: [
                        CatTile(
                          onPressed: (){
                            setState(() {
                              selectedCat = categories[index].sigla;
                              print("SELECTED: $selectedCat");
                              HHGlobals.category = categories[index];
                              //HHGlobals.changeCat = true;
                              //HHGlobals.listProduct = getProductModelFromXML(context, selectedCat) as List<EanModel> ;
                              widget.onCategorySelected(selectedCat); ///ChatGPT
                              //widget.parentAction("Update from Child 1");  ///////////////////////////////////////// Child to Parent
                              }
                            );
                          },
                          category: categories[index],
                          isSelected: categories[index].sigla == HHGlobals.category.sigla,
                          vertical: widget.vertical,
                        ),
                      ]
                        ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
*/