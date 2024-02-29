import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/config/common/var/hh_dimensions.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/models/cat_model.dart';
import 'package:hh_2/src/models/dimension_model.dart';
import 'package:intl/intl.dart';


class DimensionsPage extends StatelessWidget {
  final NumberFormat formatCurrency = NumberFormat.simpleCurrency(locale: 'pt_BR');

  double calculateAverage(List<DimensionModel> dimensions, String type) {
    return dimensions.fold(
        0.0,
        (previousValue, element) =>
            previousValue + (element.type == type ? element.value : 0.0)) /
        dimensions.where((element) => element.type == type).length;
  }

  Color getColorBasedOnValue(double value) {
    if (value >= 0.8) {
      return Colors.green;
    } else if (value >= 0.6) {
      return Colors.lightGreen;
    } else if (value >= 0.4) {
      return Colors.yellow;
    } else if (value >= 0.2) {
      return Colors.orange;
    } else {
      return Colors.red; 
    }
  }

  // Função atualizada para construir as barras com cinco divisões
  Widget buildDimensionBar(double value, Color color) {
    // Garante que o valor esteja entre 0.0 e 1.0
    double widthFactor = value.clamp(0.0, 1.0);

    return Tooltip(
      message: value.toStringAsFixed(2),
      child: Container(
        width: double.infinity,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(4),
        ),
        child: FractionallySizedBox(
          widthFactor: widthFactor,
          alignment: Alignment.centerLeft,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(4),
              ),
            ),
          ),
        ),
      ),
    );
  }


  // Widget para construir as linhas de dimensões com rótulos e barras
  Widget buildDimensionsRow(Map<String, double> averages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: averages.entries.map((entry) {
        return Expanded(
          child: Column(
            children: [
              Text(
                entry.key,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              buildDimensionBar(entry.value, getColorBasedOnValue(entry.value)),
            ],
          ),
        );
      }).toList()
        // Adiciona um SizedBox entre cada widget de barra para criar um espaço
        .expand((widget) => [widget, SizedBox(width: 8)]).toList() // Ajuste a largura conforme necessário
        ..removeLast(), // Remove o último SizedBox que não é necessário após o último widget
    );
  }


  @override
  Widget build(BuildContext context) {
    // Substitua estas chamadas pelas chamadas reais para obter os dados
    final double brandAverage = calculateAverage(HHDimensions.userDimensions, 'Marca');
    final double categoryAverage = calculateAverage(HHDimensions.userDimensions, 'Categoria');
    final double priceAverage = calculateAverage(HHDimensions.userDimensions, 'Preço');

    // Mapa com as médias para passar ao widget de linhas de dimensões
    final Map<String, double> userAverages = {
      'Marca': brandAverage,
      'Variedade': categoryAverage,
      'Preço': priceAverage,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Análise de Dimensões'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.green, width: 2), // Borda verde
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nome',style: TextStyle(color: HHColors.hhColorFirst, fontWeight: FontWeight.bold, fontSize: 16), ),
                                Text(
                                  HHGlobals.HHUser.name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ), // Substitua pelo nome de usuário real
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Login',style: TextStyle(color: HHColors.hhColorFirst, fontWeight: FontWeight.bold, fontSize: 16), ),
                                Text(
                                  HHGlobals.HHUser.login,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ), // Substitua pelo login de usuário real
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('UF',style: TextStyle(color: HHColors.hhColorFirst, fontWeight: FontWeight.bold, fontSize: 16), ),
                                Text(
                                  HHGlobals.HHUser.uf,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ), // Substitua pelo UF de usuário real
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text('Análise Geral',style: TextStyle(color: HHColors.hhColorFirst, fontWeight: FontWeight.bold, fontSize: 16), ),
                      SizedBox(height: 8),
                      buildDimensionsRow(userAverages),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Substitua pela chamada real para obter as dimensões por categoria
              ...HHDimensions.userDimensionsByCategory.entries.map((entry) {
                final String category = entry.key;
                final List<DimensionModel> categoryDimensions = entry.value;

                // Mapa com as médias para passar ao widget de linhas de dimensões
                final Map<String, double> categoryAverages = {
                  'Marca': calculateAverage(categoryDimensions, 'Marca'),
                  'Variedade': calculateAverage(categoryDimensions, 'Categoria'),
                  'Preço': calculateAverage(categoryDimensions, 'Preço'),
                };

                return Card(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${CatModel.findCatBySigla(HHGlobals.listCat, category)!.emj} ${CatModel.findCatBySigla(HHGlobals.listCat, category)!.nom}",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        buildDimensionsRow(categoryAverages),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}


