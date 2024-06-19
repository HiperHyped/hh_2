import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/components/hh_text_search.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
import 'package:hh_2/src/models/basket_model.dart';
import 'package:hh_2/src/models/history_model.dart';
import 'package:hh_2/src/models/user_model.dart';
import 'package:hh_2/src/pages/dimension/dimension_page.dart';
import 'package:hh_2/src/pages/image/uni_image_dialog.dart';
import 'package:hh_2/src/pages/settings/setting_page.dart';
import 'package:hh_2/src/pages/summary/summary_page.dart';
import 'package:hh_2/src/pages/user/edit_user.dart';
import 'package:hh_2/src/pages/start/start_screen.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/services/utils.dart';
import 'package:image_picker/image_picker.dart';

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
    /*String initials = (user.name.split(' ')
            .map((l) => l[0])
            .take(2)
            .join())
      .toUpperCase();*/

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
              width: 180,
              child: const HHTextSearch(icon: Icons.search, label: "Busca")
            ),

            // Upload de Imagem
            IconButton(
              padding: EdgeInsets.all(4.0),
              icon: const Icon(
                Icons.image_search_outlined,
                size: 30,
                color: Colors.grey,
              ),
              onPressed: () {
                UniImageDialog.getImage(context, source: ImageSource.gallery);
              },
            ),

            // Photo 
            IconButton(
              padding: const EdgeInsets.all(4.0),
              icon: const Icon(
                size: 30,
                color: Colors.grey,
                Icons.camera_alt_outlined
                ),
              onPressed: () {
                UniImageDialog.getImage(context, source: ImageSource.camera);
              },
            ),

            PopupMenuButton<int>(
              icon: CircleAvatar(
                backgroundColor: HHColors.hhColorFirst,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    Utils.getUserInitials(HHGlobals.HHUser.name),
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              offset: Offset(0, 0),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: HHColors.hhColorFirst,
                  style: BorderStyle.solid,
                  width: 4.0,
                ),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                PopupMenuItem<int>(
                  value: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)),
                          Text(user.email, style: const TextStyle(color: Colors.black, fontSize: 16)),
                          Text("${user.city} / ${user.uf}", style: const TextStyle(color: Colors.black, fontSize: 16)),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: HHColors.hhColorFirst),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return EditUser();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.assignment_outlined, color: HHColors.hhColorFirst),
                      SizedBox(width: 5),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (BuildContext context) {
                                return SummaryPage(); // Navegue para a SummaryPage como uma nova tela
                              }),
                            );
                          },
                          child: Text("Resumo", style: TextStyle(color: HHColors.hhColorFirst, fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),

                PopupMenuItem<int>(
                  value: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.bar_chart_outlined, color: HHColors.hhColorFirst),
                      SizedBox(width: 5),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (BuildContext context) {
                                return DimensionsPage(); // Navegue para a DimensionsPage como uma nova tela
                              }),
                            );
                          },
                          child: Text("Análise", style: TextStyle(color: HHColors.hhColorFirst, fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<int>(
                  value: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.settings_outlined, color: HHColors.hhColorFirst),
                      SizedBox(width: 5),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (BuildContext context) {
                                return SettingsPage(); // Navegue para a SettingsPage como uma nova tela
                              }),
                            );
                          },
                          child: Text("Preferências", style: TextStyle(color: HHColors.hhColorFirst, fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<int>(
                  value: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.logout, color: HHColors.hhColorFirst),
                      SizedBox(width: 5),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            HHGlobals.HHUser = UserModel(password: "", login: "");
                            HHGlobals.HHBasket.value = BasketModel();
                            HHGlobals.HHUserBook.value.clear();
                            HHGlobals.HHUserHistory.value = HistoryModel();
                            HHGlobals.HHSuggestionList.value.clear();
                            HHGlobals.HHGridList.value.clear();
                            HHGlobals.HHPeriodicLists.value.clear();
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (c) {
                              return StartPage();
                            }));
                          },
                          child: Text("Log Out", style: TextStyle(color: HHColors.hhColorFirst, fontSize: 16)),
                        ),
                      ),
                    ],
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

