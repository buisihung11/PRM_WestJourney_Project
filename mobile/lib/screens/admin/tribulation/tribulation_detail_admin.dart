import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobile/constrants.dart';
import 'package:mobile/models/Actor.dart';
import 'package:mobile/models/Charactor.dart';
import 'package:mobile/models/Equipment.dart';
import 'package:mobile/models/Tribulation.dart';
import 'package:mobile/repositories/tribulation.dart';
import 'package:mobile/screens/admin/tribulation/edit_character.dart';
import 'package:mobile/screens/admin/tribulation/edit_equipment.dart';
import 'package:mobile/screens/admin/tribulation_screen.dart';
import 'package:mobile/utils/dialog.dart';
import 'package:mobile/utils/index.dart';
import 'package:mobile/widgets/date_picker.dart';
import 'package:mobile/widgets/image_network.dart';
import 'package:mobile/widgets/input.dart';
import 'package:mobile/widgets/text_error.dart';
import 'package:progress_dialog/progress_dialog.dart';

class TribulationAdminDetail extends StatefulWidget {
  static String routename = "/tribulationDetail";
  final Tribulation tribulation;
  final String role;
  final EditMode mode;
  const TribulationAdminDetail(
      {Key key,
      @required this.tribulation,
      @required this.role,
      this.mode = EditMode.read})
      : super(key: key);

  @override
  _TribulationAdminDetailState createState() => _TribulationAdminDetailState();
}

