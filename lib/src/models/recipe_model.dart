import 'package:hh_2/src/models/ean_model.dart';

class RecipeModel {
  String recipeName;
  String catRecipe;
  String subCatRecipe;
  List<EanModel> ingredients;
  List<String> description;

  RecipeModel({
    this.recipeName = '',
    List<EanModel>? ingredients,
    List<String>? description,
    this.catRecipe = '',
    this.subCatRecipe = '',
  })  : this.ingredients = ingredients ?? [],
        this.description = description ?? [];

  @override
  String toString() {
    return 'RecipeModel{'
      'recipe: $recipeName, '
      'ingredients: ${_listToString(ingredients)}, '
      'description: ${_listToString(description)}, '
      'category: $catRecipe, '
      'subcategory: $subCatRecipe, '
    '}';
  }
}

  String _listToString(List list) {
    return list.map((item) => item.toString()).join(', ');
  }
