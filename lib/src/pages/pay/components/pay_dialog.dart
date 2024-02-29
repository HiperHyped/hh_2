import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/models/basket_model.dart';
import 'package:intl/intl.dart';

class PayDialog extends StatelessWidget {
  final BasketModel basket;

  PayDialog({required this.basket});

  @override
  Widget build(BuildContext context) {
    var formatCurrency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return GestureDetector(
          onDoubleTap: () {
            Navigator.of(context).pop();
          },
          child: AlertDialog(
            backgroundColor: HHColors.hhColorGreyLight,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: HHColors.hhColorDarkFirst, 
                style: BorderStyle.solid,
                width: 4.0,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            contentPadding: const EdgeInsets.all(8.0),
            title: Text(
              'Total da Compra',
              textAlign: TextAlign.center, // centralizado
              style: TextStyle(color: HHColors.hhColorDarkFirst), // cor verde
            ),
            content: Container(
              width: constraints.maxWidth * 0.9, // 90% da largura disponível
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Table(
                      columnWidths: {
                        0: FlexColumnWidth(0.5), // Quantidade
                        1: FlexColumnWidth(2), // Nome
                        2: FlexColumnWidth(1), // Preço Unit.
                        3: FlexColumnWidth(1), // Subtotal
                      },
                      children: [
                        TableRow(children: [
                          Padding(padding: const EdgeInsets.all(2.0), child: Text('#', style: TextStyle(fontSize: 15))),
                          Padding(padding: const EdgeInsets.all(2.0), child: Text('Nome', style: TextStyle(fontSize: 15))),
                          Padding(padding: const EdgeInsets.all(2.0), child: Text('Unitário', style: TextStyle(fontSize: 15))),
                          Padding(padding: const EdgeInsets.all(2.0), child: Text('Subtotal', style: TextStyle(fontSize: 15))),
                        ]),
                        ...basket.productQuantities.keys.map((product) {
                          return TableRow(children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text('${basket.productQuantities[product]}', style: TextStyle(fontSize: 15)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Wrap(children: [Text(product.nome, style: TextStyle(fontSize: 15))]), // Wrap para evitar quebra de linha no meio das palavras
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(formatCurrency.format(double.parse(product.preco)), style: TextStyle(fontSize: 15), softWrap: false, overflow: TextOverflow.fade),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(formatCurrency.format(double.parse(product.preco) * basket.productQuantities[product]!), style: TextStyle(fontSize: 15), softWrap: false, overflow: TextOverflow.fade),
                            ),
                          ]);
                        }).toList(),
                      ],
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          formatCurrency.format(basket.totalPriceNotifier.value),
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: HHColors.hhColorDarkFirst), // fonte maior e em negrito
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            /*actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],*/
          ),
        );
      },
    );
  }
}

