// import 'package:flutter/material.dart';
// import 'package:hh_2/src/config/common/hh_globals.dart';
// import 'package:hh_2/src/models/category_model.dart';
// import 'package:hh_2/src/models/product_model.dart';
// import 'package:hh_2/src/pages/cat/cat_bar.dart';
// import 'package:hh_2/src/pages/grid/grid_tab.dart';
// import 'package:hh_2/src/pages/products/components/top_bar.dart';

// class ProdPage extends StatefulWidget {
//   ProdPage({
//     Key? key,
//     required this.vertical,
//   }) : super(key: key);

//   final bool vertical;

//   @override
//   State<ProdPage> createState() => _ProdPageState();
// }

// class _ProdPageState extends State<ProdPage> {
//   callback() {

//   }

//   @override
//   // void dispose() {
//   //   _controller.dispose();
//   //   super.dispose();
//   // }

//   void _updateMyTitle(String text) {  //////////////////////////////////////////////// Child to Parent
//     setState(() {
//       myTitle = text;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,

//         // TOP BAR 
//         appBar: const TopBar(),

//         body: Row(
//           children: [
//             //CATEGORIES - CAT BAR
//               CatBar(parentAction: _updateMyTitle), //////////////////////////////////// Child to Parent

//             // PRODUCT MODELS
//               GridTab(vertical: widget.vertical),
           
//           ],
//         ),
//       ),
//     );
//   }
// }


