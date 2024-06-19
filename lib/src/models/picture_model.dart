import 'dart:typed_data';
import 'package:hh_2/src/models/basket_model.dart';
import 'package:hh_2/src/models/search_model.dart';

class PictureModel {
  BasketModel basket;
  List<SearchModel> searchProductList;
  Uint8List image;
  Uint8List imageRedux;
  String threadId;
  String runId;

  PictureModel({
    required this.basket,
    required this.searchProductList,
    required this.image,
    required this.imageRedux,
    required this.threadId,
    required this.runId,
  });

  @override
  String toString() {
    return 'PictureModel('
        'basket: $basket, '
        'searchProductList: $searchProductList, '
        'image: ${image.lengthInBytes} bytes, '
        'imageRedux: ${imageRedux.lengthInBytes} bytes, '
        'threadId: $threadId, '
        'runId: $runId'
        ')';
  }
}
