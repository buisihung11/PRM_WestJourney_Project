import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/Actor.dart';
import 'package:mobile/models/Charactor.dart';
import 'package:mobile/repositories/actor.dart';
import 'package:mobile/repositories/firebase.dart';
import 'package:mobile/utils/index.dart';
import 'package:mobile/widgets/image_network.dart';
import 'package:mobile/widgets/input.dart';
import 'package:smart_select/smart_select.dart';

class EditCharacter extends StatefulWidget {
  const EditCharacter({Key key, this.initialValue}) : super(key: key);
  final Charactor initialValue;
  @override
  _EditCharacterState createState() => _EditCharacterState();
}

class _EditCharacterState extends State<EditCharacter> {
  Charactor updateCharactor;
  List<SmartSelectOption<Actor>> actorSrc = [];
  bool _loadingActor = true;
  dynamic err;
  final _formKey = GlobalKey<FormState>();
  final ActorRepository actorRepository = ActorRepository();
  final FirebaseRepository firebaseRepository = FirebaseRepository();
  @override
  void initState() {
    super.initState();
    setState(() {
      updateCharactor = widget.initialValue ?? Charactor();
    });
    _loadActorSrc();
  }

  _handleReturn() {
    // return List<Equipment>
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Navigator.of(context).pop(updateCharactor);
    } else {
      print("Error when return");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Edit Characters"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.done), onPressed: _handleReturn)
        ],
      ),
      body: Form(
        key: _formKey,
        child: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15),
                child: Input(
                  label: "Name",
                  isRequired: true,
                  onSaved: (val) {
                    updateCharactor.name = val;
                  },
                  initialValue: updateCharactor.name,
                  keyboardType: TextInputType.text,
                ),
              ),
              updateCharactor.descriptionFileURL == null
                  ? Text("Please choose file")
                  : FlatButton(
                      onPressed: () async {
                        await openLink(updateCharactor.descriptionFileURL);
                      },
                      child: Text(
                        "Get file",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
              RaisedButton(
                onPressed: () async {
                  final file = await FilePicker.getFile(
                    type: FileType.custom,
                    allowedExtensions: ['txt', 'pdf', 'doc'],
                  );
                  String url = await firebaseRepository.uploadFile(
                      uploadFile: file, isImage: false);
                  setState(() {
                    updateCharactor.descriptionFileURL = url;
                  });
                  print(url);
                },
                child: Text("Pick file", style: TextStyle(color: Colors.white)),
                color: Colors.blue,
              ),
              SmartSelect<Actor>.multiple(
                title: 'Actors',
                value: updateCharactor.actors ?? [],
                isTwoLine: true,
                isLoading: _loadingActor,
                options: actorSrc,
                modalConfig: SmartSelectModalConfig(useFilter: true),
                choiceType: SmartSelectChoiceType.checkboxes,
                choiceConfig: SmartSelectChoiceConfig<Actor>(
                  isGrouped: true,
                  secondaryBuilder: (context, item) => CircleAvatar(
                    backgroundImage: NetworkImage(item.value.imageURL),
                  ),
                ),
                onChange: (val) {
                  // set quantity = 1 for every selected item
                  setState(() {
                    updateCharactor.actors = val;
                  });
                },
              ),

              // render selected equipment
              // updateCharactor == null
              //     ? Text("Loading...")
              //     : Expanded(
              //         child: Padding(
              //           padding: const EdgeInsets.all(10.0),
              //           child: Column(
              //             children: (updateCharactor.actors == null ||
              //                     updateCharactor.actors.length == 0)
              //                 ? Text("No actor")
              //                 : updateCharactor.actors
              //                     .map<Widget>(
              //                       (e) => Card(
              //                         child: ListTile(
              //                           leading: CircleAvatar(
              //                             child: ImageNetwork(
              //                               imageURL: e.imageURL,
              //                             ),
              //                           ),
              //                           title: Text("${e.name}"),
              //                           subtitle: Text(e.gender.toString()),
              //                         ),
              //                       ),
              //                     )
              //                     .toList(),
              //           ),
              //         ),
              //       )
            ],
          ),
        ),
      ),
    );
  }

  _loadActorSrc() async {
    setState(() {
      _loadingActor = true;
      err = null;
    });
    try {
      List<Actor> result = await actorRepository.getActors();
      setState(() {
        actorSrc = SmartSelectOption.listFrom<Actor, dynamic>(
          source: result,
          value: (index, item) => item,
          title: (index, item) => (item as Actor).name,
          subtitle: (index, item) => (item as Actor).gender,
          group: (index, item) => (item as Actor).gender,
        );
      });
    } catch (e) {
      setState(() {
        err = e;
      });
    } finally {
      setState(() {
        _loadingActor = false;
      });
    }
  }
}
