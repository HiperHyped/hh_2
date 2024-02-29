import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/components/hh_button.dart';
import 'package:hh_2/src/config/common/components/hh_text_field.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/config/common/var/hh_dimensions.dart';
import 'package:hh_2/src/config/common/var/hh_notifiers.dart';
import 'package:hh_2/src/config/common/var/hh_settings.dart';
import 'package:hh_2/src/config/common/var/hh_summary.dart';
import 'package:hh_2/src/config/db/db_basket.dart';
import 'package:hh_2/src/config/db/db_dimensions.dart';
import 'package:hh_2/src/config/db/db_service.dart';
import 'package:hh_2/src/config/db/db_settings.dart';
import 'package:hh_2/src/config/db/db_summary.dart';
import 'package:hh_2/src/config/db/db_user.dart';
import 'package:hh_2/src/config/xml/xml_s3_data.dart';
import 'package:hh_2/src/models/basket_model.dart';
import 'package:hh_2/src/models/cat_model.dart';
import 'package:hh_2/src/models/user_model.dart';
import 'package:hh_2/src/pages/base/base_screen.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/pages/user/sign_up.dart';

// INICIO STARTPAGE
class StartPage extends StatefulWidget {
  const StartPage({super.key});
  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

  // Adicione um ValueNotifier para controlar o status de carregamento.
  ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  Future<void> _handleLogin() async {
      String login = _loginController.text;
      String password = _passwordController.text;

      // Exibe o AlertDialog com o CircularProgressIndicator
      showDialog(
        context: context,
        barrierDismissible: false, // O usuário não pode fechar o dialogo clicando fora dele
        builder: (BuildContext context) {
          return const AlertDialog(
            content: SizedBox(
              width: 0,  // Defina a largura
              height: 60, // e a altura do conteúdo
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        },
      );

      UserModel? user = await _dbUser.verifyUser(login, password);
      if (user != null) {

        // Pega os Settings do Usuário
        await _dbSettings.fetchSettings(user.userId);

        print("SETTINGS==> hint ${HHSettings.hintSuggest}, gridView: ${HHSettings.gridView}, classCriteria: ${HHSettings.classCriteria}, gridLimit:${HHSettings.gridLimit}, gridLines:${HHSettings.gridLines}, , historyLimit:${HHSettings.historyLimit}");

        // Pega o Report Summary do Usuário
        //await _dbService.query('CALL GenerateCompleteReport()');
        await _dbSummary.fetchSummary(user.userId);
        HHSummary.toStaticString();


        // Carrega as dimensões gerais do perfil do usuário
        await _dbDimensions.loadUserDimensions(user.userId);
        // Carrega as dimensões do perfil do usuário por categoria
        await _dbDimensions.loadUserDimensionsByCategory(user.userId);
        print(HHDimensions.toStaticString());

        // Se o usuário for verificado, redirecione para a página base
        HHGlobals.HHUser = user;

        // Se o ID do usuário não é o mesmo que o do atual no cesto, criamos um novo
        if (HHGlobals.HHBasket.value.user_id != user.userId) {
            await _dbBasket.createBasket(user.userId); // Criar novo Basket
            int? lastBasketId = await _dbBasket.getLastBasketId(user.userId); // Verificar novo basket_id
            if (lastBasketId != null) {
                BasketModel newBasket = BasketModel(); 
                newBasket.basket_id = lastBasketId; // Atualizar BasketModel com o novo ID
                newBasket.user_id = user.userId; // Atualizar BasketModel com o novo user_id
                newBasket.basketTime = await _dbBasket.getDateTime(user.userId);
                print("TIME: ${newBasket.basketTime}");
                HHGlobals.HHBasket.value = newBasket; // Atualizar HHBasket global com o novo BasketModel                
            }
        }

        // Geração do HistoryModel
        HHGlobals.HHGridList = ValueNotifier([]);
        HHGlobals.HHSuggestionList = ValueNotifier([]);
        
        HHNotifiers.counter[CounterType.BasketCount]!.value=0;
        HHNotifiers.counter[CounterType.HintCount]!.value=0;
        HHNotifiers.counter[CounterType.HistoryCount]!.value = 0;
        HHNotifiers.counter[CounterType.BookCount]!.value = 0;
        HHNotifiers.printAll();

        print("SIGN IN: ${HHGlobals.HHUser}");
        print("NEW BASKET ID: ${HHGlobals.HHBasket.value.basket_id}");
        print("NEW BASKET USER ID: ${HHGlobals.HHBasket.value.user_id}");

       Navigator.of(context).pop(); // Fecha o AlertDialog

       Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (c) {
            return BaseScreen();
          }),
        );
      } else {
        Navigator.of(context).pop(); // Fecha o AlertDialog
        showErrorDialog(context);
      }
    }


  void showErrorDialog(BuildContext context) {
    showDialog(
      
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
                side:BorderSide(
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

  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  late final DBService _dbService = DBService();
  late final DBUser _dbUser; // Note que agora _dbUser é declarado como late
  late final DBBasket _dbBasket;
  late final DBSettings _dbSettings;
  late final DBSummary _dbSummary;
  late final DBDimensions _dbDimensions;
  

  


  @override
  void initState() {
    super.initState();

    // Cat Model XML

    XMLS3Data().loadCatModelXml();


    // Se o usuário já estiver logado, preencha os campos de login e senha com suas informações   
    _dbUser = DBUser(_dbService); // Inicializamos _dbUser aqui
    _dbBasket = DBBasket(_dbService);
    _dbSettings = DBSettings(_dbService);
    _dbSummary = DBSummary(_dbService);
    _dbDimensions =DBDimensions(_dbService);

    HHGlobals.HHUser.login.isEmpty ? 
      _loginController.text = '' : 
      _loginController.text = HHGlobals.HHUser.login;

    HHGlobals.HHUser.password.isEmpty ? 
      _passwordController.text = '' : 
      _passwordController.text = HHGlobals.HHUser.password;

    print("LOGIN: ${HHGlobals.HHUser.login}");
  }

//IA 16-05-23
  @override
  Widget build(BuildContext context) {
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
                //HIPER HYPED
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.10), // Adjust this value as per your need
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //SizedBox(height:100),
                      //Image.asset("assets/images/HH93.png", scale:2),
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

                //Parte Inferior
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
                              //Campos de e-mail e senha //IA 16-05-23
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
                                selectionColor: HHColors.hhColorFirst,),
                      
                              SizedBox(height:20),  
                      
                              //Link para esqueceu a senha? //IA 16-05-23
                      
                              SizedBox(height: 20),
                              //Botões Entrar e Inscreva-se //IA 16-05-23
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
                                  SizedBox( width: 8),
                                  Expanded(
                                    child: HHButton(
                                      label: HHGlobals.HHUser.login.isEmpty ? "Entrar" : "Voltar",
                      
                                      // IA 01-06-23
                                      onPressed: _handleLogin,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                      ),
                    )
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
// FIM STARTPAGE


