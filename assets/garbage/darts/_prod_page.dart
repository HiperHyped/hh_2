/// sem drawer - funcionando
/////// COMEÇO PRODPAGE
/*
class ProdPage extends StatefulWidget {
  

  ProdPage({
    Key? key,
    required this.isVertical,
  }) : super(key: key);

  final bool isVertical;

  @override
  State<ProdPage> createState() => _ProdPageState();
}

class _ProdPageState extends State<ProdPage> {

  //final ValueNotifier<String> _ufNotifier = ValueNotifier<String>(HHGlobals.HHUser.uf);
  
  /*void _onUFChanged() {
    //_ufNotifier.value = HHGlobals.uf;
    _ufNotifier.value = HHGlobals.HHUser.uf;
    print("UF: ${HHGlobals.HHUser.uf}");
  }*/
  

  String _selectedCategory = HHGlobals.selectedCat; //CATEGORIA INICIAL
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Adicionar GlobalKey CHatGPT


  void _updateCategory(String newCategory) {
    setState(() {
      _selectedCategory = newCategory;
    });
  }

Widget _buildBody(bool isDesktop, bool isLandscape, bool isVertical) {
  
  //FLEX ENTRE CATBAR E GRIDTAB
  int catBarFlex =  isLandscape ? 
    (isVertical ? 1 : 1): 
    (isVertical ? 1 : 1);     

  int gridTabFlex = isLandscape ? 
    (isVertical ? HHVar.cgLVratio : HHVar.cgLHratio): //(1:6) (1:5)
    (isVertical ? HHVar.cgPVratio : HHVar.cgPHratio); //(2:5) (1:7)


  int vCross = isLandscape ? HHVar.grLVline : HHVar.grPVline; 
  int hCross = isLandscape ? HHVar.grLHline : HHVar.grPHline;

  return widget.isVertical
      ? Row( // Row (VERTICAL)
          children: [
            Container(
              width: 2,
              color: HHColors.hhColorGreyMedium,
            ),
            Flexible(
              flex: catBarFlex,
              child: 
                Cat3Bar(
                //CatBar(  //////ATENÇÃO!!!
                  onCategorySelected: _updateCategory,
                  isVertical: widget.isVertical,
                ),
            ),
            Container(
              width: 2,
              color: HHColors.hhColorGreyMedium,
            ),
            Flexible(
              flex: gridTabFlex,
              child: GridTab(
                isVertical: widget.isVertical,
                category: _selectedCategory,
                vCross: vCross,
                hCross: hCross,
                uf: HHGlobals.HHUser.uf,
              ),
            ),
          ],
        )
      : Column(
          children: [
            Container(
              height: 2,
              color: HHColors.hhColorGreyDark,
            ),
            Flexible(
              flex: catBarFlex,
              child: 
                Cat3Bar(  
                //CatBar(   //////ATENÇÃO!!!!
                onCategorySelected: _updateCategory,
                isVertical: widget.isVertical,
              ),
            ),
            Container(
              height: 2,
              color: HHColors.hhColorGreyMedium,
            ),
            Flexible(
              flex: gridTabFlex,
              child: GridTab(
                isVertical: widget.isVertical,
                category: _selectedCategory,
                vCross: vCross,
                hCross: hCross,
                uf: HHGlobals.HHUser.uf,
              ),
            ),
          ],
        );
}

  @override
  Widget build(BuildContext context) {
    

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey, // Adicionar GlobalKey ao Scaffold ChatGPT
        backgroundColor: Colors.white,

        // TOP BAR 
        //appBar: TopBar(onUFChanged: _onUFChanged), 
        appBar: TopBar(),

        body: OrientationBuilder(
                  builder: (context, orientation) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        // Verifica se o dispositivo é desktop ou mobile.
                        bool isDesktop = constraints.maxWidth >= 600;
                        // Verifica se a orientação é paisagem.
                        bool isLandscape = orientation == Orientation.landscape;
                        return _buildBody(isDesktop, isLandscape, widget.isVertical);
                      },
                    );
                  },
                ),
      ),
    );
  }
}
*/
// FIM PRODPAGE

