
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
import 'package:hh_2/src/pages/products/components/image_tile.dart';

class CatTab2 extends StatefulWidget {
  const CatTab2({super.key});

  @override
  State<CatTab2> createState() => _CatTab2State();
}

List<CategoryModel> categories = [];
List<EanModel> products = [];

int _crossAxisCount = 10;
double _padding = 0;
double _spacing = 0;
double _ratio = .5;
double _catwidth = 200;

class _CatTab2State extends State<CatTab2> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: HHColors.hhColorGreyLight,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(6, 12, 6, 12),
            child: Image.asset(
              "assets/images/HH_logo_trans.png",
            ),
          ),
        ),
        body: Row(
          children: [
            Expanded(
              child: FutureBuilder(
                future: getCategoryFromXML(context),
                builder: (context, data) {
                  if (data.hasData) {
                    categories = data.requireData;
                    String path =
                        "assets/xml/db/${categories[0].sig0}/${categories[0].sig1}/${categories[0].sig2}/${categories[0].sigla}_PRODS.xml";
                    //print(path);
                    //log(categories2.toString());
                    return SizedBox(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (t) {
                          if (t is ScrollUpdateNotification) {
                            //print(t.dragDetails);
                          }
                          return true;
                        },
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: categories.length,
                          itemBuilder: (context, index) => Stack(children: [
                            //Text(categories2[index].sigla),
                            ListTile(
                              leading: Container(
                                color: HHColors.hhColorFirst,
                                child: Image.asset(
                                  "assets/images/cat/CAT_${categories[index].sigla}.png",
                                  width: _catwidth,
                                ),
                              ),
                              //title: Text(categories[index].cat1),
                              //subtitle: Text(categories[index].cat2),
                              //trailing: Text(categories2[index].sigla),
                              //trailing: Image.asset("assets/images/cat/CAT_${categories2[index].sigla}.png"),
                              //isThreeLine: true,
                            ),
                            /*ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          itemCount: categories2.length,
                                          itemBuilder:(context, index) => Text(categories2[index].sig2)
                                        )*/
                          ]
                              //Text(categories2[index].sigla),
                              ),
                        ),
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),

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
                              //PUT NCM POS IN CATEGORIES
                              return Container(
                                color: HHColors.hhColorBack,
                                child: Image.asset(
                                  "assets/images/db/B/BA/CG/${products[index].imagem}",
                                  height: 200,
                                  ),
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
                )
              )
          ],
        ),
      ),
    );
  }
}

*/
