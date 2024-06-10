/*import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hh_2/src/config/db/_aws_config.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:http/http.dart';


class HHS3Image extends StatefulWidget {
  final EanModel product;
  final Function(double width, double height) onImageDimensions;

  HHS3Image({Key? key, required this.product, required this.onImageDimensions}) : super(key: key);

  @override
  _HHS3ImageState createState() => _HHS3ImageState();
}

class _HHS3ImageState extends State<HHS3Image> {
  Uint8List? _imageData;

  @override
  void initState() {
    super.initState();
    //_loadImageUrl();
    _loadImageFromS3();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getImageDimensions();
    });
  }


  void _loadImageFromS3() async {
    //s3://hiperhypedbucket/db/B/BA/CG/4002103000013.png
    //https://hiperhypedbucket.s3.sa-east-1.amazonaws.com/db
    //String signedUrl = await AwsConfiguration.awsS3PrivateFlutter.getObjectWithSignedRequest(key: key);
    //print('Signed URL: $signedUrl');
    
    //https://hiperhypedbucket.s3.sa-east-1.amazonaws.com/
    String key = 'db/${widget.product.sig0}/${widget.product.sig1}/${widget.product.sig2}/${widget.product.imagem}';
    print('Loading image from S3 with key: $key');
 
    try {
      Response res = await AwsConfiguration.awsS3PrivateFlutter.getObjectWithSignedRequest(key: key);

      if (res != null) {
        print('S3 response status code: ${res.statusCode}');
        if (res.statusCode == 200) {
          setState(() {
            _imageData = res.bodyBytes;
          });
          print('Image data loaded successfully');
        } else {
          print('Failed to load image data');
        }
      } else {
        print('S3 response is null');
      }
    } catch (e, stackTrace) {
      print('Error loading image from S3: $e');
      print(stackTrace);
    }
  }

  Image _loadImageUrl() {
    String url = 'https://hiperhypedbucket.s3.sa-east-1.amazonaws.com/db/${widget.product.sig0}/${widget.product.sig1}/${widget.product.sig2}/${widget.product.imagem}';
    return Image.network(url);
  }


  void _getImageDimensions() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    widget.onImageDimensions(size.width, size.height);
    print('Image dimensions: width=${size.width}, height=${size.height}');
  }

  @override
  Widget build(BuildContext context) {
    if (_imageData != null) {
      return Image.memory(
        _imageData!,
        fit: BoxFit.fitWidth,
        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
          print('Error building image: $exception');
          return Container();
        },
      );
    } else {
      return CircularProgressIndicator();
    }
  }
}*/



  /*void _loadImageFromS3() async {
    //String key = 'db/B/BA/CG/${widget.imagePath}';
    String key = 'db/${widget.product.sig0}/${widget.product.sig1}/${widget.product.sig2}/${widget.product.imagem}';
    print('Loading image from S3 with key: $key');
    Response res = await AwsConfiguration.awsS3PrivateFlutter.getObjectWithSignedRequest(key: key);

    if (res != null) {
      print('S3 response status code: ${res.statusCode}');
      if (res.statusCode == 200) {
        setState(() {
          _imageData = res.bodyBytes;
        });
        print('Image data loaded successfully');
      } else {
        print('Failed to load image data');
      }
    } else {
      print('S3 response is null');
    }
  }*/

/*class HHS3Image extends StatefulWidget {
  final EanModel product;
  final Function(double width, double height) onImageDimensions;

  HHS3Image({Key? key, required this.product, required this.onImageDimensions}) : super(key: key);

  @override
  _HHS3ImageState createState() => _HHS3ImageState();
}

class _HHS3ImageState extends State<HHS3Image> {
  Uint8List? _imageData;

  @override
  void initState() {
    super.initState();
    _loadImageFromS3();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getImageDimensions();
    });
  }

  void _loadImageFromS3() async {
    //String key = 'db/B/BA/CG/${widget.imagePath}';
    String key = 'db/${widget.product.sig0}/${widget.product.sig1}/${widget.product.sig2}/${widget.product.imagem}';
    print(key);
    Response res = await AwsConfiguration.awsS3PrivateFlutter.getObjectWithSignedRequest(key: key);

    if (res != null && res.statusCode == 200) {
      setState(() {
        _imageData = res.bodyBytes;
      });
    }
  }

  void _getImageDimensions() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    widget.onImageDimensions(size.width, size.height);
  }

  @override
  Widget build(BuildContext context) {
    if (_imageData != null) {
      return Image.memory(
        _imageData!,
        fit: BoxFit.fitWidth,
        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
          return Container();
        },
      );
    } else {
      return CircularProgressIndicator();
    }
  }
}*/
