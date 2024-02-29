import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';


//import '/assets/lists/uf_list.dart';
//import 'packag/src/config/common/hh_2/assets/lists/uf_list.dart';

class HHUFDropDown extends StatefulWidget {
  const HHUFDropDown({Key? key, required this.onUFChanged, required this.controller}) : super(key: key);

  final VoidCallback onUFChanged;
  final TextEditingController controller;

  @override
  State<HHUFDropDown> createState() => _HHUFDropDownState();
}

List<String> ufList = 
       ["AC","AL","AM","AP","BA",
        "CE","DF","ES","GO","MG",
        "MS","MT","PA","PB","PE",
        "PI","PR","RJ","RN","RO",
        "RR","RS","SC","SE","SP","TO"];

class _HHUFDropDownState extends State<HHUFDropDown> {


  //String dropdownValue = HHGlobals.HHUser.uf == ''? HHGlobals.HHUser.uf: ufList.first;
  String dropdownValue = HHGlobals.HHUser.uf.isEmpty ? ufList.first : HHGlobals.HHUser.uf;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        child: DecoratedBox(
          decoration: BoxDecoration( 
            color:Colors.transparent, 
            border: Border.all(color: Colors.black38, width: 1), 
            borderRadius: BorderRadius.circular(18), 
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: DropdownButton<String>(
              value: dropdownValue, 
              isExpanded: true,
              autofocus: true,
              focusColor: Colors.transparent,
              elevation: 0,
              style: TextStyle(
                color: HHColors.hhColorFirst,
                fontWeight: FontWeight.bold,
                ),
              borderRadius: BorderRadius.circular(18),
              alignment: Alignment.center,
              underline: Container(
                height: 0,
                color: HHColors.hhColorGreyMedium,
              ),
              onChanged: (String? value) {
                setState(() {
                  dropdownValue = value!;
                  //HHGlobals.HHUser.uf = value;
                  widget.controller.text = value;
                  //HHGlobals.uf = value; // Não sei onde HHGlobals.uf é definido, então comentei
                });
                widget.onUFChanged();
              },
              items: ufList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}


/*class HHUFDropDown extends StatefulWidget {
  const HHUFDropDown({Key? key, required this.onUFChanged}) : super(key: key);

  final VoidCallback onUFChanged;

  @override
  State<HHUFDropDown> createState() => _HHUFDropDownState();
}

List<String> ufList = 
       ["AC","AL","AM","AP","BA",
        "CE","DF","ES","GO","MG",
        "MS","MT","PA","PB","PE",
        "PI","PR","RJ","RN","RO",
        "RR","RS","SC","SE","SP","TO"];

class _HHUFDropDownState extends State<HHUFDropDown> {

  String dropdownValue = ufList.first;

  @override
  Widget build(BuildContext context) {
    //https://stackoverflow.com/questions/61391005/flutter-dropdown-align-selected-item-and-hint-text
    
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        child: DecoratedBox(
          decoration: BoxDecoration( 
            color:Colors.transparent, 
            border: Border.all(color: Colors.black38, width: 1), 
            borderRadius: BorderRadius.circular(18), 
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            
            child: DropdownButton<String>(
              value: HHGlobals.HHUser.uf,
              isExpanded: true,
              autofocus: true,
              focusColor: Colors.transparent,
              //icon: const Icon(Icons.arrow_downward),
              //iconSize: 16,
              elevation: 0,
              style: TextStyle(
                color: HHColors.hhColorFirst,
                fontWeight: FontWeight.bold,
                ),
              borderRadius: BorderRadius.circular(18),
              alignment: Alignment.center,
              underline: Container(
                height: 0,
                color: HHColors.hhColorGreyMedium,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdownValue = value!;
                  HHGlobals.HHUser.uf = value;
                });
                widget.onUFChanged(); // Adicione esta linha
              },
              items: ufList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}*/

