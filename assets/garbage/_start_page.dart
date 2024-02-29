  /*
 //IA 16-05-23
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double scaleFactor = MediaQuery.of(context).size.shortestSide / 500;

    return Scaffold(
      backgroundColor: HHColors.hhColorLightFirst,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //HIPER HYPED
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //SizedBox(height:100),
                    //Image.asset("assets/images/HH93.png", scale:2),
                    Image.asset("assets/images/HH93.png", scale: 2 * scaleFactor), 
                    Container(
                      alignment: const Alignment(0.0, 0.0),
                      /*padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 30,
                      ),*/
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
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 40,
                  ),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(45))),
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
                                //fontSize: 15,
                                //padding: 8,
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
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
  */

// FIM STARTPAGE


  // BOTAO ENTRAR
  /*onPressed: () async {
    String login = _loginController.text;
    String password = _passwordController.text;
    UserModel? user = await _dbUser.verifyUser(login, password);
    if (user != null) {
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
          */         
                        
  //Choice Button //IA 16-05-23
  /*
                        Row(
                          children: [
                            ToggleButtons(
                              color: HHColors.hhColorGreyDark,
                              fillColor: HHColors.hhColorFirst,
                              selectedColor: HHColors.hhColorWhite,
                              disabledColor: HHColors.hhColorBack,
                              borderColor: HHColors.hhColorGreyDark,
                              onPressed: (int index) {
                                setState(() {
                                  isVertical = index == 0;
                                  HHVar.isVertical = isVertical;
                                });
                              },
                              borderRadius: BorderRadius.circular(18),
                              isSelected: [HHVar.isVertical, !HHVar.isVertical],
                              children: const [
                                Text('  Vertical  '),
                                Text(' Horizontal '),
                              ],
                            ),
                            /*Expanded(
                              //width: 100,
                              child: HHUFDropDown(onUFChanged: _onUFChanged), // Adicione esta linha
                            ),*/
                          ],
                        ),*/



  /*onPressed: () async {
    String login = _loginController.text;
    String password = _passwordController.text;
    UserModel? user = await _dbUser.verifyUser(login, password);
    if (user != null) {
      // Se o usuário for verificado, redirecione para a página base
      HHGlobals.HHUser = user;

      await _dbBasket.createBasket(user.userId);
      print("SIGN IN: ${HHGlobals.HHUser}");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (c) {
          return BaseScreen(isVertical: isVertical);
        }),
      );
    } else {
      // Se as credenciais não forem válidas, mostre uma mensagem de erro
      showErrorDialog(context);
    }
  },*/


//OLD HHBUTTON
/*child: HHButton(
  label: "Entrar",
  onPressed: () {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (c) {
        return BaseScreen(isVertical: isVertical);
      }),
    );
  },
),*/

//  INICIO STARTPAGE
/* 
class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;


    return Scaffold(
      backgroundColor: HHColors.hhColorFirst,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //HIPER HYPED
              Expanded(
                child: Container(
                  alignment: const Alignment(0.0,0.0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 30,
                  ),
                  decoration: const BoxDecoration(
                        /*border: Border.all(
                        width: 3,
                        color: HHColors.hhColorGreyDark,
                        ),*/
                      //color: HHColors.hhColorGreyLight,
                      borderRadius: BorderRadius.all(Radius.circular(45))),
                  child: 

                  Text.rich(
                      TextSpan(
                        style: const TextStyle(
                          fontSize: 50,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Hiper',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            )
                          ),
                          TextSpan(
                            text: 'Hyped',
                            style: TextStyle(
                              color: HHColors.hhColorBack,
                              fontWeight: FontWeight.bold,
                            )
                          )
      
                        ]
                      ),
                      ),
        
                ),
              ),


              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 40,
                  ),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(45))),
              
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                    
                      //ENTRAR
                      /*SizedBox(
                        height: 50,
                        width: 200,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                                )
                              ),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (c) {
                                return BaseScreen();
                                }
                              )
                            );
                          },
                          child: Text(
                            'Entrar',
                            style: TextStyle(
                              fontSize: 18,
                              color: HHColors.hhColorWhite,
                            ),
                          ),
                        ),
                      ),*/
                      SizedBox(
                        height: 50,
                        width: 200,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          )),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (c) {
                                return const BaseScreen(vertical: true);
                              }),
                            );
                          },
                          child: Text(
                            'Vertical',
                            style: TextStyle(
                              fontSize: 18,
                              color: HHColors.hhColorWhite,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8), // Espaço entre os botões
                      SizedBox(
                        height: 50,
                        width: 150,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          )),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (c) {
                                return const BaseScreen(vertical: false);
                              }),
                            );
                          },
                          child: Text(
                            'Horizontal',
                            style: TextStyle(
                              fontSize: 18,
                              color: HHColors.hhColorWhite,
                            ),
                          ),
                        ),
                      ),
                      //SizedBox(height: 20),
                      //UF
                      //HHUFDropDown(),
                    ],  
                  )  
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
// FIM STARTPAGE