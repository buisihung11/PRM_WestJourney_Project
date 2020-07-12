import 'package:flutter/material.dart';
import 'package:mobile/constrants.dart';
import 'package:mobile/models/Equipment.dart';
import 'package:mobile/widgets/image_uploader.dart';
import 'package:mobile/widgets/info_item.dart';
import 'package:mobile/widgets/input.dart';

class EquipmentDetailAgrument {
  final Equipment equipment;

  EquipmentDetailAgrument(this.equipment);
}

class EquipmentDetailScreen extends StatefulWidget {
  static String routeName = "/equipmentDetail";
  final Equipment updateEquipment;
  final EditMode mode;
  const EquipmentDetailScreen(
      {Key key, this.updateEquipment, this.mode = EditMode.read})
      : super(key: key);

  @override
  EquipmentDetailScreenState createState() => EquipmentDetailScreenState();
}

class EquipmentDetailScreenState extends State<EquipmentDetailScreen> {
  Equipment currentEquipment;

  @override
  void initState() {
    super.initState();
    setState(() {
      switch (widget.mode) {
        case EditMode.create:
          currentEquipment = Equipment();
          break;
        case EditMode.read:
        case EditMode.update:
          currentEquipment = widget.updateEquipment != null
              ? widget.updateEquipment
              : Equipment();
          break;
        default:
          currentEquipment = Equipment();
      }
    });
  }

  final _formKey = GlobalKey<FormState>();

  onUploadImageSuccess(String value) {
    print("Upladed: $value");
    setState(() {
      currentEquipment.imageURL = value;
    });
  }

  _handleMenuOption(String value) {
    switch (value) {
      case 'update':
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => EquipmentDetailScreen(
            mode: EditMode.update,
            updateEquipment: currentEquipment,
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
        return "Create Equipment";
      case EditMode.read:
      case EditMode.update:
        return widget.updateEquipment?.name ?? "Cannot load title";
        break;
      default:
        return "Equipment";
    }
  }

  @override
  Widget build(BuildContext context) {
    EditMode mode = widget.mode;
    bool readOnly = mode == EditMode.read;

    return Scaffold(
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: currentEquipment == null
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
                        disableChange: readOnly,
                        initialImageURL: currentEquipment.imageURL,
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
                              keyboardType: TextInputType.text,
                              initialValue: currentEquipment.name,
                              isRequired: true,
                              label: "Name",
                              readOnly: readOnly,
                              onSaved: (String value) {
                                {
                                  currentEquipment.name = value;
                                }
                              },
                            ),
                            mode != EditMode.read
                                ? DropdownButtonFormField(
                                    items: ["Available", "Unavailable"]
                                        .map((String category) {
                                      return new DropdownMenuItem(
                                          value: category,
                                          child: Row(
                                            children: <Widget>[
                                              Text(category),
                                            ],
                                          ));
                                    }).toList(),
                                    onChanged: (newValue) {
                                      currentEquipment.status = newValue;
                                    },
                                    value: currentEquipment.status,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(10, 20, 10, 20),
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                      hintText: "Status",
                                    ),
                                  )
                                : Info(
                                    label: "Status",
                                    content: currentEquipment?.status,
                                  ),
                            Input(
                              keyboardType: TextInputType.number,
                              isRequired: true,
                              initialValue:
                                  currentEquipment.quantity?.toString(),
                              onSaved: (String value) {
                                {
                                  currentEquipment.quantity = int.parse(value);
                                }
                              },
                              readOnly: readOnly,
                              label: "Quantity",
                            ),
                            SizedBox.shrink(),
                            Input(
                              minLines: 2,
                              maxLines: 4,
                              readOnly: readOnly,
                              initialValue: currentEquipment.description,
                              keyboardType: TextInputType.text,
                              onSaved: (String value) {
                                {
                                  currentEquipment.description = value;
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
      ),
    );
  }
}
