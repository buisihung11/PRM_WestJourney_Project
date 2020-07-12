import 'package:flutter/material.dart';
import 'package:mobile/models/Actor.dart';
import 'package:mobile/utils/validators.dart';
import 'package:mobile/widgets/image_uploader.dart';
import 'package:mobile/widgets/input.dart';

class ActorDetailAgrument {
  final bool isUpdate;
  final Actor updateActor;

  ActorDetailAgrument({this.isUpdate = false, this.updateActor});
}

class ActorDetailScreen extends StatefulWidget {
  static final String routeName = "/createActor";

  const ActorDetailScreen({Key key}) : super(key: key);

  @override
  _ActorDetailScreenState createState() => _ActorDetailScreenState();
}

class _ActorDetailScreenState extends State<ActorDetailScreen> {
  Actor currentActor;

  @override
  void initState() {
    super.initState();
    final actorArg =
        (ModalRoute.of(context).settings.arguments as ActorDetailAgrument);
    setState(() {
      currentActor = actorArg.isUpdate ? actorArg.updateActor : Actor();
    });
  }

  final _formKey = GlobalKey<FormState>();

  onUploadImageSuccess(String value) {
    print("Uplaoded: $value");
    setState(() {
      currentActor.imageURL = value;
    });
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
    bool isUpdate =
        (ModalRoute.of(context).settings.arguments as ActorDetailAgrument)
            .isUpdate;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Create actor"),
        centerTitle: true,
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
                      disableChange: !isUpdate,
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
                            readOnly: !isUpdate,
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
                            readOnly: !isUpdate,
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
                            readOnly: !isUpdate,
                            onSaved: (String value) {
                              {
                                currentActor.name = value;
                              }
                            },
                          ),
                          DropdownButtonFormField(
                            items: ["Male", "Female"].map((String category) {
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
                          ),
                          Input(
                            keyboardType: TextInputType.text,
                            isRequired: true,
                            initialValue: phone,
                            onSaved: (String value) {
                              {
                                currentActor.phone = value;
                              }
                            },
                            readOnly: !isUpdate,
                            label: "Phone",
                          ),
                          SizedBox.shrink(),
                          Input(
                            minLines: 2,
                            maxLines: 4,
                            readOnly: !isUpdate,
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
                  RaisedButton(
                    color: Colors.blue,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        print("$username - $password");
                      }
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