/////// COMEÇO PRODPAGE - versão DRAWER
/*class ProdPage extends StatefulWidget {
  

  ProdPage({
    Key? key,
    required this.isVertical,
  }) : super(key: key);

  final bool isVertical;

  @override
  State<ProdPage> createState() => _ProdPageState();
}

class _ProdPageState extends State<ProdPage> {
  ValueNotifier<String> _ufNotifier = ValueNotifier<String>(HHGlobals.uf);
  void _onUFChanged() {
    _ufNotifier.value = HHGlobals.uf;
  }
  

  String _selectedCategory = HHGlobals.selectedCat; //CATEGORIA INICIAL
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Adicionar GlobalKey CHatGPT


  void _updateCategory(String newCategory) {
    setState(() {
      _selectedCategory = newCategory;
    });
  }

  ///DRAWER

  // IA 16-05-23
  bool _isDrawerOpen = false; 
  double _dragExtent = 0.0;

    void _toggleDrawer() {
    if (_scaffoldKey.currentState!.isDrawerOpen) {
      Navigator.of(context).pop();  // close the drawer
    } else {
      _scaffoldKey.currentState!.openDrawer();  // open the drawer
    }
  }

  Widget _buildDrawer() {
    return AnimatedContainer(
      width: _dragExtent,
      duration: Duration(milliseconds: 250), 
      child: Stack(
        children: [
          Container(
            color: HHColors.hhColorGreyMedium,
            child: Cat3Bar(
              onCategorySelected: _updateCategory,
              isVertical: widget.isVertical,
            ),
          ),
          if (_isDrawerOpen) 
            Positioned.fill(
              child: Listener(
                onPointerDown: (_) {
                  setState(() {
                    _isDrawerOpen = false; 
                    _dragExtent = 0.0; 
                  });
                },
              ),
            ),
          if (_dragExtent == 0.0)
            Positioned(
              top: MediaQuery.of(context).size.height / 2,
              child: IconButton(
                icon: Icon(Icons.menu),
                onPressed: _toggleDrawer,
              ),
            ),
        ],
      ),
    );
  }

  double calculateWidthFactor() {
  if (MediaQuery.of(context).orientation == Orientation.portrait) {
    return 0.33; // O drawer será 1/3 da largura da tela em retrato
  } else {
    return 0.5; // O drawer será 1/2 da largura da tela em paisagem
  }
}

  ///DRAWER

Widget _buildBody(bool isDesktop, bool isLandscape, bool isVertical) {
  
  //FLEX ENTRE CATBAR E GRIDTAB
  int catBarFlex =  isLandscape ? 
    (isVertical ? 1 : 1): 
    (isVertical ? 1 : 1);     

  int gridTabFlex = isLandscape ? 
    (isVertical ? HHVar.cgLVratio : HHVar.cgLHratio): //(1:6) (1:5)
    (isVertical ? HHVar.cgPVratio : HHVar.cgPHratio); //(2:5) (1:7)


  int vCross = isLandscape ? HHVar.grLVline : HHVar.grPVline; 
  int hCross = isLandscape ? HHVar.grLHline : HHVar.grPHline;

  return widget.isVertical ? 
        GestureDetector(
          onHorizontalDragUpdate: _handleDragUpdate,
          onHorizontalDragEnd: _handleDragEnd,
          child: Row(
            children: [
              //CAT3BAR
              _buildDrawer(), 
              //GRIDTAB
              Expanded(
                child: ValueListenableBuilder<String>(
                  valueListenable: _ufNotifier,
                  builder: (BuildContext context, String uf, Widget? child) {
                    return GridTab(
                      isVertical: widget.isVertical,
                      category: _selectedCategory,
                      vCross: vCross,
                      hCross: hCross,
                      uf: uf, // Use a variável 'uf' em vez de 'HHGlobals.uf'
                    );
                  },
                ),
              ),
            ],
          ),
        )
  
      : Column(
          children: [
            Container(
              height: 2,
              color: HHColors.hhColorGreyDark,
            ),
            Flexible(
              flex: catBarFlex,
              child: 
                Cat3Bar(  
                //CatBar(   //////ATENÇÃO!!!!
                onCategorySelected: _updateCategory,
                isVertical: widget.isVertical,
              ),
            ),
            Container(
              height: 2,
              color: HHColors.hhColorGreyMedium,
            ),
            Flexible(
              flex: gridTabFlex,
              child: ValueListenableBuilder<String>(
                valueListenable: _ufNotifier,
                builder: (BuildContext context, String uf, Widget? child) {
                  return GridTab(
                    isVertical: widget.isVertical,
                    category: _selectedCategory,
                    vCross: vCross,
                    hCross: hCross,
                    uf: uf, // Use a variável 'uf' em vez de 'HHGlobals.uf'
                  );
                },
              ),
            ),
          ],
        );
}

  @override
  Widget build(BuildContext context) {
    

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey, // Adicionar GlobalKey ao Scaffold ChatGPT
        backgroundColor: Colors.white,

        // TOP BAR 
        appBar: TopBar(onUFChanged: _onUFChanged), // Adicione esta linha),

        drawer: FractionallySizedBox(
          widthFactor: calculateWidthFactor(), // Implemente esta função para calcular a proporção do drawer
          child: Drawer(
            child: Cat3Bar(
              onCategorySelected: _updateCategory,
              isVertical: widget.isVertical,
            ),
          ),
        ),

        body: OrientationBuilder(
                  builder: (context, orientation) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        // Verifica se o dispositivo é desktop ou mobile.
                        bool isDesktop = constraints.maxWidth >= 600;
                        // Verifica se a orientação é paisagem.
                        bool isLandscape = orientation == Orientation.landscape;
                        return _buildBody(isDesktop, isLandscape, widget.isVertical);
                      },
                    );
                  },
                ),
      ),
    );
  }
}*/

