import 'package:flutter/material.dart';

class ImageNetwork extends StatelessWidget {
  const ImageNetwork({Key key, this.imageURL}) : super(key: key);
  final String imageURL;

  Widget _getImage() {
    try {
      return Image.network(imageURL, fit: BoxFit.cover);
    } catch (e) {
      return Text("Cannot get that image");
    }
  }

  @override
  Widget build(BuildContext context) {
    return imageURL != null
        ? _getImage()
        : Image.asset(
            'assets/images/no_image.jpg',
            fit: BoxFit.cover,
          );
  }
}
