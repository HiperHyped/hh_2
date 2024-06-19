import 'package:flutter/material.dart';
import 'package:hh_2/src/config/ai/ai_photo.dart';
import 'package:hh_2/src/config/ai/xerxes_operations.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/config/common/var/hh_enum.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/config/common/var/hh_notifiers.dart';
import 'package:hh_2/src/config/common/var/hh_settings.dart';
import 'package:hh_2/src/config/common/var/hh_var.dart';
import 'package:hh_2/src/config/db/db_book.dart';
import 'package:hh_2/src/config/db/db_history.dart';
import 'package:hh_2/src/config/db/db_periodic.dart';
import 'package:hh_2/src/pages/basket/basket_bar.dart';
import 'package:hh_2/src/pages/book/book_bar.dart';
import 'package:hh_2/src/pages/hint/hint_bar.dart';
import 'package:hh_2/src/pages/history/history_bar.dart';
import 'package:hh_2/src/pages/pay/pay_bar.dart';
import 'package:hh_2/src/pages/periodic/periodic_bar.dart';
import 'package:hh_2/src/pages/picture/picture_bar.dart';
import 'package:hh_2/src/pages/prodpage/prod_page.dart';
//import 'package:hh_2/src/pages/settings/setting_bar.dart'; // Ajuste a rota conforme a localização da SettingBar

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
  bool showImageBar = false;
  bool showHintBar = false;
  bool showCalendarBar = false; //Calendar
  bool showHistoryBar = false;
  bool showBookBar = false;
  //bool showSettingBar = false;
  bool showPayBar = false;

  late final DBHistory _dbHistory = DBHistory();
  late final DBBook _dbBook = DBBook();
  late final DBPeriodic _dbPeriodic = DBPeriodic();
  
  @override
  void initState() {
    super.initState();
    _dbHistory.loadHistoryOnce();
    _dbBook.loadUserRecipes();
    _dbPeriodic.loadPeriodicOnce(); // Periodic List

    HHNotifiers.counter[CounterType.BasketCount]!.addListener(() async {
      if (HHGlobals.HHBasket.value.isNotEmpty) {
        print("NOTIFIERS: ${HHNotifiers.counter[CounterType.BasketCount]}");
        print("HHSETTINGS.HINTSUGGEST: ${HHSettings.hintSuggest}");
        if (HHSettings.hintSuggest) {
          HHGlobals.isProcessing[Functions.hint]?.value = true;
          XerxesOperations operations = XerxesOperations();
          await operations.performOperations();
          HHGlobals.isProcessing[Functions.hint]?.value = false;
        }
      }
    });

    // Adicionando o listener para PictureCount
    HHNotifiers.counter[CounterType.PictureCount]!.addListener(() async {
      if (HHGlobals.pictureFileBytes.isNotEmpty) {
        AIPhoto aiPhoto = AIPhoto(imageBytes: HHGlobals.pictureFileBytes);
        await aiPhoto.analyzeImage(HHGlobals.pictureFileBytes); // Chamada assíncrona para processar a imagem
      }
    });

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
              height: HHVar.barHeight,
              child: BasketBar(totalPriceNotifier: totalPriceNotifier),
            ),
          ),
        if (showImageBar)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: HHVar.barHeight,
              child: PictureBar(), 
            ),
          ),
        if (showHistoryBar)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: HHVar.barHeight,
              child: HistoryBar(),
            ),
          ),
        if (showCalendarBar)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: HHVar.barHeight,
              child: PeriodicBar(),
            ),
          ),
        if (showHintBar)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 2*HHVar.barHeight,
              child: HintBar(),
            ),
          ),
        if (showBookBar)
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  height: 2*HHVar.barHeight,
                  child: BookBar(),
              ),
          ),
        /*if (showSettingBar)
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: HHColors.hhColorGreyLight,
                  height: 350, // Ajuste a altura conforme a necessidade
                  constraints: const BoxConstraints(maxWidth: 650),
                  child: SettingBar(),
                ),
            ),*/
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
                  showImageBar = !showImageBar;
                break;              
                case 2:
                  if (HHGlobals.HHUserHistory.value.basketHistory.isNotEmpty) showHistoryBar = !showHistoryBar;
                  break;
                case 3:
                  showCalendarBar = !showCalendarBar;
                break;                 
                case 4:
                  if (HHGlobals.HHSuggestionList.value.isNotEmpty) showHintBar = !showHintBar;
                  break;
                case 5:
                   if (HHGlobals.HHUserBook.value.isNotEmpty) showBookBar = !showBookBar;
                  break;
                /*case 7:
                  showSettingBar = !showSettingBar;
                break;*/
                case 6:
                  showPayBar = !showPayBar;
                  break;
                default:
                  break;
              }
            } else {
              // O usuário tocou em um botão diferente.
              // Portanto, ocultamos todas as barras e mostramos a barra correspondente.
              showBasketBar = false;
              showImageBar = false;
              showHintBar = false;
              showCalendarBar = false;
              showHistoryBar = false;
              //showSettingBar = false;
              showPayBar = false;
              showBookBar = false;
              currentIndex = index;

              switch (index) {
                case 0:
                  if (HHGlobals.HHBasket.value.isNotEmpty) showBasketBar = true;
                  break;
                case 1:
                  showImageBar = true;
                  break;  
                case 2:
                  if (HHGlobals.HHUserHistory.value.basketHistory.isNotEmpty) showHistoryBar = true;
                  break;
                case 3:
                  showCalendarBar = true;
                  break;     
                case 4:
                  if (HHGlobals.HHSuggestionList.value.isNotEmpty) showHintBar = true;
                  break;
                case 5:
                  if (HHGlobals.HHUserBook.value.isNotEmpty) showBookBar = true;
                  break;  
                /*case 7:
                  showSettingBar = true;
                  break;          */      
                case 6:
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

          // Imagem
          BottomNavigationBarItem(
            icon: ValueListenableBuilder<bool>(
              valueListenable: HHGlobals.isProcessing[Functions.image]!, //HHGlobals.isAIPhotoProcessing,
              builder: (context, isProcessing, _) {
                return badges.Badge(
                  badgeStyle: badges.BadgeStyle(
                    badgeColor: isProcessing ? Colors.transparent : HHColors.getColor(Functions.image),
                    padding: EdgeInsets.all(6.0),
                  ),
                  badgeContent: isProcessing
                      ? SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            color: HHColors.getColor(Functions.image),
                            strokeWidth: 4.0,
                          ),
                        )
                      : ValueListenableBuilder<int>(
                          valueListenable: HHNotifiers.counter[CounterType.PictureCount]!,
                          builder: (context, count, _) {
                            return Text(
                              count.toString(),
                              style: const TextStyle(color: Colors.white),
                            );
                          },
                        ),
                  position: badges.BadgePosition.topEnd(top: -5, end: -0),
                  showBadge: isProcessing || HHNotifiers.counter[CounterType.PictureCount]!.value > 0,
                  child: const Icon(size: 40, Icons.image_outlined),
                );
              },
            ),
            label: 'Imagem',
          ),

     
          // History
          BottomNavigationBarItem(
            icon: ValueListenableBuilder<bool>(
              valueListenable: HHGlobals.isProcessing[Functions.history]!,
              builder: (context, isProcessing, _) {
                return badges.Badge(
                  badgeStyle: badges.BadgeStyle(
                    badgeColor: isProcessing ? Colors.transparent : HHColors.getColor(Functions.history),
                    padding: EdgeInsets.all(6.0),
                  ),
                  badgeContent: isProcessing
                    ? SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          color: HHColors.getColor(Functions.history),
                          strokeWidth: 4.0,
                        ),
                      )
                    : ValueListenableBuilder<int>(
                        valueListenable: HHNotifiers.counter[CounterType.HistoryCount]!,
                        builder: (context, count, _) {
                          return Text(
                            count.toString(),
                            style: const TextStyle(color: Colors.white),
                          );
                        },
                      ),
                  position: badges.BadgePosition.topEnd(top: -5, end: -0),
                  showBadge: isProcessing || HHNotifiers.counter[CounterType.HistoryCount]!.value > 0,
                  child: const Icon(size: 40, Icons.calendar_month_outlined),
                );
              },
            ),
            label: 'Histórico',
          ),

          // Periodic
          BottomNavigationBarItem(
            icon: ValueListenableBuilder<bool>(
              valueListenable: HHGlobals.isProcessing[Functions.periodic]!,
              builder: (context, isProcessing, _) {
                return badges.Badge(
                  badgeStyle: badges.BadgeStyle(
                    badgeColor: isProcessing ? Colors.transparent : HHColors.getColor(Functions.periodic),
                    padding: EdgeInsets.all(6.0),
                  ),
                  badgeContent: isProcessing
                    ? SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          color: HHColors.getColor(Functions.periodic),
                          strokeWidth: 4.0,
                        ),
                      )
                    : ValueListenableBuilder<int>(
                        valueListenable: HHNotifiers.counter[CounterType.PeriodicCount]!,
                        builder: (context, count, _) {
                          return Text(
                            count.toString(),
                            style: const TextStyle(color: Colors.white),
                          );
                        },
                      ),
                  position: badges.BadgePosition.topEnd(top: -5, end: -0),
                  showBadge: isProcessing || HHNotifiers.counter[CounterType.PeriodicCount]!.value > 0,
                  child: const Icon(size: 40, Icons.history),
                );
              },
            ),
            label: 'Periódico',
          ),

          // Hint!
          BottomNavigationBarItem(
            icon: ValueListenableBuilder<bool>(
              valueListenable: HHGlobals.isProcessing[Functions.hint]!,
              builder: (context, isProcessing, _) {
                return badges.Badge(
                  badgeStyle: badges.BadgeStyle(
                    badgeColor: isProcessing ? Colors.transparent : HHColors.getColor(Functions.hint),
                    padding: EdgeInsets.all(6.0),
                  ),
                  badgeContent: isProcessing
                    ? SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          color: HHColors.getColor(Functions.hint),
                          strokeWidth: 4.0,
                        ),
                      )
                    : ValueListenableBuilder<int>(
                        valueListenable: HHNotifiers.counter[CounterType.HintCount]!,
                        builder: (context, count, _) {
                          return Text(
                            count.toString(),
                            style: const TextStyle(color: Colors.white),
                          );
                        },
                      ),
                  position: badges.BadgePosition.topEnd(top: -5, end: -0),
                  showBadge: isProcessing || HHNotifiers.counter[CounterType.HintCount]!.value > 0,
                  child: const Icon(size: 40, Icons.lightbulb_outline),
                );
              },
            ),
            label: 'Receitas',
          ),
    
          // Livro
          BottomNavigationBarItem(
            icon: ValueListenableBuilder<bool>(
              valueListenable: HHGlobals.isProcessing[Functions.book]!,
              builder: (context, isProcessing, _) {
                return badges.Badge(
                  badgeStyle: badges.BadgeStyle(
                    badgeColor: isProcessing ? Colors.transparent : HHColors.getColor(Functions.book),
                    padding: EdgeInsets.all(6.0),
                  ),
                  badgeContent: isProcessing
                    ? SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          color: HHColors.getColor(Functions.book),
                          strokeWidth: 4.0,
                        ),
                      )
                    : ValueListenableBuilder<int>(
                        valueListenable: HHNotifiers.counter[CounterType.BookCount]!,
                        builder: (context, count, _) {
                          return Text(
                            count.toString(),
                            style: const TextStyle(color: Colors.white),
                          );
                        },
                      ),
                  position: badges.BadgePosition.topEnd(top: -5, end: -0),
                  showBadge: isProcessing || HHNotifiers.counter[CounterType.BookCount]!.value > 0,
                  child: const Icon(size: 40, Icons.book_outlined),
                );
              },
            ),
            label: 'Livro',
          ),

          // Preferências
          /*const BottomNavigationBarItem(
            icon: Icon(size: 40, Icons.settings_outlined), // ícone de pagamento
            label: 'Preferências',
          ),*/

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




