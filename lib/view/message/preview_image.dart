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
          child: Hero(
            tag: tag.toString(),
            child: Image.network(
              imageUrl.toString(),
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
