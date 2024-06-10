
////////////////////////
//BASESCREEN FUNCIONANDO 16/06
/*class BaseScreen extends StatefulWidget {
  final bool isVertical;

  const BaseScreen({Key? key, required this.isVertical}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int currentIndex = 0;
  final totalPriceNotifier = ValueNotifier<double>(0.0);

  
  bool showBasketBar = false;
  bool showHintBar = false;
  bool showSuggestionBar = false;
  bool showRecipeBar = false;
  bool showHistoryBar = false;
  bool showPayBar = false;
  
  @override
  void initState() {
    super.initState();
    

    // IA: 2023-06-08 - Atualizar o contador de itens da cesta sempre que a cesta mudar.
    /// e APLICAR XERXES!!!!!!
    HHGlobals.HHBasket.addListener(() async {
        XerxesOperations operations = XerxesOperations();
        if(HHGlobals.HHBasket.value.products.isNotEmpty)
          await operations.performOperations();
    });
  }

  @override
  void dispose() {
    HHGlobals.HHBasket.removeListener(() {});

    super.dispose();
  }
  

  Widget _buildBody(bool vertical, bool isLandscape) {
    return Stack(
      children: [
        Positioned.fill( //ou Container ----- havia um Expanded aqui e isso dava erro...
          child: ProdPage(isVertical: vertical),
        ),
        if (showBasketBar)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              child: BasketBar(totalPriceNotifier: totalPriceNotifier),
            ),
          ),
        if (showHintBar)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 200,
              child: HintBar(),
            ),
          ),
        if (showSuggestionBar)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              child: SuggestionBar(),
            ),
          ),
        if (showRecipeBar)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              child: RecipeBar(),
            ),
          ),
        if (showHistoryBar)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              child: HistoryBar(),
            ),
          ),
        if (showPayBar)
          Positioned(
            bottom: 0,
            right: 0,
            child: PayBar(totalPriceNotifier: totalPriceNotifier),
          ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          bool isLandscape = orientation == Orientation.landscape;
          return _buildBody(widget.isVertical, isLandscape);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
         onTap: (index) {
          setState(() {
            if (currentIndex == index) {
              // O usuário tocou no botão da barra atualmente visível.
              // Portanto, alternamos o estado visível da respectiva barra.
              switch (index) {
                case 0:
                  showBasketBar = !showBasketBar;
                  break;
                case 1:
                  showHintBar = !showHintBar;
                  break;
                case 2:
                  showSuggestionBar = !showSuggestionBar;
                  break;
                case 3:
                  showRecipeBar = !showRecipeBar;
                  break;
                case 4:
                  showHistoryBar = !showHistoryBar;
                  break;
                case 5:
                  showPayBar = !showPayBar;
                  break;
                default:
                  break;
              }
            } else {
              // O usuário tocou em um botão diferente.
              // Portanto, ocultamos todas as barras e mostramos a barra correspondente.
              showBasketBar = false;
              showHintBar = false;
              showSuggestionBar = false;
              showRecipeBar = false;
              showHistoryBar = false;
              showPayBar = false;
              currentIndex = index;

              switch (index) {
                case 0:
                  showBasketBar = true;
                  break;
                case 1:
                  showHintBar = true;
                  break;
                case 2:
                  showSuggestionBar = true;
                  break;
                case 3:
                  showRecipeBar = true;
                  break;
                case 4:
                  showHistoryBar = true;
                  break;
                case 5:
                  showPayBar = true;
                  break;
                default:
                  break;
              }
            }
          });
        },

        //Basket
        backgroundColor: HHColors.hhColorGreyMedium,
        elevation: 0,
        selectedItemColor: HHColors.hhColorFirst,
        unselectedItemColor: HHColors.hhColorGreyDark,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: ValueListenableBuilder<int>(
              valueListenable: HHNotifiers.counter['basketItemCount']!,
              builder: (context, count, _) => 
                badges.Badge(
                  badgeStyle: badges.BadgeStyle(padding:EdgeInsets.all(6.0)),
                  badgeContent: Text(
                    count.toString(),
                    style: TextStyle(color: Colors.white),
                    ),
                  position: badges.BadgePosition.topEnd(top: -5, end: -0),
                  showBadge: count >= 1 ? true : false,
                  child: const Icon(
                    size: 40,
                    Icons.shopping_cart_outlined
                    ),
                ),
              ),
            label: 'Carrinho',
          ),

          // Hint!
          BottomNavigationBarItem(
            icon: ValueListenableBuilder<int>(
              valueListenable: HHNotifiers.counter['suggestionCount']!,
              builder: (context, count, _) => 
                badges.Badge(
                badgeStyle:const badges.BadgeStyle(
                  badgeColor: Colors.brown,
                  shape: badges.BadgeShape.circle,
                  padding: EdgeInsets.all(6.0),
                  //borderRadius: BorderRadius.circular(10),
                  ),
                badgeContent: Text(
                  count.toString(),
                  style: TextStyle(color: Colors.white),
                  ),
                position: badges.BadgePosition.topEnd(top: -5, end: -0),
                showBadge: count >= 1 ? true : false,
                child: const Icon(
                  size: 40,
                  Icons.lightbulb_outline
                  ),
                ),
              ),
            label: 'Hint!',
          ),

          // Sugestões
          BottomNavigationBarItem(
            icon: ValueListenableBuilder<int>(
              valueListenable: HHNotifiers.counter['suggestionCount']!,
              builder: (context, count, _) => 
                badges.Badge(
                badgeStyle:const badges.BadgeStyle(
                  badgeColor: Colors.blue,
                  shape: badges.BadgeShape.circle,
                  padding: EdgeInsets.all(6.0),
                  //borderRadius: BorderRadius.circular(10),
                  ),
                badgeContent: Text(
                  count.toString(),
                  style: TextStyle(color: Colors.white),
                  ),
                position: badges.BadgePosition.topEnd(top: -5, end: -0),
                showBadge: count >= 1 ? true : false,
                child: const Icon(
                  size: 40,
                  Icons.lightbulb_outline
                  ),
                ),
              ),
            label: 'Sugestões',
          ),

          // Receitas
          BottomNavigationBarItem(
            icon: ValueListenableBuilder<int>(
              valueListenable: HHNotifiers.counter['recipeCount']!,
              builder: (context, count, _) => 
                badges.Badge(
                  badgeStyle:const badges.BadgeStyle(
                    badgeColor: Colors.amber,
                    shape: badges.BadgeShape.circle,
                    padding: EdgeInsets.all(6.0),
                    ),
                  badgeContent: Text(
                    count.toString(),
                    style: TextStyle(color: Colors.white),
                    ),
                  position: badges.BadgePosition.topEnd(top: -5, end: -0),
                  showBadge: count >= 1 ? true : false,
                  child: const Icon(
                    size: 40,
                    Icons.book_outlined
                    ),
                  ),
              ),
            label: 'Receitas',
          ),
          
          // Historico
          BottomNavigationBarItem(
            icon: ValueListenableBuilder<int>(
              valueListenable: HHNotifiers.counter['historyCount']!,
              builder: (context, count, _) => 
                badges.Badge(
                  badgeStyle:const badges.BadgeStyle(
                    badgeColor: Colors.purple,
                    shape: badges.BadgeShape.circle,
                    padding: EdgeInsets.all(6.0),
                    ),
                  badgeContent: Text(
                    count.toString(),
                    style: TextStyle(color: Colors.white),
                    ),
                  position: badges.BadgePosition.topEnd(top: -5, end: -0),
                  showBadge: count >= 1 ? true : false,
                  child: const Icon(
                    size: 40,
                    Icons.history
                    ),
                  ),
              ),
            label: 'Histórico',
          ),

          /*BottomNavigationBarItem(
            icon: Icon(size: 40, Icons.history), // ícone de pagamento
            label: 'Histórico',
          ),*/

          const BottomNavigationBarItem(
            icon: Icon(size: 40,Icons.payment), // ícone de pagamento
            label: 'Pagamento',
          ),
        ],
      ),
    );
  }
}*/



        // onTap simplificado dos botoes
        /*onTap: (index) {
          setState(() {
            showBasketBar = false;
            showSuggestionBar = false;
            showRecipeBar = false;
            showPayBar = false;
            currentIndex = index;
            
            switch (index) {
              case 0:
                showBasketBar = true;
                break;
              case 1:
                showSuggestionBar = true;
                break;
              case 2:
                showRecipeBar = true;
                break;
              case 4:
                showPayBar = true;
                break;
              default:
                break;
            }
          });
        },*/

        //onTap anterior
        /*
        onTap: (index) {
          setState(() {
            if (index == 3) {
              showPayBar = !showPayBar;
            } else {
              if (currentIndex == index) {
                switch (index) {
                  case 0:
                    showBasketBar = !showBasketBar;
                    break;
                  case 1:
                    showSuggestionBar = !showSuggestionBar;
                    break;
                  case 2:
                    showRecipeBar = !showRecipeBar;
                    break;
                  default:
                    break;
                }
              } else {
                switch (index) {
                  case 0:
                    showBasketBar = true;
                    break;
                  default:
                    showBasketBar = false;
                    break;
                }
              }
              currentIndex = index;
            }
          });
        },*/

