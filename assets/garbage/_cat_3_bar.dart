
// v7.1 - COMEÇO DA CLASSE CAT3BAR - IA 15-05
/*
class Cat3Bar extends StatefulWidget {
  final Function(String) onCategorySelected;
  final bool isVertical;

  const Cat3Bar({Key? key, required this.onCategorySelected, required this.isVertical}) : super(key: key);

  @override
  State<Cat3Bar> createState() => _Cat3BarState();
}

List<CatModel> cats = [];
List<EanModel> gridList = [];
String selectedCat = "";

final DBGrid _dbGrid = DBGrid();

class _Cat3BarState extends State<Cat3Bar> {
  @override
  Widget build(BuildContext context) {
    String asset = "assets/xml/HH_CAT.xml";
    return Container(
      padding: const EdgeInsets.only(top: 2, bottom: 0, left: 0, right: 0),
      color: HHColors.hhColorGreyLight,
      child: FutureBuilder(
        future: XMLS3Data().getCatModelAssetXML(asset),
               builder: (context, data) {
          if (data.hasData) {
            cats = data.requireData;
            return ListView.builder(
              scrollDirection: widget.isVertical ? Axis.vertical : Axis.horizontal, // Adicionado scrollDirection
              itemCount: cats.length,
              itemBuilder: (context, index) => 
                Cat3Tile(
                  onPressed: () async {
                      SearchModel cat = SearchModel(
                          sigla: HHGlobals.selectedCat,
                          searchType: "category",
                      );
                      var newGridList = await _dbGrid.getProductsForGrid(cat);
                      var newSelectedCat = HHGlobals.selectedCat;
                      setState(() {
                          gridList = newGridList;
                          HHGlobals.HHGridList.value = gridList;
                          

                          selectedCat = newSelectedCat;
                          widget.onCategorySelected(selectedCat);
                          print("Cat3Bar: " + selectedCat);
                      });
                  },
                  /*onPressed: () {
                    setState(() async {
                            EanModel cat = EanModel(
                              sigla: HHGlobals.selectedCat,
                              search: "category",
                            );
                      gridList = await _dbGrid.getProductsForGrid(cat);
                      HHGlobals.HHGridList.value = gridList;
                      print(gridList);
                      

                      selectedCat = HHGlobals.selectedCat;
                      widget.onCategorySelected(selectedCat);
                      print("Cat3Bar: " + selectedCat);
                    });
                  },*/
                  cat: cats[index],
                  selectedCat: selectedCat,
                  isVertical: widget.isVertical,
                ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
        /*builder: (context, data) {
          if (data.hasData) {
            categories = data.requireData;
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) => Cat3Tile(
                onPressed: () {
                  setState(() {
                    if (categories[index].level == 2) {
                      print("Cat3Bar: " + categories[index].sigla.toString());
                      selectedCat = categories[index].sigla ?? "";
                      widget.onCategorySelected(selectedCat);
                      print(selectedCat);
                    }
                  });
                },
                cat: categories[index],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },*/
      ),
    );
  }
}
*/
// FIM DA CLASSE CAT3BAR - IA 15-05


//v6 - 13-05
/*class Cat3Bar extends StatefulWidget {
  final Function(String) onCategorySelected;
  final bool vertical;

  const Cat3Bar({Key? key, required this.onCategorySelected, required this.vertical}) : super(key: key);

  @override
  _Cat3BarState createState() => _Cat3BarState();
}

List<CatModel> categories = [];
String selectedCat = "";

class _Cat3BarState extends State<Cat3Bar> {
  // Adicionado um mapa para acompanhar quais tiles estão expandidos
  Map<String, bool> expandedTiles = {};

  @override
  Widget build(BuildContext context) {
    String asset = "assets/xml/HH_CAT.xml";
    return Container(
      padding: const EdgeInsets.only(top: 2, bottom: 0, left: 0, right: 0),
      color: HHColors.hhColorGreyLight,
      child: FutureBuilder(
        future: XMLS3Data().getCatModelAssetXML(asset),
        builder: (context, data) {
          if (data.hasData) {
            categories = data.requireData;
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                // Verifique se o tile está expandido no mapa, caso contrário, defina como falso por padrão
                bool isExpanded = expandedTiles[categories[index].sig] ?? false;
                return Cat3Tile(
                  cat: categories[index],
                  isExpanded: isExpanded,
                  onPressed: () {
                    setState(() {
                      // Atualize o estado do tile expandido quando ele for pressionado
                      expandedTiles[categories[index].sig] = !isExpanded;
                    });
                  },
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}*/


