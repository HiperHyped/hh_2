import 'package:logging/logging.dart';

class LogService {
  static final Map<String, Logger> _loggers = {
    'START': Logger('START'),
    'REPORT': Logger('REPORT'),
    'USER': Logger('USER'),
    'PERIODIC': Logger('PERIODIC'),
    'SUGGESTION': Logger('SUGGESTION'),
    'SETTINGS': Logger('SETTINGS'),
    'DB': Logger('DB'),
    'AI': Logger('AI'),
    'PHOTO': Logger('PHOTO'),
    // Adicione outras categorias conforme necessário
  };

  // Defina as categorias ativas aqui
  static final Map<String, bool> _activeCategories = {
    'START': false,
    'REPORT': false,
    'PERIODIC': true,
    'SUGGESTION': false,
    'SETTINGS': false,
    'USER': false,
    'DB': true,
    'AI': true,
    'PHOTO': true
    // Defina outras categorias conforme necessário
  };

  static void init() {
    Logger.root.level = Level.WARNING; //Level.ALL;
    Logger.root.onRecord.listen((record) {
      if (_activeCategories[record.loggerName] ?? false) {
        //print('${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}');
        print('${record.loggerName}: ${record.message}');
      }
    });
  }

  static void logInfo(String message, String category) {
    _loggers[category]?.info(message);
  }

  static void logWarning(String message, String category) {
    _loggers[category]?.warning(message);
  }

  static void logError(String message, String category) {
    _loggers[category]?.severe(message);
  }

  static void logDebug(String message, String category) {
    _loggers[category]?.fine(message);
  }
}