/*
class _BaseScreenState extends State<BaseScreen> {
  int currentIndex=0;
  final pageController = PageController();
  final basketCount = ValueNotifier<int>(0);
  final totalPriceNotifier = ValueNotifier<double>(0.0);

  // Controle de visibilidade da BasketBar
  bool isBasketBarHidden = false;

  Widget _buildBody(bool vertical, bool isLandscape) {
    //FLEX ENTRE CATBAR E GRIDTAB
    int basketBarFlex =  isLandscape ? 
      (vertical ? 1 : 1): 
      (vertical ? 1 : 1);     

    int prodPageFlex = isLandscape ? 
      (vertical ? HHVar.pbLVratio : HHVar.pbLHratio): //(1:6) (1:5)
      (vertical ? HHVar.pbPVratio : HHVar.pbPHratio); //(2:5) (1:7)

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              flex: prodPageFlex, // FLEX PRODPAGE
              child: ProdPage(isVertical: vertical),
            ),
            GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0) {
                  setState(() {
                    print("DY: ${details.delta.dy}");
                    isBasketBarHidden = true;
                  });
                } else if (details.delta.dy < 0) {
                  setState(() {
                    print("DY: ${details.delta.dy}");
                    isBasketBarHidden = false;
                  });
                }
              },
              child: Container(
                height: 12,
                color: HHColors.hhColorFirst,
                child: Center(
                  child: Container(
                    width: 30,
                    height: 2,
                    color: HHColors.hhColorWhite,
                  ),
                ),
              ),
            ),
            if (!isBasketBarHidden)
              Expanded(
                flex: basketBarFlex, // FLEX BASKETBAR
                child: BasketBar(totalPriceNotifier: totalPriceNotifier),
              ),
            
          ],
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: PayBar(totalPriceNotifier: totalPriceNotifier),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
            bool isLandscape = orientation == Orientation.landscape;
          return _buildBody(widget.isVertical, isLandscape);
        },
      ),

      ///voltando essa ideia 02/06/23
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex=index;
            pageController.jumpToPage(index);
            pageController.animateToPage(
              index, 
              duration: const Duration(milliseconds: 2000), 
              curve: Curves.bounceInOut);
          });
        },
        backgroundColor: HHColors.hhColorGreyMedium,
        elevation: 0,
        selectedItemColor: HHColors.hhColorFirst,
        unselectedItemColor: HHColors.hhColorGreyDark,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined), // ícone de carrinho
            label: 'Carrinho',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.thumb_up_alt_outlined), // ícone de recomendações
            label: 'Recomendações',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined), // ícone de receitas
            label: 'Receitas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment), // ícone de pagamento
            label: 'Pagamento',
          ),
        ],
      ),

    );
  }
}
*/

