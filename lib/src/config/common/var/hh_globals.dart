import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/var/hh_enum.dart';
import 'package:hh_2/src/models/basket_model.dart';
import 'package:hh_2/src/models/cat_model.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:hh_2/src/models/history_model.dart';
import 'package:hh_2/src/models/periodic_model.dart';
import 'package:hh_2/src/models/picture_model.dart';
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

  static ValueNotifier<List<PeriodicModel>> HHPeriodicLists = ValueNotifier([]);

  static ValueNotifier<List<PictureModel>> HHPictureList = ValueNotifier([]);

  static SourceOrigin HHProdOrigin = SourceOrigin.G;

  static File pictureFile = File('');
  
  static Uint8List pictureFileBytes = Uint8List(0);

  //static ValueNotifier<bool> isAIPhotoProcessing = ValueNotifier<bool>(false); // Notifier para AIPhoto

  static Map<Functions, ValueNotifier<bool>> isProcessing = {
    Functions.image: ValueNotifier<bool>(false),
    Functions.periodic: ValueNotifier<bool>(false),
    Functions.history: ValueNotifier<bool>(false),
    Functions.hint: ValueNotifier<bool>(false),
    Functions.book: ValueNotifier<bool>(false),
  };


  /////////////// USER BYPASS
  ///
  static bool userBypass = true;
  static String userLoginByPass = "AA1";
  static String userPasswordByPass = "aa1";



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
