/*import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import '/amplifyconfiguration.dart';

class AmplifyService {
  AmplifyService._();

static Future initialize() async {
  try {
    final auth = AmplifyAuthCognito();
    await Amplify.addPlugin(auth);

    // call Amplify.configure to use the initialized categories in your app
    await Amplify.configure(amplifyconfig);

    bool isSignedIn = await isUserSignedIn();
    print("USER IS SIGNED: $isSignedIn");
    
    if (isSignedIn) {
      AuthUser currentUser = await getCurrentUser();
      print("USER CURRENT: $currentUser");
    }
  } on Exception catch (e) {
    print('An error occurred configuring Amplify: $e');
  }
}

  //Anterior
  /*static Future initialize() async {
    try {
      final auth = AmplifyAuthCognito();
      await Amplify.addPlugin(auth);

      // call Amplify.configure to use the initialized categories in your app
      await Amplify.configure(amplifyconfig);
      print("USER IS SIGNED: ${isUserSignedIn()}");
      print("USER CURRENT: ${getCurrentUser()}");
    } on Exception catch (e) {
      print('An error occurred configuring Amplify: $e');
    }
  }*/

  static Future<bool> isUserSignedIn() async {
    final result = await Amplify.Auth.fetchAuthSession();
    return result.isSignedIn;
  }

  static Future<AuthUser> getCurrentUser() async {
    final user = await Amplify.Auth.getCurrentUser();
    return user;
  }
}*/