// CLASSE BASE SCREEN funcionando
/*
class BaseScreen extends StatefulWidget {
  final bool isVertical;

  const BaseScreen({Key? key, required this.isVertical}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final basketCount = ValueNotifier<int>(0);
  final totalPriceNotifier = ValueNotifier<double>(0.0);

  Widget _buildBody(bool vertical, bool isLandscape) {
    //FLEX ENTRE CATBAR E GRIDTAB
    int basketBarFlex =  isLandscape ? 
      (vertical ? 1 : 1): 
      (vertical ? 1 : 1);     

    int prodPageFlex = isLandscape ? 
      (vertical ? HHVar.pbLVratio : HHVar.pbLHratio): //(1:6) (1:5)
      (vertical ? HHVar.pbPVratio : HHVar.pbPHratio); //(2:5) (1:7)

    return Stack( //IA 16-05-23: Substituído Column por Stack para permitir sobreposição
      children: [
        Column(
          children: [
            Expanded(
              flex: prodPageFlex, // FLEX PRODPAGE
              child: ProdPage(isVertical: vertical),
            ),
            Container(
              height: 2,
              color: HHColors.hhColorGreyDark,
            ),
            Expanded(
              flex: basketBarFlex, // FLEX BASKETBAR
              child: BasketBar(totalPriceNotifier: totalPriceNotifier),
            ),
            Container(
              height: 2,
              color: HHColors.hhColorGreyMedium,
            ),
          ],
        ),
        Positioned( //IA 16-05-23: Posicionado PayBar no canto inferior direito
          bottom: 0,
          right: 0,
          child: PayBar(totalPriceNotifier: totalPriceNotifier),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
            bool isLandscape = orientation == Orientation.landscape;
          return _buildBody(widget.isVertical, isLandscape);
        },
      ),
    );
  }
}
*/
//FIM BASESCREEN



