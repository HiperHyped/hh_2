import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hh_2/src/config/common/var/hh_colors.dart';
//import 'package:hh_2/src/models/category_model.dart';
import 'package:hh_2/src/config/xml/xml_data.dart';

/*
class CatTab extends StatefulWidget {
  const CatTab({super.key});

  @override
  State<CatTab> createState() => _CatTabState();
}

List<CategoryModel> categories1 = [];
List<CategoryModel> categories2 = [];

class _CatTabState extends State<CatTab> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: HHColors.hhColorGreyLight,
            elevation: 0,
            leading: Padding(
                padding: const EdgeInsets.fromLTRB(6,12,6,12),
                child: Image.asset("assets/images/HH_logo_trans.png",),
              ),

            actions: <Widget>[
              //LOGO
              
              FutureBuilder(
                future: getCategoryFromXML(context),
                builder: (context,data){
                  if(data.hasData) {
                            categories1 = data.requireData;
                            for (var i = 0; i < categories1.length; i++) {
                              //log(categories1[i].sig0 + " " + categories1[i].sig1 + " "+ categories1[i].sig2);
                            }
 
                            return Expanded(
                              child: NotificationListener <ScrollNotification> (
                                onNotification: (t) {
                                      if (t is ScrollUpdateNotification) {
                                        //print(t.dragDetails);
                                      }
                                      return true;
                                },
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: categories1.length,
                                  itemBuilder:(context, index) => Text(categories1[index].sigla + " "),
                                ),
                              ),
                            );
                  }
                  else{
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],


        ),
      


        body: FutureBuilder(
          future: getCategoryFromXML(context),
          builder: (context,data){
            if(data.hasData) {
              categories2 = data.requireData;
              //print(categories2.toString());
              return SizedBox(
                child: NotificationListener <ScrollNotification> (
                  onNotification: (t) {
                        if (t is ScrollUpdateNotification) {
                          //print(t.dragDetails);
                        }
                        return true;
                  },
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: categories2.length,
                    itemBuilder:(context, index) => 
                      Stack(
                        children: [
                          //Text(categories2[index].sigla),
                          ListTile( 
                            leading: Image.asset("assets/images/cat/CAT_${categories2[index].sigla}.png"),
                            title: Text(categories2[index].cat1),
                            subtitle: Text(categories2[index].cat2),
                            //trailing: Text(categories2[index].sigla),
                            //trailing: Image.asset("assets/images/cat/CAT_${categories2[index].sigla}.png"),
                            isThreeLine: true,

                          ),
                          /*ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: categories2.length,
                            itemBuilder:(context, index) => Text(categories2[index].sig2)
                          )*/
                        ]
                    //Text(categories2[index].sigla),
                    ),
                ),
                ),
              );
            }
            else{
              return const Center(child: CircularProgressIndicator());
              }
          },
        ),


      ),
    );
  }
}*/