//v4 com cat3Tile v6 --- nao funciona --- logica de selecao de categoria nao funciona
/*
class Cat3Bar extends StatefulWidget {
  final Function(String) onCategorySelected;
  final bool vertical;

  const Cat3Bar({Key? key, required this.onCategorySelected, required this.vertical}) : super(key: key);

  @override
  State<Cat3Bar> createState() => _Cat3BarState();
}

class _Cat3BarState extends State<Cat3Bar> {

  List<CatModel> categories = [];
  String selectedCat = "";

  @override
  Widget build(BuildContext context) {
    String asset = "assets/xml/HH_CAT.xml";
    return Container(
      padding: const EdgeInsets.only(top: 2, bottom: 0, left: 0, right: 0),
      color: HHColors.hhColorGreyLight,
      child: FutureBuilder(
        future: XMLS3Data().getCatModelAssetXML(asset),
        builder: (context, data) {
          if (data.hasData) {
            categories = data.requireData;
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) => Cat3Tile(
                onPressed: () {
                  if(categories[index].level == 2){
                    setState(() {
                      selectedCat = categories[index].sig;
                      widget.onCategorySelected(selectedCat);
                    });
                  }
                },
                cat: categories[index],
                isSelected: categories[index].sig == selectedCat,
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

//v3 - funcionando com cat3Tile v5
/*class Cat3Bar extends StatefulWidget {
  final Function(String) onCategorySelected;
  final bool vertical;

  const Cat3Bar({Key? key, required this.onCategorySelected, required this.vertical}) : super(key: key);

  @override
  State<Cat3Bar> createState() => _Cat3BarState();
}

class _Cat3BarState extends State<Cat3Bar> {
  List<CatModel> categories = [];
  String selectedCat = "";

  @override
  Widget build(BuildContext context) {
    String asset = "assets/xml/HH_CAT.xml";
    return Container(
      padding: const EdgeInsets.only(top: 2, bottom: 0, left: 0, right: 0),
      color: HHColors.hhColorGreyLight,
      child: FutureBuilder(
        future: XMLS3Data().getCatModelAssetXML(asset),
        builder: (context, data) {
          if (data.hasData) {
            categories = data.requireData;
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) => Cat3Tile(
                onPressed: () {
                  setState(() {
                    selectedCat = categories[index].sig;
                    widget.onCategorySelected(selectedCat);
                  });
                },
                cat: categories[index],
                isSelected: categories[index].sig == selectedCat,
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}*/


//v2 - funcionando com cat3Tile v4 SEM LOGICA DE SELECAO
/*class Cat3Bar extends StatefulWidget {
  final Function(String) onCategorySelected;
  final bool vertical;

  const Cat3Bar({Key? key, required this.onCategorySelected, required this.vertical}) : super(key: key);

  @override
  State<Cat3Bar> createState() => _Cat3BarState();
}

List<CatModel> categories = [];
String selectedCat = "";

class _Cat3BarState extends State<Cat3Bar> {
  @override
  Widget build(BuildContext context) {
    String asset = "assets/xml/HH_CAT.xml";
    return Container(
      padding: const EdgeInsets.only(top: 2, bottom: 0, left: 0, right: 0),
      color: HHColors.hhColorGreyLight,
      child: FutureBuilder(
        future: XMLS3Data().getCatModelAssetXML(asset),
        builder: (context, data) {
          if (data.hasData) {
            categories = data.requireData;
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) => Cat3Tile(
                onPressed: () {
                  setState(() {
                    if (categories[index].level == 2) {
                      selectedCat = categories[index].sigla ?? "";
                      widget.onCategorySelected(selectedCat);
                      print(selectedCat);
                    }
                    //categories[index].level==2?  selectedCat = categories[index].sigla : ();
                    //widget.onCategorySelected(selectedCat);
                  });
                },
                cat: categories[index],
                //level: categories[index].level,
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}*/


//v1
/*class Cat3Bar extends StatefulWidget {
  final Function(String) onCategorySelected;
  final bool vertical;

  const Cat3Bar({Key? key, required this.onCategorySelected, required this.vertical,}) : super(key: key);

  @override
  State<Cat3Bar> createState() => _Cat3BarState();
}

List<CatModel> categories = [];
String selectedCat = "";

class _Cat3BarState extends State<Cat3Bar> {
  final innerController = ScrollController(); // Adicione esta linha

  @override
  Widget build(BuildContext context) {
    //String url = "${HHAddress.urlXml}.xml"; //URL
    String asset = "assets/xml/HH_CAT.xml";
    return Container(
      padding: const EdgeInsets.only(top: 2, bottom: 0, left: 0, right: 0),
      color: HHColors.hhColorGreyLight,
      child: FutureBuilder(
        //future: XMLS3Data().getCatModelUrlXML(url),
        future: XMLS3Data().getCatModelAssetXML(asset),
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
                      scrollDirection: widget.vertical ? Axis.vertical : Axis.horizontal, //ChatGPT
                      itemCount: categories.length,
                      itemBuilder: (context, index) => Stack(children: [
                        Cat3Tile(
                          onPressed: (){
                            setState(() {
                              selectedCat = categories[index].sig;
                              print("SELECTED: $selectedCat");
                              //HHGlobals.category = categories[index];
                              widget.onCategorySelected(selectedCat); ///ChatGPT
                            }
                            );
                          },
                          cat: categories[index],
                          level: categories[index].level,
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
}*/
