import 'package:hh_2/src/models/basket_model.dart';

enum PeriodType {
  S, // Semanal
  Q, // Quinzenal
  M  // Mensal
}

class PeriodicModel {
  int periodicId = 0;
  int userId = 0;
  DateTime periodicTime;
  String listName;
  PeriodType periodType; // Atualizado de 'period' para 'periodType'
  String weeklyDays; // Atualizado de 'daysOfWeek' para 'weeklyDays'
  int? monthlyDay; // Atualizado de 'preferredDay' para 'monthlyDay'
  List<BasketModel> basketList = [];

  PeriodicModel({
    this.periodicId = 0,
    this.userId = 0,
    required this.periodicTime,
    required this.listName,
    required this.periodType,
    required this.weeklyDays,
    this.monthlyDay,
    required this.basketList,
  });

  @override
  String toString() {
    return 'PeriodicModel('
        'periodicId: $periodicId, '
        'userId: $userId, '
        'periodicTime: $periodicTime, '
        'listName: $listName, '
        'periodType: $periodType, '
        'weeklyDays: $weeklyDays, '
        'monthlyDay: $monthlyDay, '
        'basketList: $basketList'
        ')';
  }
}

