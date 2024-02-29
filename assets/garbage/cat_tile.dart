import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/config/common/image/hh_url_cat_image.dart';
import 'category_model.dart';
import 'package:hh_2/src/services/utils.dart';
import 'package:auto_size_text/auto_size_text.dart';

/*
class CatTile extends StatelessWidget {
  const CatTile({
    Key? key,
    required this.category,
    required this.isSelected,
    required this.onPressed,
    required this.vertical,

  }) : super(key: key);

  final CategoryModel category;
  final bool isSelected;
  final VoidCallback onPressed;
  final bool vertical;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            vertical
                ? Container(
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? HHColors.hhColorFirst : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: 
                      HHUrlCatImage(
                        cat: category,
                        onImageDimensions: (double width, double height) {},
                      )
                      /*Image.asset(
                        "assets/images/cat/CAT_${category.sigla}.png",
                        fit: BoxFit.contain,
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                          // Retorne um Container vazio ou um widget específico, como um ícone, quando a imagem não estiver disponível
                          return Container(); // Você também pode usar "const SizedBox()" para retornar um espaço vazio
                        },
                      ),*/
                  )
                : Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? HHColors.hhColorFirst : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: 
                        HHUrlCatImage(
                          cat: category,
                          onImageDimensions: (double width, double height) {},
                        )
                        /*Image.asset(
                          "assets/images/cat/CAT_${category.sigla}.png",
                          fit: BoxFit.contain,
                        ),*/
                    ),
                  ),
            SizedBox(height: 2.0),
            
            AutoSizeText(
              Utils.capitalizeInitials(category.cat2.split(' ').join('\n')),
              //category.cat2,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: HHColors.hhColorFirst,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              maxLines: 1, // Limita o número de linhas (opcional)
              minFontSize: 16, // Define o tamanho mínimo da fonte (opcional)
              maxFontSize: 16, // Define o tamanho máximo da fonte (opcional)
            ),
          ],
        ),
      ),
    );
  }
}*/
      
      /*child: ListTile(
        title: Container(
          //width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                    color: isSelected? HHColors.hhColorFirst: Colors.transparent,
                    width: 2,
            ),
          ),
          //color: HHColors.hhColorGreyLight,
          child: Image.asset("assets/images/cat/CAT_${category.sigla}.png",
            //width: _catwidth,
            ),
        ),
        subtitle: Text(
            category.cat2,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: HHColors.hhColorFirst,
              fontWeight: isSelected? FontWeight.bold: FontWeight.normal,
              ),
            ),
        //title: Text(categories[index].cat1),
        //subtitle: Text(categories[index].cat2),
        //trailing: Text(categories2[index].sigla),
        //trailing: Image.asset("assets/images/cat/CAT_${categories2[index].sigla}.png"),
        //isThreeLine: true,
      ),*/

      /*child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 80 ,
              //width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? HHColors.hhColorFirst : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Image.asset("assets/images/cat/CAT_${category.sigla}.png"),
            ),
            const SizedBox(height: 8.0, width:18.0),
              /*Text(
                category.cat2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: HHColors.hhColorFirst,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),*/
          ],
        ),*/

      /*child: Container(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? HHColors.hhColorFirst : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Image.asset(
                "assets/images/cat/CAT_${category.sigla}.png",
                fit: BoxFit.contain,
              ),
            ),
            //SizedBox(height: 8.0),
            Text(
              category.cat2,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: HHColors.hhColorFirst,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),*/

      