import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/repositories/firebase.dart';

class ImageUploader extends StatefulWidget {
  ImageUploader(
      {Key key,
      this.initialImageURL,
      this.disableChange = true,
      this.onSuccess})
      : super(key: key);
  final String initialImageURL;
  final bool disableChange;
  final Function onSuccess;
  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  final picker = ImagePicker();
  final FirebaseRepository firebaseRepository = FirebaseRepository();
  String uploadImageURL;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // upload image
      // set the uploadImage link
      String url = await firebaseRepository.uploadFile(
          uploadFile: File(pickedFile.path));
      if (widget.onSuccess != null) {
        widget.onSuccess(url);
      }
      setState(() {
        uploadImageURL = url;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = uploadImageURL ?? widget.initialImageURL;
    return Container(
      child: imageUrl != null
          ? Row(
              children: <Widget>[
                Image.network(imageUrl),
                !widget.disableChange
                    ? IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          getImage();
                        })
                    : SizedBox.shrink(),
              ],
            )
          : Container(
              width: 70,
              height: 50,
              child: widget.disableChange
                  ? Image.asset(
                      'assets/images/no_image.jpg',
                      fit: BoxFit.cover,
                    )
                  : RaisedButton(
                      onPressed: () {
                        getImage();
                      },
                      child: Text("Pick Image"),
                    ),
            ),
    );
  }
}
