import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/pages/pay/components/pay_by_pix_tab.dart';
import 'package:hh_2/src/pages/pay/components/pay_dialog.dart';
import 'package:intl/intl.dart';
import 'components/pay_by_card_tab.dart';
import 'components/pay_by_qr_tab.dart';


// IA: Reformulação da classe PayBar para funcionar como uma BottomNavigationBar
class PayBar extends StatefulWidget {
  final ValueNotifier<double> totalPriceNotifier;

  PayBar({required this.totalPriceNotifier});

  @override
  State<PayBar> createState() => _PayBarState();
}


class _PayBarState extends State<PayBar> {
  int _selectedIndex = 0;
  
  // IA: Definição das ações para cada item da barra de navegação
  void _onItemTapped(int index) {
    if(index == 0){
      HHGlobals.HHBasket.value.clearBasket();
      HHGlobals.HHBasket.notifyListeners();
    }else if(index == 1){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return PayByCardTab(totalPrice: widget.totalPriceNotifier.value);
        },
      );
    }else if(index == 2){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return PayByQRTab(totalPrice: widget.totalPriceNotifier.value);
        },
      );
    }else if(index == 3){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return PayByPixTab(totalPrice: widget.totalPriceNotifier.value);
        },
      );
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: HHGlobals.HHBasket.value.totalPriceNotifier,
      builder: (context, totalPrice, child) {
        return GestureDetector(
          onTap: () {}, // Defina uma ação aqui, se necessário
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: HHColors.hhColorGreyLight,
            ),
            child: Padding(
              padding: EdgeInsets.all(2.0),
              child: Row(
                children: [
                  Expanded(
                    child: BottomNavigationBar(
                      items: <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          icon: Icon(
                            Icons.remove_shopping_cart,
                            color: totalPrice > 0 ? HHColors.hhColorFirst : HHColors.hhColorGreyDark
                            ),
                          label: 'Limpar',
                        ),
                        const BottomNavigationBarItem(
                          icon: Icon(Icons.credit_card),
                          label: 'Cartão',
                        ),
                        const BottomNavigationBarItem(
                          icon: Icon(Icons.qr_code),
                          label: 'QR Code',
                        ),
                        const BottomNavigationBarItem(
                          icon: Icon(Icons.pix),
                          label: 'QR Code',
                        ),
                      ],
                      currentIndex: _selectedIndex,
                      selectedItemColor: HHColors.hhColorFirst,
                      unselectedItemColor: HHColors.hhColorGreyDark,
                      onTap: _onItemTapped,
                      backgroundColor: HHColors.hhColorGreyMedium,
                    ),
                  ),
                  SizedBox(width: 4.0),
                  Container(
                    decoration: BoxDecoration(
                      color: HHColors.hhColorFirst,
                      borderRadius: const BorderRadius.all(Radius.circular(10))
                    ),
                    child: GestureDetector(
                      onTap: () {
                        if(totalPrice > 0) {
                          showDialog(
                            useRootNavigator: false,
                            context: context,
                            builder: (BuildContext context) {
                              return PayDialog(basket: HHGlobals.HHBasket.value);
                            },
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: Text(
                          NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(totalPrice),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: HHColors.hhColorWhite),
                        ),
                      ),
                    ),
                  ),
                ]
              )
            ),
          ),
        );
      }
    );
  }
}


