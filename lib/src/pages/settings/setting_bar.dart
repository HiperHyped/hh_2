import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/config/common/var/hh_settings.dart';
import 'package:hh_2/src/config/db/db_service.dart';
import 'package:hh_2/src/config/db/db_settings.dart';

class SettingBar extends StatefulWidget {
  @override
  _SettingBarState createState() => _SettingBarState();
}

class _SettingBarState extends State<SettingBar> {
  bool hintSuggest = HHSettings.hintSuggest;
  bool gridView = HHSettings.gridView;
  int gridLimit = HHSettings.gridLimit;
  int gridLines = HHSettings.gridLines;
  int historyLimit = HHSettings.historyLimit;
  bool classCriteria = HHSettings.classCriteria;

  final DBService _dbService = DBService();
  late final DBSettings _dbSettings;

  _SettingBarState() {
    _dbSettings = DBSettings(_dbService);
  }

  // Atualizar a tabela e HHSettings
  void _updateSettings(String column, dynamic value) async {
    print("UPDATE SETTINGS: $column, $value, ${HHGlobals.HHUser.userId}");
    await _dbSettings.updateSettings(column, value, HHGlobals.HHUser.userId); 
    setState(() {
      // Atualizar o HHSettings aqui
      switch (column) {
        case 'hint_suggest':
          HHSettings.hintSuggest = value;
          break;
        case 'grid_view':
          HHSettings.gridView = value;
          break;
        case 'class_criteria':
          HHSettings.classCriteria = value;
          break;
        case 'grid_limit':
          HHSettings.gridLimit = value;
          break;
        case 'grid_lines':
          HHSettings.gridLines = value;
          break;
        case 'history_limit':
          HHSettings.historyLimit = value;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HHColors.hhColorGreyLight,
      child: Column(
        children: [
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Aceita Sugestão de Receitas?'),
                Text("Não", style: 
                  TextStyle(
                    color: HHColors.hhColorBack,
                    fontWeight: hintSuggest ? FontWeight.normal : FontWeight.bold,
                    )
                  ),
                Switch(
                  value: hintSuggest,
                  onChanged: (bool value) {
                    setState(() {
                      hintSuggest = value;
                      _updateSettings('hint_suggest', value);
                    });
                  },
                  activeTrackColor: HHColors.hhColorDarkFirst, // Cor da trilha quando ativado
                  inactiveTrackColor: HHColors.hhColorBack, // Cor da trilha quando desativado
                  activeColor: Colors.white, // Cor do thumb quando ativado
                  inactiveThumbColor: Colors.white, // Cor do thumb quando desativado
                ),
                Text("Sim", style: 
                  TextStyle(
                    color: HHColors.hhColorDarkFirst,
                    fontWeight: hintSuggest ? FontWeight.bold : FontWeight.normal,
                    )
                  ),
              ],
            ),
          ),


          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Classificação Personalizada?'),
                Text("Não", style: 
                  TextStyle(
                    color: HHColors.hhColorBack,
                    fontWeight: classCriteria ? FontWeight.normal : FontWeight.bold,
                    )
                  ),
                Switch(
                  value: classCriteria,
                  onChanged: (bool value) {
                    setState(() {
                      classCriteria = value;
                      _updateSettings('class_criteria', value);
                    });
                  },
                  activeTrackColor: HHColors.hhColorDarkFirst, // Cor da trilha quando ativado
                  inactiveTrackColor: HHColors.hhColorBack, // Cor da trilha quando desativado
                  activeColor: Colors.white, // Cor do thumb quando ativado
                  inactiveThumbColor: Colors.white, // Cor do thumb quando desativado
                ),
                Text("Sim", style: 
                  TextStyle(
                    color: HHColors.hhColorDarkFirst,
                    fontWeight: classCriteria ? FontWeight.bold : FontWeight.normal,
                    )
                  ),
              ],
            ),
          ),


          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Visualização de Produtos'),
                Icon(Icons.vertical_distribute, 
                  color: gridView ? HHColors.hhColorDarkFirst.withOpacity(0.5) : HHColors.hhColorDarkFirst,), ///HORIZONTAL!
                Switch(
                  value: gridView,
                  onChanged: (bool value) {
                    setState(() {
                      gridView = value;
                      _updateSettings('grid_view', value);
                    });
                  },
                  activeTrackColor: HHColors.hhColorDarkFirst, // Cor da trilha quando ativado
                  inactiveTrackColor: HHColors.hhColorDarkFirst, // Cor da trilha quando desativado
                  activeColor: Colors.white, // Cor do thumb quando ativado
                  inactiveThumbColor: Colors.white, // Cor do thumb quando desativado

                ),
                Icon(Icons.horizontal_distribute,
                  color: gridView ? HHColors.hhColorDarkFirst : HHColors.hhColorDarkFirst.withOpacity(0.5),), ///VERTICAL!!!
              ],
            ),
          ),

          Row(
            children: [
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text("Produtos por Busca?", style: TextStyle(fontSize: 16)),
                ),
              ),
              Text(gridLimit.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(width: 15.0), // Espaço entre o texto e o slider
              Container(
                width: 150, // Definindo um tamanho fixo para o slider
                child: Slider(
                  activeColor: HHColors.hhColorDarkFirst,
                  value: gridLimit.toDouble(),
                  min: 20,
                  max: 400,
                  divisions: 20,
                  onChanged: (double newValue) {
                    setState(() {
                      gridLimit = newValue.round();
                    });
                  },
                  onChangeEnd: (double value) {
                    _updateSettings('grid_limit', value.toInt()); // Atualizar no banco e HHSettings no final
                  },
                  label: '$gridLimit',
                ),
              ),
            ],
          ),

          Row(
            children: [
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text("Quantas colunas?", style: TextStyle(fontSize: 16)),
                ),
              ),
              Text(gridLines.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(width: 15.0),
              Container(
                width: 150,
                child: Slider(
                  activeColor: HHColors.hhColorDarkFirst,
                  value: gridLines.toDouble(),
                  min: 2,
                  max: 10,
                  divisions: 8,
                  onChanged: (double newValue) {
                    setState(() {
                      gridLines = newValue.round();
                    });
                  },
                  onChangeEnd: (double value) {
                    _updateSettings('grid_lines', value.toInt()); // Atualizar no banco e HHSettings no final
                  },
                  label: '$gridLines',
                ),
              ),
            ],
          ),

          Row(
            children: [
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text("Quantos Históricos?", style: TextStyle(fontSize: 16)),
                ),
              ),
              Text(historyLimit.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(width: 15.0), // Espaço entre o texto e o slider
              Container(
                width: 150, // Definindo um tamanho fixo para o slider
                child: Slider(
                  activeColor: HHColors.hhColorDarkFirst,
                  value: historyLimit.toDouble(),
                  min: 0,
                  max: 20,
                  divisions: 20,
                  onChanged: (double newValue) {
                    setState(() {
                      historyLimit = newValue.round();
                    });
                  },
                  onChangeEnd: (double value) {
                    _updateSettings('history_limit', value.toInt()); // Atualizar no banco e HHSettings no final
                  },
                  label: '$historyLimit',
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
