import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hh_2/src/config/common/image/hh_url_image.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/config/common/var/hh_var.dart';
import 'package:hh_2/src/config/db/db_grid.dart';
import 'package:hh_2/src/config/db/db_search.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:hh_2/src/models/search_model.dart';
import 'package:hh_2/src/services/utils.dart';

class HHTextSearch extends StatefulWidget {
  final IconData icon;
  final String label;
  final String hint;
  final bool isSecret;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;
  final bool readOnly;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final double padding;

  const HHTextSearch({
    Key? key,
    required this.icon,
    required this.label,
    this.hint = "",
    this.isSecret = false,
    this.inputFormatters,
    this.initialValue,
    this.readOnly = false,
    this.keyboardType = TextInputType.name,
    this.controller,
    this.padding = 4.0,
  }) : super(key: key);

  @override
  State<HHTextSearch> createState() => _HHTextSearchState();
}

class _HHTextSearchState extends State<HHTextSearch> {
  bool isObscure = false;
  final DBSearch _dbSearch = DBSearch();
  final DBGrid _dbGrid = DBGrid();
  List<EanModel> gridList = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    isObscure = widget.isSecret;
    widget.controller?.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  // Novo SearchChanger
  Future<List<SearchModel>> _onSearchChanged([String? term]) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    String searchText = term ?? widget.controller?.text ?? '';
    print("SEARCH: $searchText");
    if (searchText.trim().isEmpty) {
      return <SearchModel>[];
    }
    Completer<List<SearchModel>> completer = Completer();
    _debounce = Timer(const Duration(milliseconds: 100), () async {
      // Only call the search function if the text box has focus
      if (FocusScope.of(context).hasFocus) {
        print("TERMO 2: ${searchText}");
        //dbSearch.insertTerm(searchText, "");
        List<SearchModel> results = await _dbSearch.searchByAll(searchText);
        completer.complete(results);
      }
    });
    return completer.future;
  }



  /*
  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    String searchText = widget.controller?.text ?? '';
    print("SEARCH: $searchText");
    if (searchText.trim().isEmpty) {
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      // Only call the search function if the text box has focus
      if (FocusScope.of(context).hasFocus) {
        print("TERMO 1: ${widget.controller?.text}");
        dbSearch.searchByAll(widget.controller?.text ?? '');
      }
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.padding),
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
          scrollPadding: EdgeInsets.all(0),
          controller: widget.controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
            prefixIcon: Icon(widget.icon),
            suffixIcon: widget.isSecret
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                    icon: Icon(isObscure ? Icons.visibility : Icons.visibility_off),
                  )
                : null,
            labelText: widget.label,
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
        suggestionsCallback: (term) async {
          if (term.trim().isEmpty) {
            return <SearchModel>[];
          } else {
            print("TERMO 1: $term");
            return await _onSearchChanged(term);
          }
        },
        onSuggestionSelected: (SearchModel suggestion) async {
          widget.controller?.text = suggestion.nome;
          //BOTAR ISSO EM CAT3BAR/TILE/BOX
          
          //gridList = await _dbGrid.getProductsForGridV3(suggestion);
          //gridList = await _dbGrid.getProductsForGridV3(suggestion);
          gridList = await _dbSearch.searchProductV2(suggestion, HHVar.GridLimit);
          HHGlobals.HHGridList.value = gridList;
          
        },
        //ITEMBUILDER
        //v2
        itemBuilder: (context, SearchModel suggestion) {
          String titleText = '';
          Widget leadingWidget;
          TextStyle titleStyle;

          switch (suggestion.searchType) {
            case 'category':
              leadingWidget = Icon(Icons.category);
              titleText = Utils.capitalizeInitials(suggestion.sig2);
              titleStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
              break;
            case 'word':
              leadingWidget = Icon(Icons.lightbulb);
              titleText = Utils.capitalizeInitials(suggestion.w1);
              titleStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
              break;
            case 'brand':
              leadingWidget = Icon(Icons.branding_watermark);
              titleText = Utils.capitalizeInitials(suggestion.marca);
              titleStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
              break;
            case 'product':
              leadingWidget = Container(
                //width: 40,  // ajuste este valor conforme necessário
                //height: 40, // ajuste este valor conforme necessário
                child: HHUrlImage(
                  product: suggestion,
                  onImageDimensions: (width, height) {},
                ),
              );
              titleText = Utils.capitalizeInitials(suggestion.nome);
              titleStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
              break;
            default:
              leadingWidget = Icon(Icons.help_outline);
              titleText = "Desconhecido";
              titleStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w400);
              break;
          }

          return ListTile(
            leading: leadingWidget,
            title: Text(titleText, style: titleStyle),
            //subtitle: Text(suggestion.marca),
          );
        },
      ),
    );
  }
}


        //ITEMBUILDER
        /*v1
        itemBuilder: (context, EanModel suggestion) {
          String titleText = '';
          IconData leadingIcon;
          TextStyle titleStyle;

          switch (suggestion.search) {
            case 'category':
              leadingIcon = Icons.category;
              titleText = Utils.capitalizeInitials(suggestion.sig2);
              titleStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
              break;
            case 'word':
              leadingIcon = Icons.lightbulb;
              titleText = Utils.capitalizeInitials(suggestion.w1);
              titleStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
              break;
            case 'brand':
              leadingIcon = Icons.branding_watermark;
              titleText = Utils.capitalizeInitials(suggestion.marca);
              titleStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
              break;
            case 'product':
              leadingIcon = Icons.shopping_cart;
              titleText = Utils.capitalizeInitials(suggestion.nome);
              titleStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
              break;
            default:
              leadingIcon = Icons.help_outline;
              titleText = "Desconhecido";
              titleStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w400);
              break;
          }

          return ListTile(
            leading: Icon(leadingIcon),
            title: Text(titleText, style: titleStyle),
            //subtitle: Text(suggestion.marca),
          );
        },
        */

        /* v0
        itemBuilder: (context, EanModel suggestion) {
          String titleText = '';
          IconData leadingIcon = Icons.lightbulb; // Default for keyword
          TextStyle titleStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w400);

          // Check if it's a category
          if (suggestion.sig0.isNotEmpty) {
            leadingIcon = Icons.category;
            titleText = Utils.capitalizeInitials(suggestion.sig2);
            titleStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
          }
          // Check if it's a keyword
          else if (suggestion.w1.isNotEmpty) {
            leadingIcon = Icons.lightbulb;
            titleText = Utils.capitalizeInitials(suggestion.w1);
            titleStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
          }
          // Check if it's a product
          else if (suggestion.marca.isNotEmpty) {
            leadingIcon = Icons.branding_watermark;
            titleText = Utils.capitalizeInitials(suggestion.marca);
            titleStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
          }

          // Check if it's a product
          else if (suggestion.nome.isNotEmpty) {
            leadingIcon = Icons.shopping_cart;
            titleText = Utils.capitalizeInitials(suggestion.nome);
            titleStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
          }

          return ListTile(
            leading: Icon(leadingIcon),
            title: Text(titleText, style: titleStyle),
            subtitle: Text(suggestion.marca),
          );
        },
        */



