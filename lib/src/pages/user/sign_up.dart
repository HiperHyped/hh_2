import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:hh_2/src/config/common/components/hh_button.dart';
import 'package:hh_2/src/config/common/components/hh_text_field.dart';
import 'package:hh_2/src/config/common/components/hh_uf_drop_down.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/config/common/var/hh_var.dart';
import 'package:hh_2/src/config/db/db_basket.dart';
import 'package:hh_2/src/config/db/db_user.dart';
import 'package:hh_2/src/models/basket_model.dart';
import 'package:hh_2/src/models/user_model.dart';
import 'package:hh_2/src/pages/base/base_screen.dart';
import 'package:provider/provider.dart';
import '../../config/db/db_service.dart';

class SignUp extends StatefulWidget {
  final String? login;
  final String? password;

  SignUp({Key? key, this.login, this.password}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  final DBService _dbService = DBService();
  late final DBUser _dbUser; // Note que agora _dbUser é declarado como late
  late final DBBasket _dbBasket;


  // Instantiate text editing controllers for each field
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();

  final _cpfController = new MaskedTextController(mask: '000.000.000-00');
  final _rgController = new MaskedTextController(mask: '00.000.000-0');
  final _phoneController = new MaskedTextController(mask: '(00) 00000-0000');

  //final _cpfController = TextEditingController();
  //final _rgController = TextEditingController();

  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _ufController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Assign initial values if provided

    _dbUser = DBUser(_dbService); // Inicializamos _dbUser aqui
    _dbBasket = DBBasket(_dbService);

    _loginController.text = widget.login ?? '';
    _passwordController.text = widget.password ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cadastro de Usuário',
          style: TextStyle(
            color: HHColors.hhColorWhite,
            fontWeight: FontWeight.bold,
          ),
          ),
        backgroundColor: HHColors.hhColorFirst,
        
        ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
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
            HHTextField(
              icon: Icons.email,
              label: 'Email',
              controller: _emailController,
            ),
            HHTextField(
              icon: Icons.person,
              label: 'Nome',
              controller: _nameController,
            ),
            HHTextField(
              icon: Icons.confirmation_number,
              label: 'CPF',
              controller: _cpfController,
            ),
            HHTextField(
              icon: Icons.card_travel,
              label: 'RG',
              controller: _rgController,
            ),
            HHTextField(
              icon: Icons.home,
              label: 'Endereço',
              controller: _addressController,
            ),
            HHTextField(
              icon: Icons.location_city,
              label: 'Cidade',
              controller: _cityController,
            ),
            HHTextField(
              icon: Icons.phone,
              label: 'Celular',
              controller: _phoneController,
            ),
            HHUFDropDown(controller: _ufController, onUFChanged: () {  },),
            Row(
              children: [
                Expanded(
                  child: HHButton(
                    label: 'Cadastrar',
                    onPressed: () async {
                      UserModel newUser = UserModel(
                        login: _loginController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                        name: _nameController.text,
                        cpf: _cpfController.text,
                        rg: _rgController.text,
                        address: _addressController.text,
                        city: _cityController.text,
                        uf: _ufController.text,
                        phone: _phoneController.text,
                      );
                      print("VAMOS CADASTRAR?");
                      await _dbUser.insertUser(newUser);
                      //await DBService.instance.insertUser(user);
                      //HHGlobals.HHUser = newUser;
                      UserModel? user = await _dbUser.verifyUser(newUser.login, newUser.password );
                      if(user != null) { 
                        //user
                        HHGlobals.HHUser = user;
                        print("SIGN UP: ${HHGlobals.HHUser}");
                        print("USER ID: ${HHGlobals.HHUser.userId}");
                        //basket
                        await _dbBasket.createBasket(user.userId);
                        int? lastBasketId = await _dbBasket.getLastBasketId(user.userId); // Verificar novo basket_id
                        if (lastBasketId != null) {
                            BasketModel newBasket = BasketModel(); 
                            newBasket.basket_id = lastBasketId; // Atualizar BasketModel com o novo ID
                            newBasket.user_id = user.userId; // Atualizar BasketModel com o novo user_id
                            HHGlobals.HHBasket.value = newBasket; // Atualizar HHBasket global com o novo BasketModel
                        }
                        print("BASKET ID: ${HHGlobals.HHBasket.value.basket_id}");
                        print("BASKET USER ID: ${HHGlobals.HHBasket.value.user_id}");
                        } 
                      //Navigator.pop(context);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (c) {
                          return BaseScreen();
                        }),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
