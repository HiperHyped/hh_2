import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:hh_2/src/models/price_model.dart';

/*
class ProductModel {
  EanModel ean;
  CategoryModel cat;
  List<PriceModel> listPrices;
  List<StockModel> listStock;

  ProductModel(
    this.ean,
    this.cat,
    this.listPrices,
    this.listStock,
  );

 /* getCategory(String sigla){

    cat = HHGlobals.listCategory.firstWhere((element) =>
      element.sigla == sigla
    );
  }*/

  getEan(String codean){

    ean = HHGlobals.listProduct.firstWhere((element) =>
      element.ean == codean
    );
  }

  getPrices(String sigla, String uf){

  }

}*/