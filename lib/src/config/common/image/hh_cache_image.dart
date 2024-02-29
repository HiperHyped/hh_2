import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class HHCacheImage extends StatelessWidget {
  final String imageUrl;

  HHCacheImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
