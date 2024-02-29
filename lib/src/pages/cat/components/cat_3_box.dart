import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/models/cat_model.dart';


// v7 - INICIO CAT3BOX - IA 15-05
class Cat3Box extends StatefulWidget {
  final CatModel cat;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool isVertical;

  Cat3Box({Key? key, 
    required this.cat, 
    this.onTap, 
    required this.isSelected,
    required this.isVertical,
    }) : super(key: key);

  @override
  _Cat3BoxState createState() => _Cat3BoxState();
}

class _Cat3BoxState extends State<Cat3Box> {
  //bool _isOpen = true;


  @override
  Widget build(BuildContext context) {
    Widget tile = Container();
    switch (widget.cat.level) {
      case 0: // CAT0
        widget.isVertical? 
          tile = Container(
            padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
            decoration: BoxDecoration(
              color: widget.cat.level<2?  widget.cat.color: Colors.transparent,
              borderRadius: BorderRadius.circular(5),),
            child: Row(
              children: [
                Text(
                  widget.cat.nom, 
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                  ),
              ],
            ),
          ): Container();
          break;
      case 1: // CAT1
        widget.isVertical? 
          tile = Container(
            padding: EdgeInsets.fromLTRB(15, 2, 2, 2),
            decoration: BoxDecoration(
              color: widget.cat.level<2?  widget.cat.color: Colors.transparent,
              borderRadius: BorderRadius.circular(5),),
            child: Row(
              children: [
                Text(
                  widget.cat.nom, 
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
                  ),
              ],
                  ),
          ): Container();
        break;
      default: // CAT2
        tile = Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: widget.cat.level<2?  widget.cat.color: Colors.transparent,
              borderRadius: BorderRadius.circular(5),
              border: widget.isSelected ? 
                Border.all(color: HHColors.hhColorFirst, width: 2.0) : 
                Border.all(color: HHColors.hhColorWhite, width: 1.0), // IA 15-05 - Adicionar borda verde se estiver selecionado
              ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.cat.emj, style: TextStyle(fontSize: widget.isVertical? 15: 20,)), //, style: TextStyle(fontSize: 50)),
                SizedBox(width: 2),
                //Expanded(child: Text(widget.cat.nom)),
                widget.isVertical?
                Expanded(
                  child: Text(widget.cat.nom, 
                    style: TextStyle(
                      fontSize: widget.isVertical? 15: 20, 
                      fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal)),
                  ):
                  Text(widget.cat.nom, 
                    style: TextStyle(
                      fontSize: widget.isVertical? 15: 20, 
                      fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal)
                    ), // IA 15-05 - Aplicar negrito se estiver selecionado
              ],
            ),
          );
        break;
    }
    return GestureDetector(
      onTap: () {
        if (widget.cat.level < 2) {
          /*setState(() {
            _isOpen = !_isOpen;
          });*/
        } else {
          // IA 13-05 - Chamar onTap quando um item de nível 2 é pressionado.
          //widget.onTap();
          HHGlobals.selectedCat = widget.cat.sigla!;
          widget.onTap?.call();
          print('Cat3Box: ${widget.cat.sigla}'); // IA 13-05  
        }
      },
      child: 
        Container(
         
        child: tile, //_isOpen ? tile : null,
      ),
    );
  }
}
//FIM CAT3BOX - IA 15-05



