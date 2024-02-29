import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/config/common/var/hh_settings.dart';
import 'package:hh_2/src/config/common/var/hh_var.dart';
import 'package:hh_2/src/pages/cat/cat_3_bar.dart';
import 'package:hh_2/src/pages/grid/prod_grid.dart';
import 'package:hh_2/src/pages/prodpage/components/top_bar.dart';


class ProdPage extends StatefulWidget {
  ProdPage({
    Key? key
  }) : super(key: key);


  @override
  State<ProdPage> createState() => _ProdPageState();
}

class _ProdPageState extends State<ProdPage> {
  String _selectedCategory = HHGlobals.selectedCat; //CATEGORIA INICIAL
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Adicionar GlobalKey CHatGPT

  // Controle de visibilidade da Cat3Bar
  bool isHidden = false;

  void _updateCategory(String newCategory) {
    setState(() {
      _selectedCategory = newCategory;
    });
  }

  Widget _buildBody(bool isDesktop, bool isLandscape) {
    int catBarFlex = 1;     

    int gridTabFlex = isLandscape ? 
    (HHSettings.gridView ? HHVar.cgLVratio : HHVar.cgLHratio): 
    (HHSettings.gridView ? HHVar.cgPVratio : HHVar.cgPHratio);

    int vCross = isLandscape ? HHVar.grLVline : HHVar.grPVline; 
    int hCross = isLandscape ? HHVar.grLHline : HHVar.grPHline;

    return Stack(
      children: [
        HHSettings.gridView
            ? Row( // Row (VERTICAL)
                children: [
                  if (!isHidden) 
                    Flexible( 
                      flex: catBarFlex,
                      child: Cat3Bar(
                        onCategorySelected: _updateCategory,
                        isVertical: HHSettings.gridView,
                      ),
                    ),
                  Container(
                    width: 2,
                    color: HHColors.hhColorGreyMedium,
                  ),
                  GestureDetector(
                                       onTap: (){
                      if(!isHidden) {
                        setState(() {
                          isHidden = true;
                        });
                      } else {
                        setState(() {
                          isHidden = false;
                        });
                      }

                    },
                    onHorizontalDragUpdate: (details) {
                      if (details.delta.dx > 0) {
                        setState(() {
                          isHidden = false;
                        });
                      } else if (details.delta.dx < 0) {
                        setState(() {
                          isHidden = true;
                        });
                      }
                    },
                    child: Container(
                      width: 10,
                      color: HHColors.hhColorGreyDark,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 230.0),
                          child: Container(
                            width: 2, // Or whatever width you want for the line
                            height: double.infinity, // Or whatever height you want for the line
                            color: Colors.white, // Color of the line
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: gridTabFlex,
                    child: ProdGrid(),
                    /*
                    child: GridTab(
                      isVertical: widget.isVertical,
                      category: _selectedCategory,
                      vCross: vCross,
                      hCross: hCross,
                      uf: HHGlobals.HHUser.uf,
                    ),
                    */
                  ),
                ],
              )
            : Column(
                children: [
                  if (!isHidden) 
                    Flexible(
                      flex: catBarFlex,
                      child: Cat3Bar(
                        onCategorySelected: _updateCategory,
                        isVertical: HHSettings.gridView,
                      ),
                    ),
                  /*Container(
                    height: 2,
                    color: HHColors.hhColorGreyMedium,
                  ),*/
                  GestureDetector(
                    onTap: (){
                      if(!isHidden) {
                        setState(() {
                          isHidden = true;
                        });
                      } else {
                        setState(() {
                          isHidden = false;
                        });
                      }

                    },
                    onVerticalDragUpdate: (details) {
                      if (details.delta.dy < 0) {
                        setState(() {
                          isHidden = true;
                        });
                      } else if (details.delta.dy > 0) {
                        setState(() {
                          isHidden = false;
                        });
                      }
                    },
                    child: Container(
                      height: 7,
                      color: HHColors.hhColorGreyDark,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 180.0),
                          child: Container(
                            //width: double.infinity, // Or whatever width you want for the line
                            height: 2, // Or whatever height you want for the line
                            color: Colors.white, // Color of the line
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: gridTabFlex,
                    child: ProdGrid(),
                  ),
                ],
              ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: const TopBar(),
        body: OrientationBuilder(
          builder: (context, orientation) {
            return LayoutBuilder(
              builder: (context, constraints) {
                // Verifica se o dispositivo é desktop ou mobile.
                bool isDesktop = constraints.maxWidth >= 600;
                // Verifica se a orientação é paisagem.
                bool isLandscape = orientation == Orientation.landscape;
                //print("DESKTOP? $isDesktop. LANDSCAPE? $isLandscape. VERTICAL? ${widget.isVertical}.");
                return _buildBody(isDesktop, isLandscape);
              },
            );
          },
        ),
      ),
    );
  }
}


