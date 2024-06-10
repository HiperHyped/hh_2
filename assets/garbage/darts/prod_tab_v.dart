/*import 'dart:developer';
import 'package:flutter/cupertino.dart';
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

class ProdTabV extends StatefulWidget {
  const ProdTabV({super.key});

  @override
  State<ProdTabV> createState() => _ProdTabVState();
}

List<CategoryModel> categories = [];
List<EanModel> products = [];

int _crossAxisCount = 10;
double _padding = 0;
double _spacing = 0;
double _ratio = .4;
//double _catwidth = 1000;
EanModel selectedProduct = EanModel("", "", "", "", "", "", "", "", "", "", "", "", "", "", "");

class _ProdTabVState extends State<ProdTabV> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,

        // TOP BAR 
        appBar: const TopBar(),

        body: Row(
          children: [
            //CATEGORIES - CAT BAR
              const CatBar(),

            // PRODUCT MODELS
            Expanded(
              flex: 4,
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
                            //controller: _productController,
                            scrollDirection: Axis.vertical,
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
                              
                              /*return Container(
                                //color: HHColors.hhColorBack,
                                child: Image.asset("assets/images/db/B/BA/CG/${products[index].imagem}",),
                              );*/
                              /*return products[index].ean == selectedProduct?
                               ImageTile(product: products[index], isSelected: true):
                               ImageTile(product: products[index], isSelected: false);*/

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
                )
              )
          ],
        ),
      ),
    );
  }
}


*/