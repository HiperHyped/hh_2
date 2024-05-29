import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hh_2/src/config/common/var/hh_address.dart';
import 'package:hh_2/src/models/ean_model.dart';


class HHUrlImage extends StatelessWidget {
  final EanModel product;
  final Function(double width, double height) onImageDimensions;

  const HHUrlImage({Key? key, required this.product, required this.onImageDimensions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imageUrl = "${HHAddress.urlDb}${product.sigla.substring(0,1)}/${product.sigla.substring(1,3)}/${product.sigla.substring(3)}/${product.imagem}";
    //print(imageUrl);
 
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => Container()
      
        /*Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.error),
              SelectableText('Erro: ${error.toString()}'),
            ],
          ),
        ),*/
    );
  }
}




//Versão 5   - SIMPLES FUNCIONANDO - sem rotação
/*
class HHUrlImage extends StatelessWidget {
  final EanModel product;
  final Function(double width, double height) onImageDimensions;

  const HHUrlImage({Key? key, required this.product, required this.onImageDimensions}) : super(key: key);

  @override
  
  Widget build(BuildContext context) {
    //https://hiperhypedbucket.s3.sa-east-1.amazonaws.com/db/
    //String imageUrl = "${HHAddress.urlDb}${product.sig0}/${product.sig1}/${product.sig2}/${product.imagem}";
    String imageUrl = "${HHAddress.urlDb}${product.sigla.substring(0,1)}/${product.sigla.substring(1,3)}/${product.sigla.substring(3)}/${product.imagem}";

    //print(imageUrl);
    
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container();
        //print('Error loading image from URL: $error');
        //return Center(child: Text('Error loading image'));
      },
      loadingBuilder: (context, child, loadingProgress) {
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
    );
  }
}
*/



//versão 8  - 07/06 - com problemas
/*
class HHUrlImage extends StatefulWidget {
  final EanModel product;
  final Function(double width, double height) onImageDimensions;

  const HHUrlImage({Key? key, required this.product, required this.onImageDimensions}) : super(key: key);

  @override
  _HHUrlImageState createState() => _HHUrlImageState();
}

class _HHUrlImageState extends State<HHUrlImage> {
  late Future<bool> imageExists;

  Future<bool> doesImageExist(String imageUrl) async {
    final response = await http.head(Uri.parse(imageUrl));

    return response.statusCode == 200;
  }

  @override
  void initState() {
    super.initState();

    String imageUrl = "${HHAddress.urlDb}${widget.product.sigla.substring(0,1)}/${widget.product.sigla.substring(1,3)}/${widget.product.sigla.substring(3)}/${widget.product.imagem}";
    imageExists = doesImageExist(imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: imageExists,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data!) {
          String imageUrl = "${HHAddress.urlDb}${widget.product.sigla.substring(0,1)}/${widget.product.sigla.substring(1,3)}/${widget.product.sigla.substring(3)}/${widget.product.imagem}";

          return Image.network(
            imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
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
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.broken_image_outlined, size: 50, color: HHColors.hhColorGreyDark),
                //Text('Sem Imagem', style: TextStyle(fontSize: 20)),
              ],
            ),
          );
        }
      },
    );
  }
}
*/



//// v7 com ROTAÇÂO
/*
class HHUrlImage extends StatefulWidget {
  final EanModel product;
  final Function(double width, double height) onImageDimensions;

  const HHUrlImage({Key? key, required this.product, required this.onImageDimensions}) : super(key: key);

  @override
  _HHUrlImageState createState() => _HHUrlImageState();
}

class _HHUrlImageState extends State<HHUrlImage> {
  ImageInfo? imageInfo;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() async {
    String imageUrl = "${HHAddress.urlDb}${widget.product.sig0}/${widget.product.sig1}/${widget.product.sig2}/${widget.product.imagem}";

    final ImageStream stream = Image.network(imageUrl).image.resolve(ImageConfiguration());
    final Completer<ImageInfo> completer = Completer<ImageInfo>();
    final listener = ImageStreamListener((ImageInfo info, bool _) {
      if (!completer.isCompleted) {
        completer.complete(info);
      }
    });

    stream.addListener(listener);
    imageInfo = await completer.future;

    final bool shouldRotate = HHVar.rot90 && imageInfo!.image.width > imageInfo!.image.height;
    if (shouldRotate) {
      widget.onImageDimensions(imageInfo!.image.height.toDouble(), imageInfo!.image.width.toDouble());
    } else {
      widget.onImageDimensions(imageInfo!.image.width.toDouble(), imageInfo!.image.height.toDouble());
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (imageInfo == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    final bool shouldRotate = HHVar.rot90 && imageInfo!.image.width > imageInfo!.image.height;
    String imageUrl = "${HHAddress.urlDb}${widget.product.sig0}/${widget.product.sig1}/${widget.product.sig2}/${widget.product.imagem}";

     return Align(
     alignment: Alignment.bottomCenter,
     child: FittedBox(
      fit: BoxFit.cover,
      child: shouldRotate
        ? Transform.rotate(
            angle: pi / 2,
            alignment: Alignment.center,
            child: Image.network(
              imageUrl,
              //fit: BoxFit.cover,
            ),
          )
        : Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
   );
  }
}
*/