/*
  @override
  Widget build(BuildContext context) {
    return Container(
      color: HHColors.hhColorGreyDark,
      child: ValueListenableBuilder<double>(
        valueListenable: HHGlobals.HHBasket.value.totalPriceNotifier,
        builder: (context, totalPrice, child) {
          return Row(
            children: [
              Expanded(
                child: BottomNavigationBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.remove_shopping_cart),
                      label: 'Limpar',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.credit_card),
                      label: 'Cartão',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.qr_code),
                      label: 'QR Code',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: HHColors.hhColorWhite,
                  unselectedItemColor: Colors.grey,
                  onTap: _onItemTapped,
                  backgroundColor: HHColors.hhColorGreyDark,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(totalPrice),
                  style: TextStyle(
                    fontSize: 24, 
                    fontWeight: FontWeight.bold,
                    color: HHColors.hhColorWhite),
                ),
              ),
            ]
          ); 
        }
      ),
    );
  }*/





  /*
  @override
  Widget build(BuildContext context) {
    return Container(
      color: HHColors.hhColorGreyDark,
      child: ValueListenableBuilder<double>(
        valueListenable: HHGlobals.HHBasket.value.totalPriceNotifier,
        builder: (context, totalPrice, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.remove_shopping_cart),
                    label: 'Limpar',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.credit_card),
                    label: 'Cartão',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.qr_code),
                    label: 'QR Code',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: HHColors.hhColorWhite,
                unselectedItemColor: Colors.grey,
                onTap: _onItemTapped,
                backgroundColor: HHColors.hhColorGreyDark,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(totalPrice),
                  style: TextStyle(
                    fontSize: 24, 
                    fontWeight: FontWeight.bold,
                    color: HHColors.hhColorWhite),
                ),
              ),
            ]
          ); 
        }
      ),
    );
  }*/


// Versão 4 - STATEFULWIDGET com area escondida -funcionando 02/06
 /*class PayBar extends StatefulWidget {
  final ValueNotifier<double> totalPriceNotifier;

  PayBar({required this.totalPriceNotifier});

  @override
  State<PayBar> createState() => _PayBarState();
}


class _PayBarState extends State<PayBar> {
  bool isHidden = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: HHColors.hhColorFirst,
      child: ValueListenableBuilder<double>(
        valueListenable: HHGlobals.HHBasket.value.totalPriceNotifier,
        builder: (context, totalPrice, child) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // TOTALIZADOR
              GestureDetector(
                 onVerticalDragUpdate: (DragUpdateDetails details) {
                  if (details.delta.dy < 0) {
                    // arrastando para cima
                    setState(() {
                      isHidden = false;
                    });
                  } else if (details.delta.dy > 0) {
                    // arrastando para baixo
                    setState(() {
                      isHidden = true;
                    });
                  }
                },
                onTap: () {
                  setState(() {
                    isHidden = !isHidden; //IA 16-05-23: Alternar a visibilidade da "ÁREA ESCONDIDA" ao tocar no "TOTALIZADOR"
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    /*Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: HHColors.hhColorWhite),
                      ),*/
                      
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
                              .format(totalPrice),
                        style: TextStyle(
                          fontSize: 24, 
                          fontWeight: FontWeight.bold,
                          color: HHColors.hhColorWhite),
                      ),
                    ),
                  ]
                ),
              ),
              //AREA A SER ESCONDIDA
              if (!isHidden)
              Container(
                color: HHColors.hhColorFirst,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            HHGlobals.HHBasket.value.clearBasket();
                            HHGlobals.HHBasket.notifyListeners();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Icon(
                              Icons.remove_shopping_cart,
                              color: HHGlobals.HHBasket.value.isNotEmpty
                                  ? HHColors.hhColorWhite
                                  : Colors.grey,
                              size: 30,
                            ),
                          ),
                        ),
                        
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return PayByCardTab(totalPrice: totalPrice);
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Icon(
                                Icons.credit_card,
                                color: HHColors.hhColorWhite,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return PayByQRTab(totalPrice: totalPrice);
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Icon(
                              Icons.qr_code,
                              color: HHColors.hhColorWhite,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ); 
        }
      ),
    );
  }
}*/



