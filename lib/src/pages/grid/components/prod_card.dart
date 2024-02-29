import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/components/hh_3_buttons.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/models/basket_model.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:hh_2/src/services/utils.dart';
import 'package:intl/intl.dart';

import '../../../config/common/image/hh_url_image.dart';

class ProdCard extends StatelessWidget {
  final EanModel product;
  final SourceOrigin sourceOrigin;

  ProdCard({Key? key, required this.product, required this.sourceOrigin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 500), // Altura máxima definida
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: HHColors.hhColorFirst,
              width: 4,
            ),
          ),
          child: FittedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Imagem maior do produto
                Container(
                  child: 
                    HHUrlImage(
                      product: product,
                      onImageDimensions: (double width, double height) {},
                    ),
                    /*Image.asset(
                    "assets/images/db/${product.imagem}",
                    fit: BoxFit.fitWidth,
                  ),*/
                ),
                SizedBox(height: 8),
                // Nome do produto
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 250),  // Defina a largura máxima de acordo com suas necessidades
                  child: Text(
                    Utils.capitalizeInitials(product.nome),
                    textAlign: TextAlign.center,
                    maxLines: 3,  
                    overflow: TextOverflow.ellipsis,  
                    style: TextStyle(
                        fontSize: 20,  // tamanho constante
                        fontWeight: FontWeight.bold,
                        color: HHColors.hhColorFirst),
                  ),
                ),
                /*FittedBox(
                  fit: BoxFit.scaleDown,
                  child: AutoSizeText(
                    Utils.capitalizeInitials(product.nome),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: HHColors.hhColorFirst),
                  ),
                ),*/
                /*Text(
                  UtilsServices.capitalizeInitials(product.nome),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: HHColors.hhColorFirst),
                ),*/
                SizedBox(height: 8),
                // Marca
                SelectableText(
                  product.marca,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: HHColors.hhColorFirst),
                ),
                SizedBox(height: 8),
                // Preço em R$
                Text(
                  /*NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
                      .format(double.parse(product.preco)),*/
                  NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
                  .format(double.tryParse(product.preco) ?? 0),

                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: HHColors.hhColorFirst),
                ),
                SizedBox(height: 4),
                Center(
                  child: HH3Buttons(
                    product: product,
                    sourceOrigin: sourceOrigin,
                    column: false,
                    iconSize: 30,
                    spaceBetweenIcons: 10.0,
                  ),
                ),
                //SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}


/*class ProdCard extends StatelessWidget {
  final EanModel product;

  ProdCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Dialog(
        //backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.05,
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: HHColors.hhColorFirst,
                width: 4,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Imagem maior do produto
                Container(
                  child: Image.asset(
                    "assets/images/db/${product.imagem}",
                    fit: BoxFit.fitWidth,
                  ),
                ),
                SizedBox(height: 8),
                // Nome do produto
                Text(
                  UtilsServices.capitalizeInitials(product.nome),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold, 
                    color: HHColors.hhColorFirst),
                ),
                SizedBox(height: 4),
                // Marca
                Text(
                  product.marca,
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 20,
                    color: HHColors.hhColorFirst),
                ),
                //SizedBox(height: 4),
                // Preço em R$
                Text(
                  //UtilsServices.capitalizeInitials("R\$ ${product.preco}"),
                  NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(double.parse(product.preco)),
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 26,
                    color: HHColors.hhColorFirst),
                ),
                
                Expanded(
                  child: HHButtons(
                    product: product,
                    column: false,    
                    iconSize: 30,
                    spaceBetweenIcons: 10.0,  
                  ),
                ),
                //SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}*/



                /*Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Botão para incluir na lista de compras
                    IconButton(
                      onPressed: () {
                        // Implementar ação para incluir na lista de compras
                        //HHGlobals.basketModel.addProduct(product);
                        HHGlobals.basketModelNotifier.value.addProduct(product);
                        HHGlobals.basketModelNotifier.notifyListeners();
                      },
                      icon: Icon(Icons.shopping_cart_outlined, color: HHColors.hhColorFirst, size: 30,),
                    ),
                    // Botão para remover do GridTab
                    IconButton(
                      onPressed: () {
                        // Implementar ação para remover do GridTab
                        HHGlobals.basketModelNotifier.value.removeProduct(product);
                        HHGlobals.basketModelNotifier.notifyListeners();
                      },
                      icon: Icon(Icons.delete_outline, color: HHColors.hhColorFirst, size: 30,),
                    ),
                  ],
                ),*/