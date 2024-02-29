import 'package:flutter/material.dart';
import 'package:hh_2/src/config/ai/xerxes_operations.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/config/common/var/hh_notifiers.dart';
import 'package:hh_2/src/config/common/var/hh_settings.dart';
import 'package:hh_2/src/config/db/db_book.dart';
import 'package:hh_2/src/config/db/db_history.dart';
import 'package:hh_2/src/models/history_model.dart';
import 'package:hh_2/src/models/recipe_model.dart';
import 'package:hh_2/src/models/suggestion_model.dart';
import 'package:hh_2/src/pages/basket/basket_bar.dart';
import 'package:hh_2/src/pages/book/book_bar.dart';
import 'package:hh_2/src/pages/hint/hint_bar.dart';
import 'package:hh_2/src/pages/history/history_bar.dart';
import 'package:hh_2/src/pages/pay/pay_bar.dart';
import 'package:hh_2/src/pages/prodpage/prod_page.dart';
import 'package:hh_2/src/pages/settings/setting_bar.dart'; // Ajuste a rota conforme a localização da SettingBar

import 'package:badges/badges.dart' as badges;




//BASESCREEN FUNCIONANDO 02/06
class BaseScreen extends StatefulWidget {

  const BaseScreen({Key? key}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int currentIndex = 0;
  final totalPriceNotifier = ValueNotifier<double>(0.0);

  
  bool showBasketBar = false;
  bool showHintBar = false;
  bool showHistoryBar = false;
  bool showBookBar = false;
  bool showSettingBar = false;
  bool showPayBar = false;

  late final DBHistory _dbHistory = DBHistory();
  late final DBBook _dbBook = DBBook();
  
  @override
  void initState() {
    super.initState();
    loadHistoryOnce();
    loadUserRecipes();

    //HHNotifiers.counter['basketItemCount']!.value = HHGlobals.HHBasket.value.productQuantities.length;
    //HHGlobals.HHBasket.value.products
    // IA: 2023-06-08 - Atualizar o contador de itens da cesta sempre que a cesta mudar.
    /// e APLICAR XERXES!!!!!!
    HHNotifiers.counter[CounterType.BasketCount]!.addListener(() async {
      if(HHGlobals.HHBasket.value.isNotEmpty ) {
        print("NOTIFIERS: ${HHNotifiers.counter[CounterType.BasketCount]}");
        print("HHSETTINGS.HINTSUGGEST: ${HHSettings.hintSuggest}");
        if(HHSettings.hintSuggest){
          XerxesOperations operations = XerxesOperations();
          await operations.performOperations();
        }
      }
    });
  }

  void loadHistoryOnce() async {
      HistoryModel history = await _dbHistory.getBasketHistory(HHGlobals.HHUser.userId);
      HHGlobals.HHUserHistory.value = history;
      HHNotifiers.counter[CounterType.HistoryCount]!.value = history.basketHistory.length;
    }

  /*void loadHistoryOnce() async {
    HistoryModel history = await _dbHistory.getBasketSummary(HHGlobals.HHUser.userId);
    HHGlobals.HHUserHistory.value = history;
    HHNotifiers.counter[CounterType.HistoryCount]!.value = history.basketHistory.length;
  }*/

  void loadUserRecipes() async {
      List<SuggestionModel> suggestions = await _dbBook.getSuggestionsByUserId(HHGlobals.HHUser.userId);
      HHGlobals.HHUserBook.value = suggestions;
      HHNotifiers.counter[CounterType.BookCount]!.value = suggestions.length;
  }

  @override
  void dispose() {
    HHGlobals.HHBasket.removeListener(() {});

    super.dispose();
  }
  

  Widget _buildBody(bool isLandscape) {
    return Stack(
      children: [
        Positioned.fill( //ou Container ----- havia um Expanded aqui e isso dava erro...
          child: ProdPage(),
        ),
        if (showBasketBar)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              child: BasketBar(totalPriceNotifier: totalPriceNotifier),
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
        if (showHintBar)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 200,
              child: HintBar(),
            ),
          ),
        if (showBookBar)
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  height: 200,
                  child: BookBar(),
              ),
          ),
        if (showSettingBar)
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: HHColors.hhColorGreyLight,
                  height: 330, // Ajuste a altura conforme a necessidade
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: SettingBar(),
                ),
            ),
        if (showPayBar)
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 70,
                child: PayBar(totalPriceNotifier: totalPriceNotifier),
              ),
            ),
          /*Positioned(
            bottom: 0,
            right: 0,
            child: PayBar(totalPriceNotifier: totalPriceNotifier),
          ),*/
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          bool isLandscape = orientation == Orientation.landscape;
          return _buildBody(isLandscape);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,  // Os rótulos dos itens selecionados são exibidos
        showUnselectedLabels: false,  // Os rótulos dos itens não selecionados são ocultados
        currentIndex: currentIndex,
         onTap: (index) {
          setState(() {
            if (currentIndex == index) {
              // O usuário tocou no botão da barra atualmente visível.
              // Portanto, alternamos o estado visível da respectiva barra.
              switch (index) {
                case 0:
                  if (HHGlobals.HHBasket.value.isNotEmpty) showBasketBar = !showBasketBar;
                  break;
                case 1:
                  if (HHGlobals.HHUserHistory.value.basketHistory.isNotEmpty) showHistoryBar = !showHistoryBar;
                  break;
                case 2:
                  if (HHGlobals.HHSuggestionList.value.isNotEmpty) showHintBar = !showHintBar;
                  break;
                case 3:
                   if (HHGlobals.HHUserBook.value.isNotEmpty) showBookBar = !showBookBar;
                  break;
                case 4:
                  showSettingBar = !showSettingBar;
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
              showHistoryBar = false;
              showSettingBar = false;
              showPayBar = false;
              showBookBar = false;
              currentIndex = index;

              switch (index) {
                case 0:
                  if (HHGlobals.HHBasket.value.isNotEmpty) showBasketBar = true;
                  break;
                case 1:
                  if (HHGlobals.HHUserHistory.value.basketHistory.isNotEmpty) showHistoryBar = true;
                  break;
                case 2:
                  if (HHGlobals.HHSuggestionList.value.isNotEmpty) showHintBar = true;
                  break;
                case 3:
                  if (HHGlobals.HHUserBook.value.isNotEmpty) showBookBar = true;
                  break;  
                case 4:
                  showSettingBar = true;
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
              valueListenable: HHNotifiers.counter[CounterType.BasketCount]!,
              builder: (context, count, _) => 
                badges.Badge(
                  badgeStyle: const badges.BadgeStyle(padding:EdgeInsets.all(6.0)),
                  badgeContent: Text(
                    count.toString(),
                    style: const TextStyle(color: Colors.white),
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
     
          // Historico
          BottomNavigationBarItem(
            icon: ValueListenableBuilder<int>(
              valueListenable: HHNotifiers.counter[CounterType.HistoryCount]!,
              builder: (context, count, _) => 
                badges.Badge(
                  badgeStyle: const badges.BadgeStyle(
                    badgeColor: Colors.purple,
                    shape: badges.BadgeShape.circle,
                    padding: EdgeInsets.all(6.0),
                  ),
                  badgeContent: Text(
                    count.toString(),
                    style: const TextStyle(color: Colors.white),
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


          // Hint!
          BottomNavigationBarItem(
            icon: ValueListenableBuilder<int>(
              valueListenable: HHNotifiers.counter[CounterType.HintCount]!,
              builder: (context, count, _) => 
                badges.Badge(
                badgeStyle: badges.BadgeStyle(
                  badgeColor: HHColors.hhColorDarkFirst,
                  shape: badges.BadgeShape.circle,
                  padding: const EdgeInsets.all(6.0),
                  //borderRadius: BorderRadius.circular(10),
                  ),
                badgeContent: Text(
                  count.toString(),
                  style: const TextStyle(color: Colors.white),
                  ),
                position: badges.BadgePosition.topEnd(top: -5, end: -0),
                showBadge: count >= 1 ? true : false,
                child: const Icon(
                  size: 40,
                  Icons.lightbulb_outline
                  ),
                ),
              ),
            label: 'Receitas',
          ),
    
          // Livro
          BottomNavigationBarItem(
            icon: ValueListenableBuilder<int>(
                valueListenable: HHNotifiers.counter[CounterType.BookCount]!,  // Certifique-se de ter um CounterType para BookCount
                builder: (context, count, _) => 
                    badges.Badge(
                        badgeStyle: const badges.BadgeStyle(
                            badgeColor: Colors.blueAccent,
                            shape: badges.BadgeShape.circle,
                            padding: EdgeInsets.all(6.0),
                        ),
                        badgeContent: Text(
                            count.toString(),
                            style: const TextStyle(color: Colors.white),
                        ),
                        position: badges.BadgePosition.topEnd(top: -5, end: -0),
                        showBadge: count >= 1 ? true : false,
                        child: const Icon(
                            size: 40,
                            Icons.book_outlined
                        ),
                    ),
            ),
            label: 'Livro',
          ),

          // Preferências
          const BottomNavigationBarItem(
            icon: Icon(size: 40, Icons.settings_outlined), // ícone de pagamento
            label: 'Preferências',
          ),

          // Pagamento
          const BottomNavigationBarItem(
            icon: Icon(size: 40,Icons.payment), // ícone de pagamento
            label: 'Pagamento',
          ),
        ],
      ),
    );
  }
}




