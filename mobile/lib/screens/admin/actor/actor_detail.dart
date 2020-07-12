import 'package:flutter/material.dart';
import 'package:mobile/constrants.dart';
import 'package:mobile/models/Actor.dart';
import 'package:mobile/utils/validators.dart';
import 'package:mobile/widgets/image_uploader.dart';
import 'package:mobile/widgets/info_item.dart';
import 'package:mobile/widgets/input.dart';

class ActorDetailScreen extends StatefulWidget {
  static final String routeName = "/createActor";
  final Actor updateActor;
  final EditMode mode;
  const ActorDetailScreen(
      {Key key, this.updateActor, this.mode = EditMode.read})
      : super(key: key);

  @override
  _ActorDetailScreenState createState() => _ActorDetailScreenState();
}

class _ActorDetailScreenState extends State<ActorDetailScreen> {
  Actor currentActor;

  @override
  void initState() {
    super.initState();
    setState(() {
      switch (widget.mode) {
        case EditMode.create:
          currentActor = Actor();
          break;
        case EditMode.read:
        case EditMode.update:
          currentActor =
              widget.updateActor != null ? widget.updateActor : Actor();
          break;
        default:
          currentActor = Actor();
      }
    });
  }

  final _formKey = GlobalKey<FormState>();

  onUploadImageSuccess(String value) {
    print("Uplaoded: $value");
    setState(() {
      currentActor.imageURL = value;
    });
  }

  _handleMenuOption(String value) {
    switch (value) {
      case 'update':
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ActorDetailScreen(
            mode: EditMode.update,
            updateActor: currentActor,
          ),
        ));
        break;
      case 'delete':
        break;
      default:
        break;
    }
  }

  _handleSubmit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      // print("$username - $password");
    }
  }

  String _getTitle() {
    switch (widget.mode) {
      case EditMode.create:
        return "Create Actor";
      case EditMode.read:
      case EditMode.update:
        return widget.updateActor?.name ?? "Cannot load title";
        break;
      default:
        return "Actor";
    }
  }

  @override
  Widget build(BuildContext context) {
    String username = currentActor.username;
    String password = currentActor.password;
    String name = currentActor.name;
    String gender = currentActor.gender;
    String phone = currentActor.phone;
    String description = currentActor.description;
    String imageURL = currentActor.imageURL;
    EditMode mode = widget.mode;
    bool readOnly = mode == EditMode.read;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(_getTitle()),
        centerTitle: true,
        actions: <Widget>[
          mode == EditMode.read
              ? PopupMenuButton<String>(
                  onSelected: _handleMenuOption,
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: "update",
                      child: Text('Update'),
                    ),
                    const PopupMenuItem<String>(
                      value: "delete",
                      child: Text('Delete'),
                    ),
                  ],
                )
              : IconButton(icon: Icon(Icons.done), onPressed: _handleSubmit)
        ],
      ),
      body: currentActor == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Container(
                    width: 300,
                    height: 150,
                    child: ImageUploader(
                      onSuccess: onUploadImageSuccess,
                      disableChange: mode == EditMode.read,
                      initialImageURL: imageURL,
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: Form(
                      key: _formKey,
                      autovalidate: true,
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 2,
                        crossAxisSpacing: 10,
                        children: <Widget>[
                          Input(
                            keyboardType: TextInputType.emailAddress,
                            initialValue: username,
                            isRequired: true,
                            readOnly: mode == EditMode.read,
                            onSaved: (String value) {
                              {
                                currentActor.username = value;
                              }
                            },
                            validator: validateEmail,
                            label: "Username",
                          ),
                          Input(
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            isRequired: true,
                            readOnly: readOnly,
                            initialValue: password,
                            onSaved: (String value) {
                              {
                                currentActor.password = value;
                              }
                            },
                            label: "Password",
                          ),
                          Input(
                            keyboardType: TextInputType.text,
                            initialValue: name,
                            isRequired: true,
                            label: "Name",
                            readOnly: readOnly,
                            onSaved: (String value) {
                              {
                                currentActor.name = value;
                              }
                            },
                          ),
                          mode != EditMode.read
                              ? DropdownButtonFormField(
                                  items:
                                      ["Male", "Female"].map((String category) {
                                    return new DropdownMenuItem(
                                        value: category,
                                        child: Row(
                                          children: <Widget>[
                                            Text(category),
                                          ],
                                        ));
                                  }).toList(),
                                  onChanged: (newValue) {
                                    currentActor.gender = newValue;
                                  },
                                  value: gender,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(10, 20, 10, 20),
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    hintText: "Gender",
                                  ),
                                )
                              : Info(label: "Gender", content: gender),
                          Input(
                            keyboardType: TextInputType.text,
                            isRequired: true,
                            initialValue: phone,
                            onSaved: (String value) {
                              {
                                currentActor.phone = value;
                              }
                            },
                            readOnly: readOnly,
                            label: "Phone",
                          ),
                          SizedBox.shrink(),
                          Input(
                            minLines: 2,
                            maxLines: 4,
                            readOnly: readOnly,
                            initialValue: description,
                            keyboardType: TextInputType.text,
                            onSaved: (String value) {
                              {
                                currentActor.description = value;
                              }
                            },
                            label: "Description",
                          ),
                        ],
                      ),
                    ),
                  ),
                  mode != EditMode.read
                      ? RaisedButton(
                          color: Colors.blue,
                          onPressed: () {
                            _handleSubmit();
                          },
                          child: Text(
                            'Submit',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
    );
  }
}
