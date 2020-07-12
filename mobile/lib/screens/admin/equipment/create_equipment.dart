import 'package:flutter/material.dart';
import 'package:mobile/widgets/image_uploader.dart';

class CreateEquipmentScreen extends StatefulWidget {
  static final String routeName = "/createEquipment";

  const CreateEquipmentScreen({Key key}) : super(key: key);

  @override
  _CreateEquipmentScreenState createState() => _CreateEquipmentScreenState();
}

class _CreateEquipmentScreenState extends State<CreateEquipmentScreen> {
  String name;
  String description;
  String imageURL;
  String status;
  int quantity;

  final _formKey = GlobalKey<FormState>();

  onUploadImageSuccess(String value) {
    print("Uplaoded: $value");
    setState(() {
      imageURL = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Create actor"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Container(
              width: 300,
              height: 150,
              child: ImageUploader(
                onSuccess: onUploadImageSuccess,
                disableChange: false,
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
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Name *',
                      ),
                      onSaved: (String value) {
                        {
                          name = value;
                        }
                      },
                      validator: (String value) {
                        return value.isEmpty ? 'Please enter name.' : null;
                      },
                    ),
                    DropdownButtonFormField(
                      items: ["Available", "Unavailable"].map((String status) {
                        return new DropdownMenuItem(
                            value: status,
                            child: Row(
                              children: <Widget>[
                                Text(status),
                              ],
                            ));
                      }).toList(),
                      onChanged: (newValue) {
                        status = newValue;
                      },
                      value: status,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                        filled: true,
                        fillColor: Colors.grey[200],
                        hintText: "Status",
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.numberWithOptions(
                          decimal: false, signed: false),
                      decoration: const InputDecoration(
                        labelText: 'Quantity *',
                      ),
                      onSaved: (String value) {
                        {
                          quantity = int.parse(value);
                        }
                      },
                      validator: (String value) {
                        try {
                          if (int.parse(value) <= 0) {
                            return 'Quantity > 0';
                          }
                        } catch (e) {
                          return 'Please enter valid number';
                        }
                        return value.isEmpty ? 'Please enter quantity.' : null;
                      },
                    ),
                    SizedBox.shrink(),
                    TextFormField(
                      minLines: 2,
                      maxLines: 4,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      onSaved: (String value) {
                        {
                          description = value;
                        }
                      },
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
                  print("$name - $quantity");
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