/////// COMEÇO PRODPAGE - versão drawer customixzado
/*class ProdPage extends StatefulWidget {
  

  ProdPage({
    Key? key,
    required this.isVertical,
  }) : super(key: key);

  final bool isVertical;

  @override
  State<ProdPage> createState() => _ProdPageState();
}

class _ProdPageState extends State<ProdPage> {
  ValueNotifier<String> _ufNotifier = ValueNotifier<String>(HHGlobals.uf);
  void _onUFChanged() {
    _ufNotifier.value = HHGlobals.uf;
  }
  

  String _selectedCategory = HHGlobals.selectedCat; //CATEGORIA INICIAL
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Adicionar GlobalKey CHatGPT


  void _updateCategory(String newCategory) {
    setState(() {
      _selectedCategory = newCategory;
    });
  }

  ///DRAWER
  /*
  // Valor que será atualizado pelo GestureDetector
  double _dragExtent = 0.0;

  // Função para lidar com o gesto de arrasto
  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragExtent += details.primaryDelta!;
      _dragExtent = _dragExtent.clamp(0.0, MediaQuery.of(context).size.width);
    });
  }

  // Função para lidar com o término do gesto de arrasto
  void _handleDragEnd(DragEndDetails details) {
    if (_dragExtent < MediaQuery.of(context).size.width / 2) {
      setState(() {
        _dragExtent = 0.0;
      });
    } else {
      setState(() {
        _dragExtent = MediaQuery.of(context).size.width;
      });
    }
  }

    // Função para abrir a gaveta quando o ícone é pressionado
  void _handleIconPress() {
    setState(() {
      _dragExtent = MediaQuery.of(context).size.width;
    });
  }*/

  // IA 16-05-23
  bool _isDrawerOpen = false; 
  double _dragExtent = 0.0;

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragExtent += details.primaryDelta!;
      _dragExtent = _dragExtent.clamp(0.0, MediaQuery.of(context).size.width);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    setState(() {
      _isDrawerOpen = _dragExtent >= MediaQuery.of(context).size.width / 2; 
      _dragExtent = _isDrawerOpen ? MediaQuery.of(context).size.width : 0.0; 
    });
  }

  void _handleIconPress() {
    setState(() {
      _isDrawerOpen = true; 
      _dragExtent = MediaQuery.of(context).size.width; 
    });
  }

  Widget _buildDrawer() {
    return AnimatedContainer(
      width: _dragExtent,
      duration: Duration(milliseconds: 250), 
      child: Stack(
        children: [
          Container(
            color: HHColors.hhColorGreyMedium,
            child: Cat3Bar(
              onCategorySelected: _updateCategory,
              isVertical: widget.isVertical,
            ),
          ),
          if (_isDrawerOpen) 
            Positioned.fill(
              child: Listener(
                onPointerDown: (_) {
                  setState(() {
                    _isDrawerOpen = false; 
                    _dragExtent = 0.0; 
                  });
                },
              ),
            ),
          if (_dragExtent == 0.0)
            Positioned(
              top: MediaQuery.of(context).size.height / 2,
              child: IconButton(
                icon: Icon(Icons.menu),
                onPressed: _handleIconPress,
              ),
            ),
        ],
      ),
    );
  }

  ///DRAWER

