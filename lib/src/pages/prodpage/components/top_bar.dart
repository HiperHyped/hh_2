import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/components/hh_button.dart';
import 'package:hh_2/src/config/common/components/hh_text_search.dart';
import 'package:hh_2/src/config/common/components/hh_uf_drop_down.dart';
import 'package:hh_2/src/config/common/components/hh_text_field.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/models/basket_model.dart';
import 'package:hh_2/src/models/history_model.dart';
import 'package:hh_2/src/models/user_model.dart';
import 'package:hh_2/src/pages/dimension/dimension_page.dart';
import 'package:hh_2/src/pages/photo/photo_dialog.dart';
import 'package:hh_2/src/pages/summary/summary_page.dart';
import 'package:hh_2/src/pages/user/edit_user.dart';
import 'package:hh_2/src/pages/user/sign_up.dart';
import 'package:hh_2/src/pages/start/start_screen.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/services/utils.dart';

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  const TopBar({
    Key? key, 
    //required this.onUFChanged
    }) : super(key: key);

  //final VoidCallback onUFChanged;
  Size get preferredSize => const Size.fromHeight(50);

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {

    UserModel? user = HHGlobals.HHUser;
    String initials = (user.name.split(' ')
            .map((l) => l[0])
            .take(2)
            .join())
      .toUpperCase();

    return AppBar(
          backgroundColor: HHColors.hhColorGreyMedium,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(6),
            child: Image.asset("assets/images/HH93.png", scale: 1,),
          ),
          actions: [
            //const SizedBox(width:40),

            ///////////////////SEARCH
            Container(
              padding: const EdgeInsets.all(4.0),
              width: 200,
              child: const HHTextSearch(icon: Icons.search, label: "Busca")
            ),

            IconButton(
              icon: const Icon(
                size: 30,
                color: Colors.grey,
                Icons.camera_alt_outlined
                ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>  PhotoDialog(),
                );
              },
            ),

            PopupMenuButton<int>(
              //padding: EdgeInsets.all(0.0),
              icon: CircleAvatar(
                backgroundColor: HHColors.hhColorFirst,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    Utils.getUserInitials(HHGlobals.HHUser.name),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  ),
                ),
              ),
              offset: Offset(0, 0),
              shape: RoundedRectangleBorder(
                side:BorderSide(
                  color: HHColors.hhColorFirst, 
                  style: BorderStyle.solid,
                  width: 4.0,
                  ),
                borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                PopupMenuItem<int>(
                  value: 0,
                  child: Container(
                    margin: const EdgeInsets.all(0.0),
                    padding: const EdgeInsets.all(0.0),
                    child: Text(
                      user.name,  // Substitua com a informação do usuário
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                        ),
                    ),
                  ),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          padding: const EdgeInsets.all(0.0),
                          child: Text(
                            user.email,  // Substitua com a informação do usuário
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          padding: const EdgeInsets.all(0.0),
                          child: Text(
                            "${user.city} /  ${user.uf}",  // Substitua com a informação do usuário
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: HHButton(
                    fontSize:16,
                    padding: 0,
                    label: "Editar Dados",
                    invert: true,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return EditUser();
                        },
                      );
                    },
                  ),
                ),
                PopupMenuItem<int>(
                  value: 3,
                  child: HHButton(
                    fontSize: 16,
                    padding: 0,
                    label: "Resumo",
                    invert: true,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                          return SummaryPage(); // Navegue para a SummaryPage como uma nova tela
                        }),
                      );
                    },
                  ),
                ),
                PopupMenuItem<int>(
                  value: 4,
                  child: HHButton(
                    fontSize: 16,
                    padding: 0,
                    label: "Análise",
                    invert: true,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                          return DimensionsPage(); // Navegue para a SummaryPage como uma nova tela
                        }),
                      );
                    },
                  ),
                ),
                PopupMenuItem<int>(
                  value: 5,
                  child: HHButton(
                    fontSize:16,
                    padding: 0,
                    label: "Log Out",
                    invert: true,
                    onPressed: () {
                      HHGlobals.HHUser = UserModel(password: "", login: "");
                      HHGlobals.HHBasket.value = BasketModel();
                      HHGlobals.HHUserBook.value.clear();
                      HHGlobals.HHUserHistory.value = HistoryModel();
                      HHGlobals.HHSuggestionList.value.clear();
                      HHGlobals.HHGridList.value.clear();
                      HHGlobals.HHPeriodicLists.value.clear();
                      Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (c) {return StartPage();})
                      );
                    }
                  ),
                ),
                
                // Adicione mais PopupMenuItems conforme a necessidade.
              ],
              onSelected: (int value) {
                // Handle action based on the selected value
              },
            ), 
           ],

        );
  }
}



            /*child: GestureDetector(
                child: Image.asset("assets/images/HH93.png", scale: 1,),
                onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (c) {return StartPage();})
                );
              },           
            ),*/

            //const SizedBox(width:30),

            //HH UF 
            /*SizedBox(
              width: 100,
              child: HHUFDropDown(onUFChanged: widget.onUFChanged), // Adicione esta linha
            ),*/
           

          /*title: GestureDetector(
            child: Text.rich(
              TextSpan(
                style: const TextStyle(
                  fontSize: 30,
                ),
                children: [
                  TextSpan(
                    text: 'Hiper',
                    style: TextStyle(
                      color: HHColors.hhColorFirst,
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
            onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (c) {return StartPage();})
                );
              },   
          ),*/



           //v2
            /*
            PopupMenuButton<int>(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Text('Usuário: ${user.name}'),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text('Email: ${user.email}'),
                ),
                PopupMenuItem(
                  value: 3,
                  child: Text('Telefone: ${user.phone}'),
                ),
              ],
              icon: CircleAvatar(
                backgroundColor: HHColors.hhColorFirst, // Altere a cor do fundo como preferir
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    ),
                  ),
              ),
              offset: Offset(0, 100), // Altere este valor para mover o menu
            ),
            */

            //v1
            /*IconButton(
              icon: CircleAvatar(
                backgroundColor: HHColors.hhColorFirst ,
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
              ),
              onPressed: () {
                _showUserDrawer(context, user);
              },
            ),*/