//BASESECREEN 
/*
class BaseScreen extends StatefulWidget {
  final bool isVertical;

  const BaseScreen({Key? key, required this.isVertical}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final basketCount = ValueNotifier<int>(0);
  final totalPriceNotifier = ValueNotifier<double>(0.0);

  Widget _buildBody(bool vertical, bool isLandscape) {
    //FLEX ENTRE CATBAR E GRIDTAB
    int basketBarFlex =  isLandscape ? 
      (vertical ? 1 : 1): 
      (vertical ? 1 : 1);     

    int prodPageFlex = isLandscape ? 
      (vertical ? HHVar.pbLVratio : HHVar.pbLHratio): //(1:6) (1:5)
      (vertical ? HHVar.pbPVratio : HHVar.pbPHratio); //(2:5) (1:7)

    return Column(
      children: [
        Expanded(
          flex: prodPageFlex, // FLEX PRODPAGE
          child: ProdPage(isVertical: vertical),
        ),
        Container(
          height: 2,
          color: HHColors.hhColorGreyDark,
        ),
        Expanded(
          flex: basketBarFlex, // FLEX BASKETBAR
          child: SizedBox(
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  flex: 4,
                  child: BasketBar(totalPriceNotifier: totalPriceNotifier),
                ),
                Expanded(
                  flex: 1,
                  child: PayBar(totalPriceNotifier: totalPriceNotifier),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 2,
          color: HHColors.hhColorGreyMedium,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
            bool isLandscape = orientation == Orientation.landscape;
          return _buildBody(widget.isVertical, isLandscape);
        },
      ),
    );
  }
}
*/


/// COMEÇO BASESCREEN ANTERIOR
/*
class BaseScreen extends StatefulWidget {
  final bool vertical;

  const BaseScreen({Key? key, required this.vertical}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final basketCount = ValueNotifier<int>(0);
  final totalPriceNotifier = ValueNotifier<double>(0.0);
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: widget.vertical ? HHVar.vProdPageFlex : HHVar.hProdPageFlex,
            child: ProdPage(vertical: widget.vertical),
          ),
          Container(
            height: 2,
            color: HHColors.hhColorGreyDark,
          ),
          Expanded(
            flex: widget.vertical ? 1 : 1,
            child: SizedBox(
              //height: 150,
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    flex: 4,
                    child: BasketBar(totalPriceNotifier: totalPriceNotifier),
                  ),
                  Expanded(
                    flex: 1,
                    child: PayBar(totalPriceNotifier: totalPriceNotifier),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 2,
            color: HHColors.hhColorGreyMedium,
          ),
        ],
      ),
    );
  }
}
*/
///FIM BASESCREEN

