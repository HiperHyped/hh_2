import 'package:flutter/material.dart';
import 'package:hh_2/src/models/basket_model.dart';
import 'package:hh_2/src/models/cat_model.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:hh_2/src/models/history_model.dart';
import 'package:hh_2/src/models/suggestion_model.dart';
import 'package:hh_2/src/models/user_model.dart';


abstract class HHGlobals{

  //static String uf = "SP";
  
  static String selectedCat = "BBEAG";

  static bool changeCat = false;

  static EanModel selectedProduct = EanModel();

  static ValueNotifier<BasketModel> HHBasket = ValueNotifier(BasketModel());

  static UserModel HHUser = UserModel(password: "", login: "");

  static List<CatModel> listCat = [] as List<CatModel>;

  static List<EanModel> listProduct = [] as List<EanModel>;

  static ValueNotifier<List<EanModel>> HHGridList = ValueNotifier([]);

  static ValueNotifier<List<SuggestionModel>> HHSuggestionList = ValueNotifier([]);

  static ValueNotifier<HistoryModel> HHUserHistory = ValueNotifier(HistoryModel());

  static ValueNotifier<List<SuggestionModel>> HHUserBook = ValueNotifier([]);

  static SourceOrigin HHProdOrigin = SourceOrigin.G;



}



  //static List<CategoryModel> listCategory = [] as List<CategoryModel>;
  //static BasketModel basketModel = BasketModel();
  //static ValueNotifier<BasketModel> basketModelNotifier = ValueNotifier([] as BasketModel);


  //CategoryModel
  /*static CategoryModel category = 
          CategoryModel(
            "BEBIDAS", 
            "BEBIDAS ALCOOLICAS", 
            "CERVEJA GARRAFA", 
            "BEBIDAS ALCOOLICAS / CERVEJA GARRAFA", 
            "B", 
            "BA", 
            "CG", 
            "BBACG");*/