Widget _buildBody(bool isDesktop, bool isLandscape, bool isVertical) {
  
  //FLEX ENTRE CATBAR E GRIDTAB
  int catBarFlex =  isLandscape ? 
    (isVertical ? 1 : 1): 
    (isVertical ? 1 : 1);     

  int gridTabFlex = isLandscape ? 
    (isVertical ? HHVar.cgLVratio : HHVar.cgLHratio): //(1:6) (1:5)
    (isVertical ? HHVar.cgPVratio : HHVar.cgPHratio); //(2:5) (1:7)


  int vCross = isLandscape ? HHVar.grLVline : HHVar.grPVline; 
  int hCross = isLandscape ? HHVar.grLHline : HHVar.grPHline;

  return widget.isVertical ? 
        GestureDetector(
          onHorizontalDragUpdate: _handleDragUpdate,
          onHorizontalDragEnd: _handleDragEnd,
          child: Row(
            children: [
              //CAT3BAR
              _buildDrawer(), 
              /*Container(
                width: _dragExtent,
                child: Stack(
                  children: [
                    Container(
                      color: HHColors.hhColorGreyMedium,
                      child: Cat3Bar(
                        onCategorySelected: _updateCategory,
                        isVertical: widget.isVertical,
                      ),
                    ),
                    // Adiciona o ícone no início da gaveta
                    if (_dragExtent == 0.0)
                      Positioned(
                        top: MediaQuery.of(context).size.height / 2,
                        child: IconButton(
                          icon: Icon(Icons.menu),
                          onPressed: _handleIconPress,
                        ),
                      ),
                  ],
                ),
              ),*/
              //GRIDTAB
              Expanded(
                child: ValueListenableBuilder<String>(
                  valueListenable: _ufNotifier,
                  builder: (BuildContext context, String uf, Widget? child) {
                    return GridTab(
                      isVertical: widget.isVertical,
                      category: _selectedCategory,
                      vCross: vCross,
                      hCross: hCross,
                      uf: uf, // Use a variável 'uf' em vez de 'HHGlobals.uf'
                    );
                  },
                ),
              ),
            ],
          ),
        )
      /*
      Row( // Row (VERTICAL)
          children: [
            Container(
              width: 2,
              color: HHColors.hhColorGreyMedium,
            ),
            Flexible(
              flex: catBarFlex,
              child: 
                Cat3Bar(
                //CatBar(  //////ATENÇÃO!!!
                  onCategorySelected: _updateCategory,
                  isVertical: widget.isVertical,
                ),
            ),
            Container(
              width: 2,
              color: HHColors.hhColorGreyMedium,
            ),
            Flexible(
              flex: gridTabFlex,
              child: ValueListenableBuilder<String>(
                valueListenable: _ufNotifier,
                builder: (BuildContext context, String uf, Widget? child) {
                  return GridTab(
                    isVertical: widget.isVertical,
                    category: _selectedCategory,
                    vCross: vCross,
                    hCross: hCross,
                    uf: uf, // Use a variável 'uf' em vez de 'HHGlobals.uf'
                  );
                },
              ),
            ),
          ],
        )
        */
      : Column(
          children: [
            Container(
              height: 2,
              color: HHColors.hhColorGreyDark,
            ),
            Flexible(
              flex: catBarFlex,
              child: 
                Cat3Bar(  
                //CatBar(   //////ATENÇÃO!!!!
                onCategorySelected: _updateCategory,
                isVertical: widget.isVertical,
              ),
            ),
            Container(
              height: 2,
              color: HHColors.hhColorGreyMedium,
            ),
            Flexible(
              flex: gridTabFlex,
              child: ValueListenableBuilder<String>(
                valueListenable: _ufNotifier,
                builder: (BuildContext context, String uf, Widget? child) {
                  return GridTab(
                    isVertical: widget.isVertical,
                    category: _selectedCategory,
                    vCross: vCross,
                    hCross: hCross,
                    uf: uf, // Use a variável 'uf' em vez de 'HHGlobals.uf'
                  );
                },
              ),
            ),
          ],
        );
}

  @override
  Widget build(BuildContext context) {
    

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey, // Adicionar GlobalKey ao Scaffold ChatGPT
        backgroundColor: Colors.white,

        // TOP BAR 
        appBar: TopBar(onUFChanged: _onUFChanged), // Adicione esta linha),



        body: OrientationBuilder(
                  builder: (context, orientation) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        // Verifica se o dispositivo é desktop ou mobile.
                        bool isDesktop = constraints.maxWidth >= 600;
                        // Verifica se a orientação é paisagem.
                        bool isLandscape = orientation == Orientation.landscape;
                        return _buildBody(isDesktop, isLandscape, widget.isVertical);
                      },
                    );
                  },
                ),
      ),
    );
  }
}
*/
// FIM PRODPAGE

        // Adicionar gaveta (Drawer) que contém a CatBar
        /*drawer: Drawer(
          child: CatBar(
            onCategorySelected: _updateCategory,
            vertical: widget.vertical,
          ),
        ),*/

        //Anterior
        /*body: Row(
          children: [
            //CATEGORIES - CAT BAR
              CatBar(onCategorySelected: _updateCategory), // ChatGPT
              //CatBar(), //anterior

            // PRODUCT MODELS
              GridTab(vertical: widget.vertical, category: _selectedCategory), //ChatGPT
              //GridTab(vertical: widget.vertical), // Anterior
           
          ],
        ),*/

        //ChatGPT
        /*body: widget.vertical
            ? Row(
                /*children: [
                  CatBar(onCategorySelected: _updateCategory, vertical: widget.vertical),
                  GridTab(vertical: widget.vertical, category: _selectedCategory),
                ],*/

                children: [
                  Flexible(flex: catBarFlex,
                    child: CatBar(onCategorySelected: _updateCategory, vertical: widget.vertical,),),
                  Flexible(flex: gridTabFlex,
                    child: GridTab(vertical: widget.vertical, category: _selectedCategory,),),
                ],
              )
            : Column(
                /*children: [
                  CatBar(onCategorySelected: _updateCategory, vertical: widget.vertical),
                  Expanded(
                    child: GridTab(vertical: widget.vertical, category: _selectedCategory),
                  ),
                ],*/
                children: [
                  Flexible(flex: catBarFlex,
                    child: CatBar(onCategorySelected: _updateCategory, vertical: widget.vertical,),),
                  Flexible(flex: gridTabFlex,
                    child: GridTab(vertical: widget.vertical, category: _selectedCategory,),),
                ],

              ),*/

        // ChatGPT 2


/*
class _ProdPageState extends State<ProdPage> {
  String _selectedCategory = "";

  void _updateCategory(String newCategory) {
    setState(() {
      _selectedCategory = newCategory;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Row(
          children: [
            //CATEGORIES - CAT BAR
            CatBar(
              onCategorySelected: _updateCategory,
            ),

            // PRODUCT MODELS
            GridTab(vertical: widget.vertical, category: _selectedCategory),
          ],
        ),
      ),
    );
  }
}*/
