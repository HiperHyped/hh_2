/*import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/var/hh_address.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/config/common/var/hh_var.dart';
*/
/*
class HHUrlCatImage extends StatefulWidget {
  //final CategoryModel cat;
  final Function(double width, double height) onImageDimensions;

  const HHUrlCatImage({Key? key, required this.cat, required this.onImageDimensions})
      : super(key: key);

  @override
  _HHUrlCatImageState createState() => _HHUrlCatImageState();
}

class _HHUrlCatImageState extends State<HHUrlCatImage> {

  //Versão 4
  late final String imageUrl;
  late final Image image;

  @override
  void initState() {
    super.initState();
    //https://hiperhypedbucket.s3.sa-east-1.amazonaws.com/cat/
    imageUrl = "${HHAddress.urlCat}CAT_${widget.cat.sigla}.png";
    image = Image.network(imageUrl, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: precacheImage(image.image, context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            print('Error loading image from URL: ${snapshot.error}');
            return Center(child: Text('Error loading image'));
          } else {
            return image;
          }
        } else {
          return const Center(child: Padding(
            padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
          ));
        }
      },
    );
  }
}*/



//Versão 3
/*class HHUrlCatImage extends StatelessWidget {
  final CategoryModel cat;
  final Function(double width, double height) onImageDimensions;

  const HHUrlCatImage({Key? key, required this.cat, required this.onImageDimensions}) : super(key: key);

  @override
  //Versão 2
  Widget build(BuildContext context) {
    String imageUrl = 
    "https://hiperhypedbucket.s3.sa-east-1.amazonaws.com/cat/CAT_${cat.sigla}.png";
    print(imageUrl);
     return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        print('Error loading image from URL: $error');
        return Center(child: Text('Error loading image'));
      },
    );
  }
}*/

  //Versão 1
/*  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        print('Error loading image from URL: $error');
        return Center(child: Text('Error loading image'));
      },
    );
  }
}*/


