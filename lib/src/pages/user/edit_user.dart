import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:hh_2/src/config/common/components/hh_button.dart';
import 'package:hh_2/src/config/common/components/hh_text_field.dart';
import 'package:hh_2/src/config/common/components/hh_uf_drop_down.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/config/db/db_service.dart';
import 'package:hh_2/src/config/db/db_user.dart';
import 'package:hh_2/src/models/user_model.dart';
import 'package:hh_2/src/pages/base/base_screen.dart';

class EditUser extends StatefulWidget {

  EditUser({Key? key}) : super(key: key);

  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final _formKey = GlobalKey<FormState>();

  final UserModel user = HHGlobals.HHUser;
  
  final DBService _dbService = DBService();
  late final DBUser _dbUser; // Note que agora _dbUser é declarado como late

  // Instantiate text editing controllers for each field
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _cpfController = new MaskedTextController(mask: '000.000.000-00');
  final _rgController = new MaskedTextController(mask: '00.000.000-0');
  final _phoneController = new MaskedTextController(mask: '(00) 00000-0000');
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _ufController = TextEditingController();

  bool isModified = false;
  bool ufModified = false;

  @override
  void initState() {
    super.initState();

    // Assign initial values if provided

    _dbUser = DBUser(_dbService); // Inicializamos _dbUser aqui
    
    _loginController.text = user.login;
    _passwordController.text = user.password;
    _emailController.text = user.email;
    _nameController.text = user.name;
    _cpfController.text = user.cpf;
    _rgController.text = user.rg;
    _addressController.text = user.address;
    _cityController.text = user.city;
    _ufController.text = user.uf;
    _phoneController.text = user.phone;

    List<TextEditingController> controllers = [
      _loginController, _passwordController, _emailController, _nameController,
      _cpfController, _rgController, _addressController, _cityController,
      _ufController, _phoneController
    ];

    for (TextEditingController controller in controllers) {
      controller.addListener(() {
        setState(() {
          isModified = true;
        });
      });
    }

    _ufController.addListener(() { 
      setState(() {
          ufModified = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HHColors.hhColorGreyMedium,
      appBar: AppBar(
        title: Text(
          'Alteração de Dados',
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
              readOnly: true,
              controller: _loginController,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Alterar Senha',
                style: TextStyle(
                  color: HHColors.hhColorDarkFirst,
                ),
                ),
            ),
            /*HHTextField(
              icon: Icons.lock,
              label: 'Senha',
              isSecret: true,
              controller: _passwordController,
            ),*/
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
            HHButton(
             label: 'Alterar',
              onPressed: () {
                if (isModified) {
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
                  _dbUser.updateUser(newUser);
                  HHGlobals.HHUser = newUser;
                  if (ufModified){
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (c) {
                        return BaseScreen();
                      }),
                    );
                  } else{
                    Navigator.pop(context);
                  }
                  //_dbService.updateUser2(user, newUser);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

}




/*

class EditUser extends StatefulWidget {
  final UserModel? user;

  EditUser({Key? key, this.user}) : super(key: key);

  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final _formKey = GlobalKey<FormState>();
  final DBService _dbService = DBService();

  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _cpfController = new MaskedTextController(mask: '000.000.000-00');
  final _rgController = new MaskedTextController(mask: '00.000.000-0');
  final _phoneController = new MaskedTextController(mask: '(00) 00000-0000');
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();

  bool isModified = false;

  @override
  void initState() {
    super.initState();
    UserModel user = HHGlobals.HHUser;
    _loginController.text = user.login;
    _passwordController.text = user.password;
    _emailController.text = user.email;
    _nameController.text = user.name;
    _cpfController.text = user.cpf;
    _rgController.text = user.rg;
    _addressController.text = user.address;
    _cityController.text = user.city;
    _stateController.text = user.uf;
    _phoneController.text = user.phone;

    // Add listeners to all controllers to track if any field is modified
    List<TextEditingController> controllers = [
      _loginController,
      _passwordController,
      _emailController,
      _nameController,
      _cpfController,
      _rgController,
      _addressController,
      _cityController,
      _stateController,
      _phoneController,
    ];
    for (var controller in controllers) {
      controller.addListener(() {
        setState(() { isModified = true; });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Dados')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            // ... [Todos os seus campos HHTextField]
            Row(
              children: [
                HHButton(
                  label: 'Alterar',
                  onPressed: isModified ? () async {
                    UserModel user = UserModel(
                      // preencha todos os campos do usuário aqui
                    );
                    await _dbService.editUser(user);
                  } : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
*/