import 'package:flutter/material.dart';
import 'package:hh_2/src/models/cat_model.dart';
import 'package:hh_2/src/pages/cat/components/cat_3_box.dart';

// v16.5.23 -  CAT3TILE - IA 16-05-23

class Cat3Tile extends StatelessWidget {
  final CatModel cat;
  final VoidCallback onPressed;
  final String selectedCat;
  final bool isVertical;

  Cat3Tile({
    Key? key,
    required this.cat,
    required this.onPressed,
    required this.selectedCat,
    required this.isVertical,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    if (isVertical == false) {
        
      return Row(
        children: [
          Cat3Box(
            cat: cat, 
            onTap: cat.level == 2 ? onPressed : null,
            isSelected: selectedCat == cat.sigla,
            isVertical: isVertical,
          ),
          if (cat.subCats != null && cat.subCats.isNotEmpty)
            ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true, // importante para evitar conflitos de rolagem
              physics: NeverScrollableScrollPhysics(), // importante para evitar conflitos de rolagem
              itemCount: cat.subCats.length,
              itemBuilder: (context, index) {
                return Cat3Tile(
                  onPressed: onPressed,
                  cat: cat.subCats[index], // IA 15-05 - Correção: deve passar cat.subCats[index] e não apenas cat
                  selectedCat: selectedCat,
                  isVertical: isVertical
                );
              },
            ),
        ],
      );
    
    }

    else {
      return Column(
        children: [
          Cat3Box(
            cat: cat, 
            onTap: cat.level == 2 ? onPressed : null,
            isSelected: selectedCat == cat.sigla,
            isVertical: isVertical,
          ),
          if (cat.subCats != null && cat.subCats.isNotEmpty)
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true, // importante para evitar conflitos de rolagem
              physics: NeverScrollableScrollPhysics(), // importante para evitar conflitos de rolagem
              itemCount: cat.subCats.length,
              itemBuilder: (context, index) {
                return Cat3Tile(
                  onPressed: onPressed,
                  cat: cat.subCats[index], // IA 15-05 - Correção: deve passar cat.subCats[index] e não apenas cat
                  selectedCat: selectedCat,
                  isVertical: isVertical
                );
              },
            ),
        ],
      );
    }
  }
}
//FIM CAT3TILE - IA 16-05-23


