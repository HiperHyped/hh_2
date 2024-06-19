import 'package:flutter/material.dart';


enum CounterType {
  BasketCount,
  HintCount,
  HistoryCount,
  BookCount,
  PeriodicCount,
  PictureCount
  // Adicione mais se necessário
}

class HHNotifiers {
  static final Map<CounterType, ValueNotifier<int>> counter = {
    CounterType.BasketCount: ValueNotifier<int>(0),
    CounterType.HintCount: ValueNotifier<int>(0),
    CounterType.HistoryCount: ValueNotifier<int>(0),
    CounterType.BookCount: ValueNotifier<int>(0),
    CounterType.PeriodicCount: ValueNotifier<int>(0), 
    CounterType.PictureCount: ValueNotifier<int>(0),
    // Adicione mais se necessário
  };

  static void increment(CounterType counterType) {
    counter[counterType]!.value++;
  }

  static void decrement(CounterType counterType) {
    counter[counterType]!.value--;
  }

  static void reset(CounterType counterType) {
    counter[counterType]!.value = 0;
  }

  static void initialize() {
    for (var counterType in counter.keys) {
      reset(counterType);
    }
  }

  static void printAll() {
    for (CounterType key in CounterType.values) {
      String keyName = key.toString().split('.').last;
      print('$keyName: ${counter[key]!.value}');

    }
  }
}



/*
class HHNotifiers {
  static final Map<String, ValueNotifier<int>> counter = {
    'basketItemCount': ValueNotifier<int>(0),
    'hintCount': ValueNotifier<int>(0),
    'historyCount': ValueNotifier<int>(0),
  };

  static void increment(String key) {
    counter[key]!.value++;
  }

  static void decrement(String key) {
    counter[key]!.value--;
  }

  static void reset(String key) {
    counter[key]!.value = 0;
  }

  static void initialize() {
    for (var key in counter.keys) {
      reset(key);
    }
  }
  
}
*/