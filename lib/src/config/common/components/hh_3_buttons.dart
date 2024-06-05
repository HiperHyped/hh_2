import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/models/basket_model.dart';
import 'package:hh_2/src/models/ean_model.dart';
//import 'package:hh_2/src/pages/grid/components/prod_card.dart';

class HH3Buttons extends StatelessWidget {
  final EanModel product;
  final bool column;
  final double iconSize;
  final double spaceBetweenIcons;
  final SourceOrigin sourceOrigin;

  HH3Buttons({
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
      column? SizedBox.shrink() : SizedBox(width: spaceBetweenIcons), 
      _buildButton(
        context: context,
        icon: Icons.remove_circle_outline,
        color: productInBasket ? Colors.orange : Colors.grey,
        onTap: productInBasket ? () {
          HHGlobals.HHBasket.value.removeProduct(product);
          HHGlobals.HHBasket.notifyListeners();
        } : null,
      ),
      column? SizedBox.shrink() : SizedBox(width: spaceBetweenIcons), 
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



// Versao 2
/*class HHButtons extends StatelessWidget {
  final EanModel product;
  final bool column;
  final double iconSize;
  final double spaceBetweenIcons;

  HHButtons({
    required this.product,
    this.column = true,
    this.iconSize = 18,
    this.spaceBetweenIcons = 2.0,
    });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: column ? _buildColumn(context) : _buildRow(context),
    );
  }

  Widget _buildColumn(BuildContext context) {
    return Column(
      
      mainAxisSize: MainAxisSize.min,
      children: _buildButtons(context: context, column: true),
    );
  }

  Widget _buildRow(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _buildButtons(context: context, column: false),
    );
  }

  

  List<Widget> _buildButtons({required bool column, required BuildContext context}) {
    return [
      _buildButton(
        context: context,
        icon: Icons.add_circle_outline,
        color: Colors.green,
        onTap: () {
          HHGlobals.basketModelNotifier.value
              .increaseProductQuantity(product);
          HHGlobals.basketModelNotifier.notifyListeners();
        },
      ),
      column? SizedBox.shrink() : SizedBox(width: spaceBetweenIcons), 
      _buildButton(
        context: context,
        icon: Icons.remove_circle_outline,
        color: Colors.orange,
        onTap: () {
          HHGlobals.basketModelNotifier.value
              .decreaseProductQuantity(product);
          HHGlobals.basketModelNotifier.notifyListeners();
        },
      ),
      column? SizedBox.shrink() : SizedBox(width: spaceBetweenIcons), 
      _buildButton(
        context: context,
        icon: Icons.cancel_outlined,
        color: Colors.purple,
        onTap: () {
          HHGlobals.basketModelNotifier.value
              .removeAllOfProduct(product);
          HHGlobals.basketModelNotifier.notifyListeners();
        },
      ),
      /*column?  
      _buildButton(
        context: context,
        icon: Icons.info_outlined,
        color: Colors.blue,
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return ProdCard(product: product);
              },
            );
        },
      )
      : SizedBox(width: spaceBetweenIcons), //Cuidado com essa função (botoes verticais ou horizontais) - pode dar erro*/
    ];
  }


  Widget _buildButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
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
}*/

// Versao 1
/*class HHButtons extends StatelessWidget {
  final EanModel product;

  HHButtons({required this.product});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            icon: Icons.add_circle_outline,
            color: Colors.green,
            onTap: () {
              HHGlobals.basketModelNotifier.value
                  .increaseProductQuantity(product);
              HHGlobals.basketModelNotifier.notifyListeners();
            },
          ),
          _buildButton(
            icon: Icons.remove_circle_outline,
            color: Colors.orange,
            onTap: () {
              HHGlobals.basketModelNotifier.value
                  .decreaseProductQuantity(product);
              HHGlobals.basketModelNotifier.notifyListeners();
            },
          ),
          _buildButton(
            icon: Icons.cancel_outlined,
            color: Colors.purple,
            onTap: () {
              HHGlobals.basketModelNotifier.value
                  .removeAllOfProduct(product);
              HHGlobals.basketModelNotifier.notifyListeners();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 1.0),
        height: 20,
        width: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: Icon(icon, size: 18, color: Colors.white),
      ),
    );
  }
}*/