//v1
/*class HHTextSearch extends StatefulWidget {
  final IconData icon;
  final String label;
  final String hint;
  final bool isSecret;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;
  final bool readOnly;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final double padding;

  const HHTextSearch({
    Key? key,
    required this.icon,
    required this.label,
    this.hint = "",
    this.isSecret = false,
    this.inputFormatters,
    this.initialValue,
    this.readOnly = false,
    this.keyboardType = TextInputType.name,
    this.controller,
    this.padding = 4.0,
  }) : super(key: key);

  @override
  State<HHTextSearch> createState() => _HHTextSearchState();
}

class _HHTextSearchState extends State<HHTextSearch> {
  bool isObscure = false;
  final DBSearch dbSearch = DBSearch();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    isObscure= widget.isSecret;
    widget.controller?.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    String searchText = widget.controller?.text ?? '';
    if (searchText.trim().isEmpty) {
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 50), () {
      // Only call the search function if the text box has focus
      if (FocusScope.of(context).hasFocus) {
        dbSearch.searchByAll(widget.controller?.text ?? '');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.padding),
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
          scrollPadding: EdgeInsets.all(0),
          controller: widget.controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
            prefixIcon: Icon(widget.icon),
            suffixIcon: widget.isSecret 
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                }, 
                icon:  Icon(isObscure? Icons.visibility : Icons.visibility_off)
              ) : null,
            labelText: widget.label,
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
        suggestionsCallback: (term) async {
          if (term.trim().isEmpty) {
            return <EanModel>[];
          } else {
            return await dbSearch.searchByAll(term);
          }
        },
        itemBuilder: (context, EanModel suggestion) {
          return ListTile(
            title: Text(Utils.capitalizeInitials(suggestion.nome)),
            subtitle: Text(suggestion.marca),
          );
        },
        onSuggestionSelected: (EanModel suggestion) {
          widget.controller?.text = suggestion.nome;
        },
      ),
    );
  }
}
*/


//V0
/*
class HHTextSearch extends StatefulWidget {
  final IconData icon;
  final String label;
  final String hint;
  final bool isSecret;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;
  final bool readOnly;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final double padding;
  //final DBSearch dbSearch;

  const HHTextSearch({
    Key? key,
    required this.icon,
    required this.label,
    this.hint = "", 
    this.isSecret = false,
    this.inputFormatters,
    this.initialValue,
    this.readOnly = false,
    this.keyboardType = TextInputType.name,
    this.controller,
    this.padding = 4.0,
    //this.dbSearch,
  }) : super(key: key);

  @override
  State<HHTextSearch> createState() => _HHTextSearchState();
}

class _HHTextSearchState extends State<HHTextSearch> {
  bool isObscure = false;
  final DBSearch dbSearch = DBSearch();

  @override
  void initState(){
    super.initState();
    isObscure= widget.isSecret;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.padding),
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
          scrollPadding: EdgeInsets.all(0),
          //readOnly: widget.readOnly,
          controller: widget.controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
            prefixIcon: Icon(widget.icon),
            suffixIcon: widget.isSecret 
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                }, 
                icon:  Icon(isObscure? Icons.visibility : Icons.visibility_off)
              ) : null,
            labelText: widget.label,
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
        suggestionsCallback: (term) async {
          return await dbSearch.search(term);
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion['prod_name']),
            subtitle: Text(suggestion['prod_brand']),
          );
        },
        onSuggestionSelected: (suggestion) {
          widget.controller?.text = suggestion['prod_name'];
        },
      ),
    );
  }
}
*/