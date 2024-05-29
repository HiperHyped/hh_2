import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/models/basket_model.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:hh_2/src/pages/grid/components/prod_card.dart';
import 'package:hh_2/src/pages/periodic/periodic_dialog.dart';


class HH4Buttons extends StatelessWidget {
  final EanModel product;
  final bool column;
  final double iconSize;
  final double spaceBetweenIcons;
  final SourceOrigin sourceOrigin;

  HH4Buttons({
    required this.product,
    this.column = true,
    this.iconSize = 18,
    this.spaceBetweenIcons = 2.0,
    required this.sourceOrigin
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HHGlobals.HHBasket,
      builder: (BuildContext context, BasketModel basket, Widget? child) {
        bool productInBasket = basket.containsProduct(product);
        return Align(
          alignment: Alignment.topLeft,
          child: column ? _buildColumn(context, productInBasket) : _buildRow(context, productInBasket),
        );
      }
    );
  }

  Widget _buildColumn(BuildContext context, bool productInBasket) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: _buildButtons(context: context, column: true, productInBasket: productInBasket),
    );
  }

  Widget _buildRow(BuildContext context, bool productInBasket) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _buildButtons(context: context, column: false, productInBasket: productInBasket),
    );
  }

  List<Widget> _buildButtons({required bool column, required BuildContext context, required bool productInBasket}) {
    return [
      _buildButton(
        context: context,
        icon: Icons.add_circle_outline,
        color: Colors.green,
        onTap: () {
          HHGlobals.HHBasket.value.addProduct(product, sourceOrigin);
          HHGlobals.HHBasket.notifyListeners();
        },
      ),
      column ? SizedBox.shrink() : SizedBox(width: spaceBetweenIcons),
      _buildButton(
        context: context,
        icon: Icons.remove_circle_outline,
        color: productInBasket ? Colors.orange : Colors.grey,
        onTap: productInBasket ? () {
          HHGlobals.HHBasket.value.removeProduct(product);
          HHGlobals.HHBasket.notifyListeners();
        } : null,
      ),
      column ? SizedBox.shrink() : SizedBox(width: spaceBetweenIcons),
      _buildButton(
        context: context,
        icon: Icons.cancel_outlined,
        color: productInBasket ? Colors.purple : Colors.grey,
        onTap: productInBasket ? () {
          HHGlobals.HHBasket.value.removeAllOfProduct(product);
          HHGlobals.HHBasket.notifyListeners();
          Navigator.pop(context);
        } : null,
      ),
      column ? SizedBox.shrink() : SizedBox(width: spaceBetweenIcons),
      _buildButton(
        context: context,
        icon: Icons.history,
        color: Colors.brown,
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return PeriodicDialog(product: product);
            },
          );
        },
      ),
    ];
  }

  Widget _buildButton({
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
    required BuildContext context,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: spaceBetweenIcons),
        height: iconSize,
        width: iconSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: Icon(icon, size: iconSize, color: Colors.white),
      ),
    );
  }
}
