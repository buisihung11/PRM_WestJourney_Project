import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/models/Actor.dart';
import 'package:mobile/widgets/info_item.dart';

class ActorDetailAgrument {
  final Actor actor;

  ActorDetailAgrument(this.actor);
}

class ActorDetailScreen extends StatefulWidget {
  static String routeName = "/actorDetail";

  const ActorDetailScreen({Key key}) : super(key: key);

  @override
  _ActorDetailScreenState createState() => _ActorDetailScreenState();
}

class _ActorDetailScreenState extends State<ActorDetailScreen> {
  File _image;
  StorageUploadTask _uploadTask;

  final picker = ImagePicker();
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://prm-journey-west.appspot.com/');

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      String filePath = 'images/${DateTime.now()}.png';
      final uploadTask =
          _storage.ref().child(filePath).putFile(File(pickedFile.path));

      final snapshot = await uploadTask.onComplete;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      print("Download Link: $downloadUrl");

      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final actor =
        (ModalRoute.of(context).settings.arguments as ActorDetailAgrument)
            .actor;
    return Scaffold(
        appBar: AppBar(
          title: Text(actor.name),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              _uploadTask != null
                  ?

                  /// Manage the task state and event subscription with a StreamBuilder
                  StreamBuilder<StorageTaskEvent>(
                      stream: _uploadTask.events,
                      builder: (_, snapshot) {
                        var event = snapshot?.data?.snapshot;

                        double progressPercent = event != null
                            ? event.bytesTransferred / event.totalByteCount
                            : 0;

                        return Column(
                          children: [
                            if (_uploadTask.isComplete) Text('🎉🎉🎉'),

                            if (_uploadTask.isPaused)
                              FlatButton(
                                child: Icon(Icons.play_arrow),
                                onPressed: _uploadTask.resume,
                              ),

                            if (_uploadTask.isInProgress)
                              FlatButton(
                                child: Icon(Icons.pause),
                                onPressed: _uploadTask.pause,
                              ),

                            // Progress bar
                            LinearProgressIndicator(value: progressPercent),
                            Text(
                                '${(progressPercent * 100).toStringAsFixed(2)} % '),
                          ],
                        );
                      })
                  : Container(
                      height: 150,
                      child: _image == null
                          ? RaisedButton(
                              onPressed: () {
                                getImage();
                              },
                              child: Text("Pick Iamge"),
                            )
                          : Image.file(_image),
                    ),
              Container(
                height: 150,
                child: Row(
                  children: <Widget>[
                    Image.network(actor.imageURL),
                    IconButton(icon: Icon(Icons.edit), onPressed: () {})
                  ],
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: EdgeInsets.all(20),
                  childAspectRatio: 3,
                  children: <Widget>[
                    Info(label: "Name", content: actor.name),
                    Info(label: "Gender", content: actor.gender),
                    Info(label: "Phone", content: actor.phone),
                    Info(label: "Username", content: actor.username),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
