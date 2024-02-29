import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/config/common/var/hh_var.dart';
import 'package:hh_2/src/config/xml/xml_data.dart';
import 'package:hh_2/src/config/xml/xml_s3_data.dart';
//import 'package:hh_2/src/models/category_model.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:hh_2/src/models/user_model.dart';
import 'package:hh_2/src/pages/grid/components/image_tile.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';


// INICIO GRIDTAB
/*class GridTab extends StatefulWidget {
  final bool isVertical;
  final String category;
  final int vCross;
  final int hCross;
  final String uf;

  GridTab({
    Key? key,
    required this.isVertical,
    required this.category,
    required this.vCross,
    required this.hCross,
    required this.uf,
  }) : super(key: key);

  @override
  State<GridTab> createState() => _GridTabState();
}

class _GridTabState extends State<GridTab> {
  void resetScroll() {
    innerController.jumpTo(0);
  }

  final innerController = ScrollController();
  final double _offset = 2;

  //List<CategoryModel> categories = [];
  List<EanModel> products = [];

  final double _vRatio = HHVar.vRatio;
  final double _hRatio = HHVar.hRatio;

  final int index = 0;

  final double _padding = 0;
  final double _spacing = 0;
  EanModel selectedProduct = EanModel();
  UserModel user = HHGlobals.HHUser;

  // Adicione estas variáveis para controlar o número atual de colunas ou linhas
  int _currentVCross=0;
  int _currentHCross=0;

  @override
  void initState() {
    super.initState();
    _currentVCross = widget.vCross;
    _currentHCross = widget.hCross;
  }


  @override
  Widget build(BuildContext context) {
    // Envolver o Scrollbar em um MatrixGestureDetector para adicionar suporte a gestos de zoom in/zoom out
    return Scrollbar(
      controller: innerController,
      thumbVisibility: false,
      child: Listener(
        onPointerSignal: (event) {
          if (event is PointerScrollEvent) {
            final offset = event.scrollDelta.dy;
            innerController.jumpTo(innerController.offset + offset * _offset);
          }
        },
        child: FutureBuilder(
            future: XMLS3Data().getProductModelFromXML(context, widget.category, user.uf),
            builder: (context, data) {
              if (data.hasData) {
                products = data.requireData;
                return NotificationListener<ScrollNotification>(
                  onNotification: (t) {
                    if (t is ScrollUpdateNotification) {
                    } else if (t is ScrollEndNotification) {}
                    return true;
                  },
                    child: GridView.builder(
                      //scrollDirection: widget.vertical? Axis.vertical : Axis.horizontal,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.all(_padding),
                      controller: innerController,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //crossAxisCount: widget.vertical? _vCross: _hCross,
                        crossAxisCount: widget.isVertical ? widget.vCross : widget.hCross,
                        childAspectRatio: widget.isVertical? _vRatio: _hRatio,
                        mainAxisSpacing: _spacing,
                        crossAxisSpacing: _spacing,
                    ),
                    itemCount: products.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ImageTile(
                        onPressed: (){
                          setState(() {
                            selectedProduct = products[index];
                            HHGlobals.selectedProduct = products[index];
                            }
                          );
                        },
                        product: products[index],
                        selected: products[index].ean == HHGlobals.selectedProduct.ean,
                        );
                    },
                  ),
                );
              } else if (data.hasError) {
                return Center(child: Text('Error: ${data.error}'));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
// FIM GRIDTAB

*/

  /*gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: widget.vertical ? _currentVCross : _currentHCross,
      mainAxisSpacing: _spacing,
      crossAxisSpacing: _spacing,
    ),*/

  // Adicione este método para atualizar o número de colunas ou linhas
  /*void _updateCrossAxisCount(double scale) {
    setState(() {
      if (widget.isVertical) {
        _currentVCross = (widget.vCross * scale).round().clamp(1, 10);
      } else {
        _currentHCross = (widget.hCross * scale).round().clamp(1, 10);
      }
    });
  }*/



// ChatGPT 01
/*class GridTab extends StatefulWidget {
  final bool vertical;
  final String category;
  final int vCross;
  final int hCross;
  final String uf; // IA: Adicionado campo para armazenar a UF selecionada

  GridTab({
    Key? key,
    required this.vertical,
    required this.category,
    required this.vCross,
    required this.hCross,
    required this.uf, // IA: Adicionado parâmetro para receber a UF selecionada
  }) : super(key: key);

  @override
  State<GridTab> createState() => _GridTabState();
}



class _GridTabState extends State<GridTab> {

  void resetScroll() {
    innerController.jumpTo(0);
  }

final innerController = ScrollController();
final double _offset = 2; //2

List<CategoryModel> categories = [];
List<EanModel> products = [];


final double _vRatio = HHVar.vRatio;
final double _hRatio = HHVar.hRatio;

final int index=0;

final double _padding = 0;
final double _spacing = 0;
EanModel selectedProduct = EanModel();

  @override

  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => resetScroll());
    return Scrollbar(
      controller: innerController, // Adicione esta linha
      thumbVisibility: false, // Adicione esta linha
      child: Listener(
        onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          final offset = event.scrollDelta.dy;
          innerController.jumpTo(innerController.offset + offset *_offset);
          }
        },
        child: FutureBuilder(
            future: getProductModelFromXML(context, widget.category, widget.uf), //IA: Adicionado widget.uf
            //future: getProductModelFromXML(context, widget.category),
            //future: HHGlobals.changeCat ? Future.value(HHGlobals.listProduct) : getProductModelFromXML(context, widget.category), //ChatGPT
            //future: HHGlobals.changeCat? Future.value(HHGlobals.listProduct): getProductModelFromXML(context),  //anterior
            builder: (context, data) {
              if (data.hasData) {
                products = data.requireData;
                return NotificationListener<ScrollNotification>(
                  onNotification: (t) {
                    if (t is ScrollUpdateNotification) {
                    } else if (t is ScrollEndNotification) {}
                    return true;
                  },
                  child: GridView.builder(
                      controller: innerController,
                      scrollDirection: widget.vertical? Axis.vertical : Axis.horizontal,
                      padding:
                          EdgeInsets.symmetric(horizontal: _padding),
                      //physics: const BouncingScrollPhysics(),
                      physics: AlwaysScrollableScrollPhysics(),
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        //crossAxisCount: widget.vertical? _vCross: _hCross,
                        crossAxisCount: widget.vertical ? widget.vCross : widget.hCross,
                        childAspectRatio: widget.vertical? _vRatio: _hRatio,
                        mainAxisSpacing: _spacing,
                        crossAxisSpacing: _spacing,
                      ),
                      itemCount: products.length,
                      itemBuilder: (_, index) {
                        return ImageTile(
                          onPressed: (){
                            setState(() {
                              selectedProduct = products[index];
                              HHGlobals.product = products[index];
                              }
                            );
                          },
                          product: products[index],
                          selected: products[index].ean == HHGlobals.product.ean,
                          );
                      }),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
          ),
      ),
    );


  }
}*/

//ANterior
/*
class GridTab extends StatefulWidget {

  GridTab({
    Key? key,
    required this.vertical,
  }) : super(key: key);


  final bool vertical;

  @override
  State<GridTab> createState() => _GridTabState();
}*/