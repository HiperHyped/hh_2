import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/config/db/db_service.dart';
import 'package:hh_2/src/pages/start/start_screen.dart';
import 'package:provider/provider.dart';


// Amplify Flutter Packages
//import 'package:amplify_flutter/amplify_flutter.dart';
//import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

// testando o push codigo de terceiro



void main() {

  

  runApp(
    Provider<DBService>(
      create: (_) => DBService(),
      child: const MyApp(),
      //dispose: (_, DBService service) => service.close(),
    ),
  );
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hiper Hyped',
      theme: ThemeData(
        primarySwatch: HHColors.hhColorFirstSwatch,
        scaffoldBackgroundColor: Colors.white.withAlpha(190),
      ),
      debugShowCheckedModeBanner: false,
      home: const StartPage(),
    );
  }
}

//OLD MAIN
/*
void main() {
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override

/*
  // Inicializando o Amplify
   void initState() {
    super.initState();
    AmplifyService.initialize();
    //_configureAmplify();
  }

  */
  // fim do Amplify


  // This widget is the root of your application.
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hiper Hyped',
      theme: ThemeData(
        primarySwatch: HHColors.hhColorFirstSwatch,
        scaffoldBackgroundColor: Colors.white.withAlpha(190),
      ),
      debugShowCheckedModeBanner: false,
      home: const StartPage(),
    );
  }
}
*/