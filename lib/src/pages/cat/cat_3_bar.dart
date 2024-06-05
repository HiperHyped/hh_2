//import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
//import 'package:hh_2/src/config/common/var/hh_address.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/config/db/db_grid.dart';
//import 'package:hh_2/src/config/xml/xml_s3_data.dart';
//import 'package:hh_2/src/models/cat_model.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:hh_2/src/models/search_model.dart';
import 'package:hh_2/src/pages/cat/components/cat_3_tile.dart';

/*A classe Cat3Bar é um StatefulWidget que representa a barra de categorias em seu aplicativo. 
Esta barra de categorias exibe uma lista de categorias que são carregadas de um recurso XML 
através de XMLS3Data().getCatModelAssetXML(asset). A barra de categorias pode ser exibida 
verticalmente ou horizontalmente, dependendo do valor da propriedade isVertical. 
Cada categoria é representada por um Cat3Tile, e quando um Cat3Tile é pressionado, 
a categoria selecionada é atualizada e a função callback onCategorySelected 
é chamada com a nova categoria selecionada. Se os dados ainda não foram carregados,
um CircularProgressIndicator é exibido para indicar que o carregamento está em andamento.*/

//05/07/2023
class Cat3Bar extends StatefulWidget {
  final Function(String) onCategorySelected;
  final bool isVertical;

  const Cat3Bar({Key? key, required this.onCategorySelected, required this.isVertical}) : super(key: key);

  @override
  State<Cat3Bar> createState() => _Cat3BarState();
}

List<EanModel> gridList = [];
String selectedCat = "";
final DBGrid _dbGrid = DBGrid();

class _Cat3BarState extends State<Cat3Bar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 2, bottom: 0, left: 0, right: 0),
      color: HHColors.hhColorGreyLight,
      child: ListView.builder(
        scrollDirection: widget.isVertical ? Axis.vertical : Axis.horizontal,
        itemCount: HHGlobals.listCat.length,
        itemBuilder: (context, index) => 
          Cat3Tile(
            onPressed: () async {
                SearchModel cat = SearchModel(
                    sigla: HHGlobals.selectedCat,
                    searchType: "category",
                );
                //var newGridList = await _dbGrid.getProductsForGrid(cat);
                var newGridList = await _dbGrid.getProductsForGridV3(cat);
                var newSelectedCat = HHGlobals.selectedCat;
                setState(() {
                    gridList = newGridList;
                    HHGlobals.HHGridList.value = gridList;

                    selectedCat = newSelectedCat;
                    widget.onCategorySelected(selectedCat);
                    print("Cat3Bar: " + selectedCat);
                });
            },
            cat: HHGlobals.listCat[index],
            selectedCat: selectedCat,
            isVertical: widget.isVertical,
          ),
          
      ),
    );
  }
}


