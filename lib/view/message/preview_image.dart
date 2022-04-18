import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PreviewImage extends StatelessWidget {
  const PreviewImage({
    Key? key,
    required this.imageUrl,
    required this.tag,
  }) : super(key: key);

  final String imageUrl;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: CachedNetworkImage(
            imageUrl: imageUrl.toString(),
            placeholder: (context, url) => new CircularProgressIndicator(),
            errorWidget: (context, url, error) => new Icon(Icons.error),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
