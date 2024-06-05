import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/components/hh_icon_button.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/config/common/var/hh_notifiers.dart';
import 'package:hh_2/src/config/common/var/hh_var.dart';
import 'package:hh_2/src/models/basket_model.dart';
import 'package:hh_2/src/models/periodic_model.dart';
import 'package:hh_2/src/models/ean_model.dart';
//import 'package:hh_2/src/pages/basket/basket_tile.dart';
import 'package:hh_2/src/pages/periodic/periodic_tile.dart';

class PeriodicCard extends StatefulWidget {
  final PeriodicModel periodic;
  final int count;
  final bool isExpanded;
  final bool isShrunk;
  final VoidCallback onTap;
  final SourceOrigin sourceOrigin = SourceOrigin.P;

  PeriodicCard({
    required this.periodic,
    required this.count,
    required this.onTap,
    this.isShrunk = false,
    this.isExpanded = false,
  });

  @override
  _PeriodicCardState createState() => _PeriodicCardState();
}

class _PeriodicCardState extends State<PeriodicCard> {
  void loadPeriodicDetails() async {
    setState(() {});
  }

  Widget buildTextColumn() {
    String periodTypeText;
    switch (widget.periodic.periodType) {
      case PeriodType.S:
        periodTypeText = 'Semanal';
        break;
      case PeriodType.Q:
        periodTypeText = 'Quinzenal';
        break;
      case PeriodType.M:
        periodTypeText = 'Mensal';
        break;
    }

    String periodDetail;
    if (widget.periodic.periodType == PeriodType.M) {
      periodDetail = 'Dia ${widget.periodic.monthlyDay}';
    } else {
      periodDetail = widget.periodic.weeklyDays
          .split('')
          .asMap()
          .entries
          .where((entry) => entry.value == '1')
          .map((entry) {
        switch (entry.key) {
          case 0:
            return 'Seg';
          case 1:
            return 'Ter';
          case 2:
            return 'Qua';
          case 3:
            return 'Qui';
          case 4:
            return 'Sex';
          default:
            return '';
        }
      }).join(', ');
    }

    return Container(
      width: HHVar.sugWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.periodic.listName,
            style: TextStyle(color: Colors.white),
          ),
          Text(
            periodTypeText,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            periodDetail,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            "${widget.periodic.basketList.length} Produtos",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: widget.isExpanded
            ? MediaQuery.of(context).size.width - 8
            : (widget.isShrunk ? HHVar.sugShrink : HHVar.sugWidth),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.brown,
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: widget.isExpanded
              ? Row(
                  children: [
                    buildTextColumn(),
                    Expanded(
                      child: widget.isExpanded
                          ? Row(
                              children: [
                                Container(
                                  color: HHColors.hhColorGreyLight,
                                  padding: EdgeInsets.symmetric(horizontal: 2),
                                  width: 25,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: HHIconButton(
                                          iconColor: widget.periodic.basketList.any((basket) => basket.cartLastPressed == 1)
                                              ? HHColors.hhColorDarkFirst
                                              : HHColors.hhColorGreyDark,
                                          icon: Icons.shopping_cart_outlined,
                                          onPressed: () {
                                            HHGlobals.HHBasket.value.addProductList(
                                                widget.periodic.basketList.expand((basket) => basket.products).toList(), 
                                                widget.sourceOrigin
                                            );
                                            HHNotifiers.counter[CounterType.BasketCount]!.value =
                                                HHGlobals.HHBasket.value.groupProducts().length;
                                            setState(() {
                                              widget.periodic.basketList.forEach((basket) => basket.cartLastPressed = 1);
                                            });
                                          },
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: HHIconButton(
                                          iconColor: widget.periodic.basketList.any((basket) => basket.cartLastPressed == 0)
                                              ? HHColors.hhColorBack
                                              : HHColors.hhColorGreyDark,
                                          icon: Icons.remove_shopping_cart_outlined,
                                          onPressed: () {
                                            HHGlobals.HHBasket.value.removeAllOfProductList(
                                                widget.periodic.basketList.expand((basket) => basket.products).toList()
                                            );
                                            HHNotifiers.counter[CounterType.BasketCount]!.value =
                                                HHGlobals.HHBasket.value.groupProducts().length;
                                            setState(() {
                                              widget.periodic.basketList.forEach((basket) => basket.cartLastPressed = 0);
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: HHColors.hhColorGreyLight,
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: widget.periodic.basketList.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        BasketModel basket = widget.periodic.basketList[index];
                                        return Row(
                                          children: basket.productQuantities.entries.map((entry) {
                                            EanModel product = entry.key;
                                            int quantity = entry.value;
                                            return PeriodicTile(product: product, count: quantity);
                                          }).toList(),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                    ),
                  ],
                )
              : Container(
                  width: widget.isShrunk ? HHVar.sugShrink : HHVar.sugWidth,
                  child: widget.isShrunk
                      ? Text("${widget.count}", style: const TextStyle(color: Colors.white))
                      : buildTextColumn(),
                ),
        ),
      ),
    );
  }
}
