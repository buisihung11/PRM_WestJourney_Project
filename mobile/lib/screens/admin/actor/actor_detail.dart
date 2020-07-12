import 'package:flutter/material.dart';
import 'package:mobile/models/Actor.dart';
import 'package:mobile/widgets/info_item.dart';
import 'package:mobile/widgets/image_uploader.dart';

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
  @override
  void initState() {
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
              Container(
                width: 300,
                height: 200,
                child: ImageUploader(
                  initialImageURL: actor.imageURL,
                ),
              ),
              // Container(
              //   height: 150,
              //   child: Row(
              //     children: <Widget>[
              //       Image.network(actor.imageURL),
              //       IconButton(icon: Icon(Icons.edit), onPressed: () {})
              //     ],
              //   ),
              // ),
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