// versão 5 - IA 
/*class PayBar extends StatefulWidget {
  final ValueNotifier<double> totalPriceNotifier;

  PayBar({required this.totalPriceNotifier});

  @override
  State<PayBar> createState() => _PayBarState();
}

class _PayBarState extends State<PayBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          color: HHColors.hhColorFirst,
          child: ValueListenableBuilder<double>(
            valueListenable: widget.totalPriceNotifier,
            builder: (context, totalPrice, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
                            .format(totalPrice),
                      style: TextStyle(
                        fontSize: 24, 
                        fontWeight: FontWeight.bold,
                        color: HHColors.hhColorWhite),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //Clear BASKET
                      /*IconButton(
                        onPressed: () {
                          HHGlobals.HHBasket.value.clearBasket();
                          HHGlobals.HHBasket.notifyListeners();
                        },
                        icon: Icon(
                          Icons.remove_shopping_cart,
                          color: HHGlobals.HHBasket.value.isNotEmpty
                                ? HHColors.hhColorWhite
                                : Colors.grey,
                          size: 30,
                        ),
                      ),*/
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return PayByCardTab(totalPrice: totalPrice);
                            },
                          );
                        },
                        icon: Icon(
                          Icons.credit_card,
                          color: HHColors.hhColorWhite,
                          size: 30,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return PayByQRTab(totalPrice: totalPrice);
                            },
                          );
                        },
                        icon: Icon(
                          Icons.qr_code,
                          color: HHColors.hhColorWhite,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}*/



//Versao 3 - FUNCIONANDO
/* class PayBar extends StatelessWidget {
  final ValueNotifier<double> totalPriceNotifier;

  PayBar({required this.totalPriceNotifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: HHGlobals.basketModelNotifier.value.totalPriceNotifier,
      builder: (context, totalPrice, child) {
        return Column(
          children: [
            // TOTALIZADOR
            Container(
              color: HHColors.hhColorFirst,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  SizedBox(height: 8),
                  Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: HHColors.hhColorWhite),
                    ),
                  SizedBox(height: 8),
                  Text(
                    NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
                          .format(totalPrice),
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold,
                      color: HHColors.hhColorWhite),
                  ),
                ]
              ),
            ),
            //AREA A SER ESCONDIDA
            Container(
              color: HHColors.hhColorFirst,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          HHGlobals.basketModelNotifier.value.clear();
                          HHGlobals.basketModelNotifier.notifyListeners();
                        },
                        child: Icon(
                          Icons.remove_shopping_cart,
                          color: HHGlobals.basketModelNotifier.value.isNotEmpty
                              ? HHColors.hhColorWhite
                              : Colors.grey,
                          size: 30,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Implemente a funcionalidade de criar uma lista de produtos relacionados aqui.
                        },
                        child: Icon(
                          Icons.list_alt,
                          color: HHColors.hhColorWhite,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return PayByCardTab(totalPrice: totalPrice);
                              },
                            );
                          },
                          child: Icon(
                            Icons.credit_card,
                            color: HHColors.hhColorWhite,
                            size: 30,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return PayByQRTab(totalPrice: totalPrice);
                            },
                          );
                        },
                        child: Icon(
                          Icons.qr_code,
                          color: HHColors.hhColorWhite,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ); 
      }
    );
  }
}*/


// Versao 2
/* class PayBar extends StatelessWidget {
  final ValueNotifier<double> totalPriceNotifier;

  PayBar({required this.totalPriceNotifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: totalPriceNotifier,
      builder: (context, totalPrice, child) {
        return Container(
          color: HHColors.hhColorFirst,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: HHColors.hhColorWhite),
                ),
              SizedBox(height: 8),
              Text(
                NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
                      .format(totalPrice),
                style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.bold,
                  color: HHColors.hhColorWhite),
              ),

              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return PayByCardTab(totalPrice: totalPrice);
                          },
                        );
                      },
                      child: Icon(
                        Icons.credit_card,
                        color: HHColors.hhColorWhite,
                        size: 30,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return PayByQRTab(totalPrice: totalPrice);
                        },
                      );
                    },
                    child: Icon(
                      Icons.qr_code,
                      color: HHColors.hhColorWhite,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}*/


// Versao 1
/*class PayBar extends StatelessWidget {
  final ValueNotifier<double> totalPriceNotifier;

  PayBar({required this.totalPriceNotifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: totalPriceNotifier,
      builder: (context, totalPrice, child) {
        return Container(
          color: Colors.green,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
                      .format(totalPrice),
                //'\$${totalPrice.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              Row( //or Column
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Icon(Icons.credit_card, color: Colors.white, size:30 ),
                  Icon(Icons.qr_code, color: Colors.white, size:30 ),
                  //Icon(Icons.account_balance_wallet_outlined, color: Colors.white, size:30),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}*/
