/*import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hh_2/src/config/common/hh_colors.dart';
import 'package:hh_2/src/models/category_model.dart';
import 'package:hh_2/src/config/xml_data.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:hh_2/src/pages/base/bottom_bar.dart';
import 'package:hh_2/src/pages/cat/cat_bar.dart';
import 'package:hh_2/src/pages/products/components/image_tile.dart';
import 'package:hh_2/src/pages/products/components/top_bar.dart';
import 'package:hh_2/src/config/common/hh_globals.dart';

class CatTabH extends StatefulWidget {
  const CatTabH({super.key});

  @override
  State<CatTabH> createState() => _CatTabHState();
}


final innerController = ScrollController();
double _offset = 2;

List<CategoryModel> categories = [];
List<EanModel> products = [];

int _crossAxisCount = 3;
double _padding = 0;
double _spacing = 0;
double _ratio = 2;
double _catwidth = 200;
double _heightImage = 100;

EanModel selectedProduct = EanModel("", "", "", "", "", "", "", "", "", "", "", "", "", "", "");

class _CatTabHState extends State<CatTabH> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,

        // TOP BAR
        appBar: const TopBar(),
        
        body: Row(
          children: [
            //CATEGORIES
              const CatBar(),
            

            // PRODUCT MODELS
            Expanded(
              flex: 4,
              child: Listener(
                onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  final offset = event.scrollDelta.dy;
                  innerController.jumpTo(innerController.offset + offset*_offset);
                  //outerController.jumpTo(outerController.offset - offset);
                  }
                },
                child: FutureBuilder(
                    future: getProductModelFromXML(context), //, categories[0]
                    builder: (context, data) {
                      //print(data);
                      if (data.hasData) {
                        products = data.requireData;
              
                        //print(products);
                        return NotificationListener<ScrollNotification>(
                          onNotification: (t) {
                            if (t is ScrollUpdateNotification) {
                              //jumpToCategory(t.metrics.pixels);
                              //selectedCategory = scrollToCategory;
                              //print(scrollToCategory);
                            } else if (t is ScrollEndNotification) {}
                            return true;
                          },
                          child: GridView.builder(
                              //shrinkWrap: false,
                              controller: innerController,
                              scrollDirection: Axis.horizontal,
                              padding:
                                  EdgeInsets.symmetric(horizontal: _padding),
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: _crossAxisCount,
                                mainAxisSpacing: _spacing,
                                crossAxisSpacing: _spacing,
                                childAspectRatio: _ratio,
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
              
                                //Text(products[index].ean);
              
                                //Image.asset("assets/images/cat/CAT_BBACG.png");
                                //ImageTile(product: products[index], selected: true):
                                //ImageTile(product: products[index], selected: false);
                                //return const Center(child: CircularProgressIndicator(),);} //sem estoque
                              }),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }
                  ),
              )
              )
          ],
        ),
      ),
    );
  }
}


*/