import 'package:hh_2/src/config/common/var/hh_settings.dart';
import 'package:hh_2/src/config/db/db_service.dart';
import 'package:hh_2/src/config/log/log_service.dart';


class DBSettings {
  final DBService _dbService;

  DBSettings(this._dbService) {LogService.init();}

  Future<void> fetchSettings(int userId) async {
    final sql = 'SELECT * FROM Settings WHERE user_id = ?';
    final values = [userId];
    final results = await _dbService.query(sql, values);

    if (results.isNotEmpty) {
      var settings = results.first;
      LogService.logInfo("ANTES: ${settings.toString()}", "SETTINGS");


      HHSettings.hintSuggest = _valueToBool(settings['hint_suggest']);
      HHSettings.gridView = _valueToBool(settings['grid_view']);
      HHSettings.classCriteria = _valueToBool(settings['class_criteria']);
      HHSettings.gridLimit = int.parse(settings['grid_limit'].toString());
      HHSettings.gridLines = int.parse(settings['grid_lines'].toString());
      HHSettings.historyLimit = int.parse(settings['history_limit'].toString());

      LogService.logInfo("DEPOIS: hintSuggest: ${HHSettings.hintSuggest},  gridView: ${HHSettings.gridView },  classCriteria: ${HHSettings.classCriteria},  gridLimit: ${HHSettings.gridLimit}, gridLines: ${HHSettings.gridLines}, historyLimit: ${HHSettings.historyLimit}", "SETTINGS");

    }
  }

  Future<void> updateSettings(String column, dynamic value, int userId) async {
    String sql = 'UPDATE Settings SET $column = ? WHERE user_id = ?';
    List<dynamic> values;

    if (value is bool) {
      values = [value ? 1 : 0, userId];
    } else {
      values = [value, userId];
    }

    await _dbService.query(sql, values);
  }

    bool _valueToBool(dynamic value) {
    if (value is int) {
      return value == 1;
    } else if (value is String) {
      return value == '1';
    } else {
      return false; // ou throw Exception("Tipo de valor desconhecido: $value");
    }
  }
}
