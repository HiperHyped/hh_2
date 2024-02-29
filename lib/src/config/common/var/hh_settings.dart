abstract class HHSettings {

  static bool hintSuggest = true;
  static bool gridView = true; // VERTICAL
  static bool classCriteria = true;
  static int gridLimit = 200;
  static int gridLines = 4;
  static int historyLimit = 5;

  @override
  String toString() {
    return '''
      HHSettings {
        hintSuggest: $hintSuggest,
        gridView: $gridView,
        classCriteria: $classCriteria,
        gridLimit: $gridLimit,
        gridLines: $gridLines,
        historyLimit: $historyLimit
      }
      ''';
  }

}
