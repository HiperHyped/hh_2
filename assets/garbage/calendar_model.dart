import '../../lib/src/models/ean_model.dart';  // Supondo que EanModel é a classe que representa produtos

class CalendarModel {
  int id;
  int userId;
  Map<EanModel, int> productQuantities; // Usando EanModel para os produtos
  String periodicityPattern; // 7-character string, ex: '0010100'
  String periodicityType; // 'Semanal', 'Quinzenal', 'Mensal'
  bool postponeOnHoliday;
  String name;

  CalendarModel({
    required this.id,
    required this.userId,
    required this.productQuantities,
    required this.periodicityPattern,
    required this.periodicityType,
    this.postponeOnHoliday = false,
    required this.name,
  });

  double calculateTotalPrice() {
    return productQuantities.entries
        .map((entry) => double.parse(entry.key.preco) * entry.value)
        .reduce((value, element) => value + element);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'productQuantities': productQuantities.map((key, value) => MapEntry(key.toString(), value)),
      'periodicityPattern': periodicityPattern,
      'periodicityType': periodicityType,
      'postponeOnHoliday': postponeOnHoliday,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'CalendarModel{id: $id, userId: $userId, productQuantities: $productQuantities, periodicityPattern: $periodicityPattern, periodicityType: $periodicityType, postponeOnHoliday: $postponeOnHoliday, name: $name}';
  }
}

class CalendarListModel {
  List<CalendarModel> calendars;

  CalendarListModel({required this.calendars});

  Map<String, dynamic> toMap() {
    return {
      'calendars': calendars.map((calendar) => calendar.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return 'CalendarListModel{calendars: $calendars}';
  }
}