// versão 6 - ROTATED

/*class HHUrlImage extends StatefulWidget {
  final EanModel product;
  final Function(double width, double height) onImageDimensions;

  const HHUrlImage({Key? key, required this.product, required this.onImageDimensions}) : super(key: key);

  @override
  _HHUrlImageState createState() => _HHUrlImageState();
}

class _HHUrlImageState extends State<HHUrlImage> {
  ImageInfo? imageInfo;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() async {
    String imageUrl = "${HHAddress.urlDb}${widget.product.sig0}/${widget.product.sig1}/${widget.product.sig2}/${widget.product.imagem}";

    final ImageStream stream = Image.network(imageUrl).image.resolve(ImageConfiguration());
    final Completer<ImageInfo> completer = Completer<ImageInfo>();
    final listener = ImageStreamListener((ImageInfo info, bool _) {
      if (!completer.isCompleted) {
        completer.complete(info);
      }
    });

    stream.addListener(listener);
    imageInfo = await completer.future;

    final bool shouldRotate = HHVar.rot90 && imageInfo!.image.width > imageInfo!.image.height;
    if (shouldRotate) {
      widget.onImageDimensions(imageInfo!.image.height.toDouble(), imageInfo!.image.width.toDouble());
    } else {
      widget.onImageDimensions(imageInfo!.image.width.toDouble(), imageInfo!.image.height.toDouble());
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (imageInfo == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    final bool shouldRotate = HHVar.rot90 && imageInfo!.image.width > imageInfo!.image.height;
    String imageUrl = "${HHAddress.urlDb}${widget.product.sig0}/${widget.product.sig1}/${widget.product.sig2}/${widget.product.imagem}";

    return shouldRotate
      ? RotatedBox(
          quarterTurns: 1, // rotate 90 degrees clockwise
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        )
      : Image.network(
          imageUrl,
          fit: BoxFit.cover,
        );
  }
}
*/




//Versão 4
/*class HHUrlImage extends StatefulWidget {
  final EanModel product;
  final Function(double width, double height) onImageDimensions;

  const HHUrlImage({Key? key, required this.product, required this.onImageDimensions})
      : super(key: key);

  @override
  _HHUrlImageState createState() => _HHUrlImageState();
}

class _HHUrlImageState extends State<HHUrlImage> {
  late final String imageUrl;
  late final Image image;


  @override
  void initState() {
    super.initState();
    updateImage();
  }

  @override
  void didUpdateWidget(covariant HHUrlImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.product != widget.product) {
      updateImage();
    }
  }

  void updateImage() {
    imageUrl =
        "https://hiperhypedbucket.s3.sa-east-1.amazonaws.com/db/${widget.product.sig0}/${widget.product.sig1}/${widget.product.sig2}/${widget.product.imagem}";
    image = Image.network(imageUrl, fit: BoxFit.cover);
    setState(() {});
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
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}*/

//Versão 3
/*class HHUrlImage extends StatefulWidget {
  final EanModel product;
  final Function(double width, double height) onImageDimensions;

  const HHUrlImage({Key? key, required this.product, required this.onImageDimensions})
      : super(key: key);

  @override
  _HHUrlImageState createState() => _HHUrlImageState();
}

class _HHUrlImageState extends State<HHUrlImage> {

  
  late final String imageUrl;
  late final Image image;

  @override
  void initState() {
    super.initState();
    imageUrl =
        "https://hiperhypedbucket.s3.sa-east-1.amazonaws.com/db/${widget.product.sig0}/${widget.product.sig1}/${widget.product.sig2}/${widget.product.imagem}";
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
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}*/

//Versão 2
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


//Versão 1
/*class HHUrlImage extends StatelessWidget {
  final EanModel product;
  final Function(double width, double height) onImageDimensions;

  const HHUrlImage({Key? key, required this.product, required this.onImageDimensions}) : super(key: key);

  @override
  
  Widget build(BuildContext context) {
    String imageUrl = "https://hiperhypedbucket.s3.sa-east-1.amazonaws.com/db/${product.sig0}/${product.sig1}/${product.sig2}/${product.imagem}";
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


