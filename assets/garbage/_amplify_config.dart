/*
//anterior
//// src/config/amplify_config.dart
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';


class AmplifyConfig {
  final String amplifyConfig = '''{"foo": "bar"}''';
  bool _amplifyConfigured = false;

  Future<void> configureAmplify() async {
    await Amplify.configure(amplifyConfig);
    try {
      _amplifyConfigured = true;
    } on Exception catch (e) {
      print(e);
    }
  }

  bool get isConfigured => _amplifyConfigured;
}

/*class AmplifyConfig {
  static Future<void> configureAmplify() async {
    // Inicializando o Amplify
    final Amplify amplifyInstance = Amplify();

    // Configurando os plugins
    AmplifyStorageS3 storage = AmplifyStorageS3();
    amplifyInstance.addPlugin(storagePlugins: [storage]);

    // Configurando o Amplify
    try {
      await amplifyInstance.configure(amplifyconfig);
    } catch (e) {
      print(e);
    }
  }
}*/
*/
