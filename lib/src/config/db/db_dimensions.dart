

import 'package:hh_2/src/config/common/var/hh_dimensions.dart';
import 'package:hh_2/src/config/db/db_service.dart';
import 'package:hh_2/src/models/dimension_model.dart';


class DBDimensions {
  final DBService _dbService;

  DBDimensions(this._dbService);

  Future<void> loadUserDimensions(int userId) async {
    const sql = 'SELECT * FROM User_Profile WHERE user_id = ?';
    final values = [userId];
    final results = await _dbService.query(sql, values);

    if (results.isNotEmpty) {
      var row = results.first; // Assumindo que há apenas uma linha por usuário

      List<DimensionModel> dimensions = [];
      for (var i = 1; i <= 9; i++) {
        // Cria um DimensionModel para cada dimensão baseada nos valores
        // Similarmente, estamos assumindo que a tabela tem colunas como 'dimension_value1', 'dimension_value2', etc.
        DimensionModel dimension = DimensionModel(
          code: HHDList[i - 1].code,
          value: double.parse(row['avg_D$i'].toString()),
          name: HHDList[i - 1].name,
          type: HHDList[i - 1].type,
          type_pt: HHDList[i - 1].type_pt,
          definition: HHDList[i - 1].definition,
        );
        dimensions.add(dimension);
      }

      // Atualiza HHDimensions com as dimensões globais do usuário carregadas
      HHDimensions().updateUserDimensions(dimensions);
    } else {
      // Lidar com o caso em que não são encontradas dimensões para o usuário, se necessário
    }
  }

  
  Future<void> loadUserDimensionsByCategory(int userId) async {
    const sql = 'SELECT * FROM User_Profile_Cat WHERE user_id = ?';
    final values = [userId];
    final results = await _dbService.query(sql, values);

    Map<String, List<DimensionModel>> dimensionsByCategory = {};
    for (var row in results) {
      String category = row['sigla'];
      print("CATEGORIES: $category");
      // Assumindo que temos colunas dimension_value1 até dimension_value9 para cada dimensão em User_Profile_Cat
      List<DimensionModel> dimensions = [];
      for (var i = 1; i <= 9; i++) {
        // Cria um DimensionModel para cada dimensão baseada nos valores
        // Aqui estamos assumindo que a tabela tem colunas como 'dimension_value1', 'dimension_value2', etc.
        // e que HHDList contém as definições de todas as dimensões na ordem correta.
        DimensionModel dimension = DimensionModel(
          code: HHDList[i - 1].code,
          value: double.parse(row['avg_D$i'].toString()),
          name: HHDList[i - 1].name,
          type: HHDList[i - 1].type,
          type_pt: HHDList[i - 1].type_pt,
          definition: HHDList[i - 1].definition,
        );
        dimensions.add(dimension);
      }

      dimensionsByCategory[category] = dimensions;
    }

    // Atualiza HHDimensions com as dimensões por categoria carregadas
    dimensionsByCategory.forEach((category, dimensions) {
      HHDimensions().updateUserDimensionsByCategory(category, dimensions);
    });
  }
}
