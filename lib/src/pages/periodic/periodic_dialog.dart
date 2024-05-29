import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/components/hh_button.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/config/db/db_periodic.dart';
import 'package:hh_2/src/config/db/db_service.dart';
import 'package:hh_2/src/config/log/log_service.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:hh_2/src/models/periodic_model.dart';

class PeriodicDialog extends StatefulWidget {
  final EanModel product;

  PeriodicDialog({required this.product}) {LogService.init();}

  @override
  _PeriodicDialogState createState() => _PeriodicDialogState();
}

class _PeriodicDialogState extends State<PeriodicDialog> {
  final DBPeriodic _dbPeriodic = DBPeriodic();

  String selectedList = "Criar Lista";
  String newListName = "";
  PeriodType selectedPeriodType = PeriodType.S;
  String selectedDaysOfWeek = "00000";
  int? selectedDay;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.3,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: HHColors.hhColorFirst,
                width: 4,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Lista Periódica",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                DropdownButton<String>(
                  value: selectedList,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedList = newValue!;
                    });
                  },
                  items: <String>["Criar Lista", ...HHGlobals.HHPeriodicLists.value.map((list) => list.listName)]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                if (selectedList == "Criar Lista") ...[
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        newListName = value;
                      });
                    },
                    decoration: InputDecoration(hintText: "Nome da nova lista"),
                  ),
                  SizedBox(height: 16),
                  Text("Tipo de Período"),
                  DropdownButton<PeriodType>(
                    value: selectedPeriodType,
                    onChanged: (PeriodType? newValue) {
                      setState(() {
                        selectedPeriodType = newValue!;
                      });
                    },
                    items: PeriodType.values.map<DropdownMenuItem<PeriodType>>((PeriodType value) {
                      String periodText;
                      switch (value) {
                        case PeriodType.S:
                          periodText = 'Semanal';
                          break;
                        case PeriodType.Q:
                          periodText = 'Quinzenal';
                          break;
                        case PeriodType.M:
                          periodText = 'Mensal';
                          break;
                      }
                      return DropdownMenuItem<PeriodType>(
                        value: value,
                        child: Text(periodText),
                      );
                    }).toList(),
                  ),
                  if (selectedPeriodType == PeriodType.M) ...[
                    SizedBox(height: 16),
                    Text("Dia Preferido"),
                    DropdownButton<int>(
                      value: selectedDay,
                      onChanged: (int? newValue) {
                        setState(() {
                          selectedDay = newValue;
                        });
                      },
                      items: List.generate(30, (index) => index + 1).map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                    ),
                  ],
                  if (selectedPeriodType == PeriodType.S || selectedPeriodType == PeriodType.Q) ...[
                    SizedBox(height: 16),
                    Text("Dias da Semana"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(5, (index) {
                        String dayLabel = ''; // Inicializando dayLabel
                        switch (index) {
                          case 0:
                            dayLabel = 'Seg';
                            break;
                          case 1:
                            dayLabel = 'Ter';
                            break;
                          case 2:
                            dayLabel = 'Qua';
                            break;
                          case 3:
                            dayLabel = 'Qui';
                            break;
                          case 4:
                            dayLabel = 'Sex';
                            break;
                        }
                        return Column(
                          children: [
                            Text(dayLabel),
                            Checkbox(
                              value: selectedDaysOfWeek[index] == '1',
                              onChanged: (bool? value) {
                                setState(() {
                                  var days = selectedDaysOfWeek.split('');
                                  days[index] = value! ? '1' : '0';
                                  selectedDaysOfWeek = days.join('');
                                });
                              },
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ],
                SizedBox(height: 16),
                HHButton(
                  onPressed: () async {
                    if (selectedList == "Criar Lista") {
                      var newPeriodicModel = PeriodicModel(
                        userId: HHGlobals.HHUser.userId,
                        periodicTime: DateTime.now(),
                        listName: newListName,
                        periodType: selectedPeriodType,
                        weeklyDays: selectedDaysOfWeek,
                        monthlyDay: selectedPeriodType == PeriodType.M ? selectedDay : null,
                        basketList: [],
                      );
                      await _dbPeriodic.addPeriodic(newPeriodicModel);
                      var periodicId = await _dbPeriodic.getLastPeriodicId(HHGlobals.HHUser.userId);
                      print("PERIODIC ID: $periodicId");
                      if (periodicId != null) {
                        await _dbPeriodic.addProductToList(widget.product, periodicId, 1, double.parse(widget.product.preco));
                      }
                      var updatedLists = await _dbPeriodic.getPeriodicLists(HHGlobals.HHUser.userId);
                      LogService.logInfo("CRIAR LISTA : ${updatedLists.toString()}", 'PERIODIC');
                      HHGlobals.HHPeriodicLists.value = updatedLists;
                    } else {
                      var existingList = HHGlobals.HHPeriodicLists.value.firstWhere((list) => list.listName == selectedList);
                      await _dbPeriodic.addProductToList(widget.product, existingList.periodicId, 1, double.parse(widget.product.preco));
                      var updatedLists = await _dbPeriodic.getPeriodicLists(HHGlobals.HHUser.userId);
                      LogService.logInfo("LISTAS EXISTENTES: ${updatedLists.toString()}", 'PERIODIC');
                      HHGlobals.HHPeriodicLists.value = updatedLists;
                    }
                    //_dbPeriodic.loadPeriodicOnce(); 
                    Navigator.of(context).pop();
                  },
                  label: selectedList == "Criar Lista" ? "Cadastrar e Inserir" : "Inserir",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
