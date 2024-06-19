import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/components/hh_button.dart';
import 'package:hh_2/src/config/common/components/hh_text_field.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/config/common/var/hh_dimensions.dart';
import 'package:hh_2/src/config/common/var/hh_notifiers.dart';
import 'package:hh_2/src/config/db/db_basket.dart';
import 'package:hh_2/src/config/db/db_dimensions.dart';
import 'package:hh_2/src/config/db/db_service.dart';
import 'package:hh_2/src/config/db/db_settings.dart';
import 'package:hh_2/src/config/db/db_summary.dart';
import 'package:hh_2/src/config/db/db_user.dart';
import 'package:hh_2/src/config/log/log_service.dart';
import 'package:hh_2/src/config/xml/xml_s3_data.dart';
import 'package:hh_2/src/models/basket_model.dart';
import 'package:hh_2/src/models/user_model.dart';
import 'package:hh_2/src/pages/base/base_screen.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/pages/user/sign_up.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});
  
  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  late final DBService _dbService = DBService();
  late final DBUser _dbUser; 
  late final DBBasket _dbBasket;
  late final DBSettings _dbSettings;
  late final DBSummary _dbSummary;
  late final DBDimensions _dbDimensions;

  @override
  void initState() {
    super.initState();
    LogService.init();

    XMLS3Data().loadCatModelXml();

    _dbUser = DBUser(_dbService);
    _dbBasket = DBBasket(_dbService);
    _dbSettings = DBSettings(_dbService);
    _dbSummary = DBSummary(_dbService);
    _dbDimensions = DBDimensions(_dbService);

    if (HHGlobals.userBypass) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleLoginBypass();
      });
    } else {
      HHGlobals.HHUser.login.isEmpty ? 
        _loginController.text = '' : 
        _loginController.text = HHGlobals.HHUser.login;

      HHGlobals.HHUser.password.isEmpty ? 
        _passwordController.text = '' : 
        _passwordController.text = HHGlobals.HHUser.password;

      LogService.logInfo("LOGIN: ${HHGlobals.HHUser.login}", "START");
    }
  }

  Future<void> _handleLogin() async {
    String login = _loginController.text;
    String password = _passwordController.text;
    await _performLogin(login, password);
  }

  Future<void> _handleLoginBypass() async {
    String login = HHGlobals.userLoginByPass;
    String password = HHGlobals.userPasswordByPass;
    await _performLogin(login, password);
  }

  Future<void> _performLogin(String login, String password) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: 0,
            height: 60,
            child: Center(
              child: CircularProgressIndicator(
                color: HHColors.hhColorFirst,
              ),
            ),
          ),
        );
      },
    );

    UserModel? user = await _dbUser.verifyUser(login, password);
    if (user != null) {
      await _dbSettings.fetchSettings(user.userId);
      await _dbService.call('GenerateTimeSummary');
      await _dbService.call('GenerateCompleteReport');
      await _dbSummary.fetchSummary(user.userId);
      await _dbSummary.fetchTimeSummary(user.userId);
      await _dbService.call('CalculateUserProfilesBySigla');
      await _dbDimensions.loadUserDimensions(user.userId);
      await _dbDimensions.loadUserDimensionsByCategory(user.userId);

      LogService.logInfo("DIMENSIONS: ${HHDimensions.toStaticString()}", "START");

      HHGlobals.HHUser = user;

      if (HHGlobals.HHBasket.value.user_id != user.userId) {
        await _dbBasket.createBasket(user.userId);
        int? lastBasketId = await _dbBasket.getLastBasketId(user.userId);
        if (lastBasketId != null) {
          BasketModel newBasket = BasketModel();
          newBasket.basket_id = lastBasketId;
          newBasket.user_id = user.userId;
          newBasket.basketTime = await _dbBasket.getDateTime(user.userId);
          HHGlobals.HHBasket.value = newBasket;
        }
      }

      HHGlobals.HHGridList = ValueNotifier([]);
      HHGlobals.HHSuggestionList = ValueNotifier([]);
      
      HHNotifiers.counter[CounterType.BasketCount]!.value = 0;
      HHNotifiers.counter[CounterType.HintCount]!.value = 0;
      HHNotifiers.counter[CounterType.HistoryCount]!.value = 0;
      HHNotifiers.counter[CounterType.BookCount]!.value = 0;
      HHNotifiers.counter[CounterType.PeriodicCount]!.value = 0;

      LogService.logInfo("SIGN IN: ${HHGlobals.HHUser}", "START");
      LogService.logInfo("NEW BASKET ID: ${HHGlobals.HHBasket.value.basket_id}", "START");
      LogService.logInfo("NEW BASKET USER ID: ${HHGlobals.HHBasket.value.user_id}", "START");

      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (c) {
          return BaseScreen();
        }),
      );
    } else {
      Navigator.of(context).pop();
      showErrorDialog(context);
    }
  }

  void showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: HHColors.hhColorFirst, 
              style: BorderStyle.solid,
              width: 4.0,
            ),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          title: Center(
            child: Text(
              'Erro de Login',
              style: TextStyle(color: HHColors.hhColorFirst),
            )
          ),
          content: const Text(
            'Login ou senha inválidos.',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (HHGlobals.userBypass) {
      return Scaffold(
        backgroundColor: HHColors.hhColorLightFirst,
        body: Center(
          child: CircularProgressIndicator(
            color: HHColors.hhColorFirst,
          ),
        ),
      );
    } else {
      final size = MediaQuery.of(context).size;
      double scaleFactor = MediaQuery.of(context).size.shortestSide / 500;

      return Scaffold(
        backgroundColor: HHColors.hhColorLightFirst,
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: size.height),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/HH93.png", scale: 2 * scaleFactor), 
                        Container(
                          alignment: const Alignment(0.0, 0.0),
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(45))),
                          child: Text.rich(
                            TextSpan(
                                style: TextStyle(
                                  fontSize: 50 * scaleFactor,
                                ),
                                children: [
                                  TextSpan(
                                      text: 'Hiper',
                                      style: TextStyle(
                                        color: HHColors.hhColorDarkFirst,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  TextSpan(
                                      text: 'Hyped',
                                      style: TextStyle(
                                        color: HHColors.hhColorBack,
                                        fontWeight: FontWeight.bold,
                                      ))
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 40,
                      ),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 600),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                HHTextField(
                                  icon: Icons.login,
                                  label: 'Login',
                                  controller: _loginController,
                                ),
                                HHTextField(
                                  icon: Icons.lock,
                                  label: 'Senha',
                                  isSecret: true,
                                  controller: _passwordController,
                                ),
                                Text('Esqueceu a senha?', 
                                  style: TextStyle(color: HHColors.hhColorFirst),
                                  selectionColor: HHColors.hhColorFirst,
                                ),
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: HHButton(
                                        label: "Cadastrar", 
                                        invert: true,
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return SignUp(login: _loginController.text, password: _passwordController.text);
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: HHButton(
                                        label: HHGlobals.HHUser.login.isEmpty ? "Entrar" : "Voltar",
                                        onPressed: _handleLogin,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