/*class BaseScreen extends StatefulWidget {
  final bool vertical;

  const BaseScreen({Key? key, required this.vertical}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  //int currentIndex=0;
  //final pageController = PageController();
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Adicionar // GlobalKey ChatGPT
  final basketCount = ValueNotifier<int>(0);
  final totalPriceNotifier = ValueNotifier<double>(0.0); // Adicione esta linha


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProdPage(vertical: widget.vertical),
      bottomNavigationBar: SizedBox(
        height: 150,
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              flex: 4,
              child: BasketBar(totalPriceNotifier: totalPriceNotifier), // Passe o totalPriceNotifier,
            ),
            Expanded(
              flex: 1,
              child: PayBar(totalPriceNotifier: totalPriceNotifier), // Passe o totalPriceNotifier
            ),
          ],
        ),
      ),
      //bottomNavigationBar: BasketBar(),
      /*body: PageView(
        physics: const NeverScrollableScrollPhysics(), //NEVER PAGES 
        controller: pageController,
        children: [
          ProdPage(vertical: true),
          ProdPage(vertical: false),
        ]
      ),*/

      // BOTTOM NAVIGATION BAR 
      /*bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex=index;
              pageController.jumpToPage(index);
              pageController.animateToPage(
                index, 
                duration: const Duration(milliseconds: 2000), 
                curve: Curves.bounceInOut);
            });
          },
          
          backgroundColor: HHColors.hhColorGreyMedium,
          elevation: 0,
          selectedItemColor: HHColors.hhColorFirst,
          unselectedItemColor: HHColors.hhColorGreyDark,
          type: BottomNavigationBarType.fixed,
          items: const [
            //AISLE
            BottomNavigationBarItem(
              icon: Icon(Icons.horizontal_distribute),
              label: 'Prod Vertical',
              ),
            BottomNavigationBarItem(
              icon: Icon(Icons.vertical_distribute_rounded),
              label: 'Prod Horizontal',
              ),
          ],
             ),*/
    );
  }
}*/



        /*//XERXES
      
        
        // IA: 13/06/2023: Pegue a lista atual de produtos e os transforme em uma lista de nomes de produtos
        List<String> productNames = HHGlobals.HHBasket.value.products.map((product) => product.nome).toList();

        // XERXES X1
        Xerxes xerxes = Xerxes();
        SuggestionModel suggestion = await xerxes.x1(productNames);

        // IA: 13/06/2023: Verifica se a resposta de x1 é válida antes de incrementar o contador
        if(suggestion.recipe.isNotEmpty || suggestion.basketProductList.isNotEmpty) {
          suggestionCount.value++; // Incrementa o contador somente se a resposta não é vazia

          // XERXES X2
          suggestion.recipeModel = await xerxes.x2(suggestion);

          // IA: 13/06/2023: Verifica se a resposta de x2 é válida antes de incrementar o contador
          if(suggestion.recipeModel.description.isNotEmpty) {
            recipeCount.value++; // Incrementa o contador somente se a resposta não é vazia

            // IA: 13/06/2023: Verifica se ambas as respostas são válidas antes de adicionar à lista global
            if((suggestion.recipe.isNotEmpty || suggestion.basketProductList.isNotEmpty) &&
              suggestion.recipeModel.description.isNotEmpty) {
              HHGlobals.HHSuggestionList.value.add(suggestion);
            }
          }
        }
        */

      /* ANTIGO XERXES
      /////// XERXES X1
      Xerxes xerxes = Xerxes();
      SuggestionModel suggestion = await xerxes.x1(productNames);
      suggestionCount.value++;////isso é errado

      ////// XERXES X2
      suggestion.recipeModel = await xerxes.x2(suggestion);
      recipeCount.value++;///isso é errado

      HHGlobals.HHSuggestionList.value.add(suggestion);
      //print(HHGlobals.HHSuggestionList.value.toList());
      */