class _TribulationAdminDetailState extends State<TribulationAdminDetail> {
  List<Charactor> characters;
  List<Equipment> equipments;
  Tribulation tribulationInfo;
  bool loading = true;
  dynamic err;
  ProgressDialog pr;
  final _formKey = GlobalKey<FormState>();
  final TribulationRepository tribulationRepository = TribulationRepository();
  @override
  void initState() {
    super.initState();
    pr = new ProgressDialog(context,
        // showLogs: true,
        type: ProgressDialogType.Download,
        isDismissible: false);
    setState(() {
      tribulationInfo = widget.mode == EditMode.create
          ? Tribulation()
          : widget.tribulation != null ? widget.tribulation : Tribulation();
      characters = [];
      equipments = [];
    });
    if (widget.mode != EditMode.create) {
      _loadTribulationInfo();
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  _handleUpdate() async {
    final isUpdate = widget.mode == EditMode.update;
    try {
      if (!_formKey.currentState.validate()) return;
      _formKey.currentState.save();
      Tribulation createdTribulation;
      pr.style(
        message: "${isUpdate ? 'Updating' : 'Creating'} actor...",
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
      );
      await pr.show();
      bool success = false;
      if (isUpdate) {
        success = await tribulationRepository.updateTribulation(
            tribulationInfo.id,
            tribulation: tribulationInfo,
            charactors: characters,
            equipments: equipments);
      } else {
        createdTribulation = await tribulationRepository.createTribulation(
            tribulation: tribulationInfo,
            charactors: characters,
            equipments: equipments);
        success = createdTribulation != null;
        if (success)
          setState(() {
            tribulationInfo = createdTribulation;
          });
      }
      print("Edit $success");
      if (success) {
        await pr.hide();
        await _showMyDialog(
            content: "${isUpdate ? 'Updating' : 'Creating'} success",
            isError: false);
        if (isUpdate) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => TribulationAdminDetail(
                    tribulation: tribulationInfo,
                    role: widget.role,
                    mode: EditMode.read,
                  )));
        } else {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => TribulationScreen()));
        }
      }
      print(success);
    } catch (e) {
      if (e.message == null) return;
      if (e is FormatException)
        throw e;
      else {
        String errorContent = "Something wrong";
        if (e is DioError) {
          errorContent = e.response.data["error"];
        }
        await _showMyDialog(content: errorContent, isError: true);
      }
    } finally {
      await pr.hide();
    }
  }

  _onDelete(int itemId, [BuildContext context]) async {
    print("Delete $itemId");
    if (!await deleteDialog(context)) return;
    try {
      pr.style(
        message: "Deleting...",
        // progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
      );
      await pr.show();
      final success = await tribulationRepository.deleteTribulation(itemId);
      if (success) {
        // final snackBar = SnackBar(
        //     backgroundColor: Colors.green,
        //     content: Text(
        //       "Delete success!",
        //       style: TextStyle(
        //         color: Colors.white,
        //       ),
        //     ));
        // Scaffold.of(context).showSnackBar(snackBar);
        await pr.hide();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => TribulationScreen()));
      } else {
        // final snackBar = SnackBar(
        //     backgroundColor: Colors.red,
        //     content: Text(
        //       "Delete fail!",
        //       style: TextStyle(
        //         color: Colors.white,
        //       ),
        //     ));
        // Scaffold.of(context).showSnackBar(snackBar);
      }
    } on DioError catch (e) {
      setState(() {
        err = e;
      });
    } finally {
      await pr.hide();
    }
  }

  Future<void> _showMyDialog({bool isError = false, String content}) async {
    String title = isError ? "Error" : "Success";
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title,
              style: TextStyle(
                color: isError ? Colors.redAccent : Colors.green,
              )),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(content),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Ok',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool readOnly = widget.mode == EditMode.read;
    String title = widget.mode == EditMode.create
        ? "Create"
        : tribulationInfo.name ?? "Tribulation";
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: <Widget>[
          widget.mode == EditMode.read
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
              : IconButton(icon: Icon(Icons.done), onPressed: _handleUpdate)
        ],
      ),
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: loading
                ? Center(child: CircularProgressIndicator())
                : tribulationInfo == null
                    ? Text("Error when loading tribulaion")
                    : Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Tribulation Info: ",
                              style: textHeaderStyle.copyWith(
                                  fontSize: 25, color: Colors.grey),
                            ),
                            Container(
                              height: 200,
                              child: GridView.count(
                                crossAxisCount: 2,
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 0,
                                childAspectRatio: 2,
                                children: <Widget>[
                                  Input(
                                    readOnly: readOnly,
                                    label: "Name",
                                    initialValue: tribulationInfo.name,
                                    onSaved: (value) {
                                      tribulationInfo.name = value;
                                    },
                                    isRequired: true,
                                  ),
                                  Input(
                                    readOnly: readOnly,
                                    isRequired: true,
                                    label: "Set Quantity",
                                    keyboardType: TextInputType.number,
                                    initialValue: tribulationInfo.setQuantity !=
                                            null
                                        ? tribulationInfo.setQuantity.toString()
                                        : null,
                                    onSaved: (value) {
                                      tribulationInfo.setQuantity =
                                          int.parse(value);
                                    },
                                  ),
                                  MyDatePicker(
                                    label: "Start",
                                    disableChange: readOnly,
                                    value: tribulationInfo.filmingStartDate,
                                    initialDate:
                                        tribulationInfo.filmingStartDate,
                                    onChange: (datePicked) async {
                                      setState(() =>
                                          tribulationInfo.filmingStartDate =
                                              datePicked.toString());
                                    },
                                  ),
                                  MyDatePicker(
                                    label: "End",
                                    disableChange: readOnly,
                                    value: tribulationInfo.filmingEndDate,
                                    initialDate: tribulationInfo.filmingEndDate,
                                    onChange: (datePicked) async {
                                      setState(() =>
                                          tribulationInfo.filmingEndDate =
                                              datePicked.toString());
                                    },
                                  ),
                                  Input(
                                    readOnly: readOnly,
                                    isRequired: true,
                                    label: "Address",
                                    keyboardType: TextInputType.text,
                                    initialValue:
                                        tribulationInfo.filmingAddress,
                                    onSaved: (value) {
                                      tribulationInfo.filmingAddress = value;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(20),
                              // height: 30,
                              child: Input(
                                readOnly: readOnly,
                                label: "Description",
                                initialValue: tribulationInfo.description,
                                onSaved: (value) {
                                  tribulationInfo.description = value;
                                },
                              ),
                            ),
                            Divider(),
                            TextError(err: err),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Charactors: ",
                                  style: textHeaderStyle.copyWith(
                                      fontSize: 25, color: Colors.grey),
                                ),
                                !readOnly
                                    ? OutlineButton(
                                        onPressed: _handleEditCharactor,
                                        child: Text(
                                          "Add",
                                          style: TextStyle(
                                            color: Colors.green,
                                          ),
                                        ),
                                      )
                                    : SizedBox.shrink(),
                              ],
                            ),
                            SizedBox(height: 20),
                            characters.length == 0
                                ? Text("Empty characters")
                                : Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 200,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: characters
                                          .map((e) => _buildCharactor(e))
                                          .toList(),
                                    ),
                                  ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Equipments: ",
                                  style: textHeaderStyle.copyWith(
                                      fontSize: 25, color: Colors.grey),
                                ),
                                !readOnly
                                    ? OutlineButton(
                                        onPressed: _handleEditEquipment,
                                        child: Text(
                                          "Edit",
                                          style: TextStyle(
                                            color: Colors.green,
                                          ),
                                        ),
                                      )
                                    : SizedBox.shrink(),
                              ],
                            ),
                            SizedBox(height: 20),
                            equipments.length == 0
                                ? Text("Empty equipments")
                                : Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 100,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: equipments
                                          .map((e) => _buildEquipment(e))
                                          .toList(),
                                    ),
                                  ),
                          ],
                        ),
                      ),
          ),
        ),
      ),
    );
  }

  _handleEditEquipment() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => EditEquipment(
                initialValue: equipments,
              )),
    );
    if (result != null) {
      setState(() {
        equipments = result;
      });
    }
    print(result);
  }

  _handleEditCharactor({Charactor c}) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => EditCharacter(
                initialValue: c,
              )),
    );
    if (result != null) {
      setState(() {
        if (c == null) {
          characters.add(result);
          characters = characters;
        } else {
          characters = characters;
        }
      });
    }
    print(result);
  }

  _loadTribulationInfo() async {
    try {
      setState(() {
        loading = true;
      });
      Map<String, dynamic> result = await tribulationRepository
          .getTribulationDetailForAdmin(widget.tribulation.id);

      setState(() {
        characters = result["characters"];
        tribulationInfo = result["tribulation"];
        equipments = result["equipments"];
      });
    } catch (e) {
      setState(() {
        err = e;
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  _onDownloadFile(String url, [BuildContext context]) {
    // url = url ??
    //     "https://firebasestorage.googleapis.com/v0/b/prm-journey-west.appspot.com/o/files%2FQuestions.txt?alt=media&token=c1e3045c-06a6-4d3e-8189-71a4bd518ddb";
    if (url != null) {
      openLink(url);
    } else {
      final snackBar = SnackBar(
        content: Text("This character doesn't have file"),
        backgroundColor: Colors.blue,
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  _handleMenuOption(String value) {
    switch (value) {
      case 'update':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => TribulationAdminDetail(
              mode: EditMode.update,
              tribulation: widget.tribulation,
              role: widget.role,
            ),
          ),
          result: false,
        );
        break;
      case 'delete':
        _onDelete(tribulationInfo.id, context);
        break;
      default:
        break;
    }
  }

  Widget _buildEquipment(Equipment equipment) {
    return Container(
      width: 300,
      height: 150,
      child: Card(
        child: ListTile(
          title: Text(
            equipment.name,
            style: textHeaderStyle,
          ),
          leading: ImageNetwork(
            imageURL: equipment.imageURL,
          ),
          subtitle: Text(equipment.quantity.toString()),
        ),
      ),
    );
  }

  Widget _buildChip(Actor actor) {
    return Chip(
      avatar: CircleAvatar(
          backgroundColor: Colors.grey.shade800,
          child: ImageNetwork(
            imageURL: actor.imageURL,
          )),
      label: Text(
        actor.name,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildCharactor(Charactor charactor) {
    return Builder(
      builder: (context) => Container(
        width: 280,
        height: 70,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${charactor.name}",
                        style: textHeaderStyle,
                      ),
                      Text(
                        "Cast by: ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Container(
                        height: 50,
                        width: 250,
                        child: charactor.actors.length == 0
                            ? Text("No actor for this character")
                            : ListView(
                                scrollDirection: Axis.horizontal,
                                children: charactor.actors
                                    .map((e) => _buildChip(e))
                                    .toList()),
                      ),
                    ],
                  ),
                ),
                ButtonBar(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    widget.mode != EditMode.read
                        ? FlatButton(
                            child: const Text(
                              'EDIT',
                              style: TextStyle(color: Colors.greenAccent),
                            ),
                            onPressed: () {
                              _handleEditCharactor(c: charactor);
                            },
                          )
                        : SizedBox.shrink(),
                    widget.mode != EditMode.read
                        ? FlatButton(
                            child: const Text(
                              'Remove',
                              style: TextStyle(color: Colors.redAccent),
                            ),
                            onPressed: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Confirm'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                              'Would you like to delete this ${charactor.name}'),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text(
                                          'Approve',
                                          style: TextStyle(
                                              color: Colors.redAccent),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                      ),
                                      FlatButton(
                                        child: Text(
                                          'Cancel',
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                              if (confirmed)
                                setState(() {
                                  characters.remove(charactor);
                                });
                            },
                          )
                        : SizedBox.shrink(),
                    FlatButton(
                      child: Icon(Icons.file_download),
                      onPressed: () {
                        _onDownloadFile(charactor.descriptionFileURL, context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TribulationDetailAgrument {
  final Tribulation tribulation;

  TribulationDetailAgrument(this.tribulation);
}
