import 'package:hh_2/src/models/dimension_model.dart';

class HHDimensions {
  // Armazena as dimensões do perfil do usuário
  static List<DimensionModel> userDimensions = List.from(HHDList);

  // Armazena as dimensões do perfil do usuário por categoria
  static Map<String, List<DimensionModel>> userDimensionsByCategory = {};

  // Atualiza as dimensões do usuário com valores padrão (pode ser adaptado para buscar valores reais do banco de dados)
  void updateUserDimensions(List<DimensionModel> dimensions) {
    userDimensions = dimensions;
  }

  // Atualiza as dimensões do usuário por categoria com valores padrão (pode ser adaptado para buscar valores reais do banco de dados)
  void updateUserDimensionsByCategory(String category, List<DimensionModel> dimensions) {
    userDimensionsByCategory[category] = dimensions;
  }

  // Método para limpar todas as dimensões
  void clearAll() {
    userDimensions.clear();
    userDimensionsByCategory.clear();
  }

  static String toStaticString() {
    // Converte userDimensions para String
    String userDimsStr = userDimensions.map((dim) => dim.toString()).join(',\n');

    // Converte userDimensionsByCategory para String
    String userDimsByCatStr = userDimensionsByCategory.entries.map((entry) {
      String category = entry.key;
      String dims = entry.value.map((dim) => dim.toString()).join(',\n');
      return 'Category: $category\nDimensions:\n$dims';
    }).join('\n\n');

    return 'User Dimensions:\n$userDimsStr\n\nUser Dimensions By Category:\n$userDimsByCatStr';
  }
}
