import 'package:flutter/material.dart';
import 'package:mobile/models/Equipment.dart';
import 'package:mobile/repositories/equipment.dart';
import 'package:mobile/widgets/image_network.dart';
import 'package:smart_select/smart_select.dart';

class EditEquipment extends StatefulWidget {
  const EditEquipment({Key key, this.initialValue}) : super(key: key);
  final List<Equipment> initialValue;
  @override
  _EditEquipmentState createState() => _EditEquipmentState();
}

class _EditEquipmentState extends State<EditEquipment> {
  List<Equipment> updatedEquipment = [];
  List<SmartSelectOption<Equipment>> equipmentSrc = [];
  bool _loadingEquipment = true;
  dynamic err;

  final EquipmentRepository equipmentRepository = EquipmentRepository();

  @override
  void initState() {
    super.initState();
    setState(() {
      updatedEquipment = widget.initialValue ?? List<Equipment>();
    });
    _loadEquipmentSrc();
  }

  _handleReturn() {
    // return List<Equipment>
    Navigator.of(context).pop(updatedEquipment);
  }

  _handleUpdateQuantity(Equipment equipment) async {
    final updateQuantity = await _buildDialog(equipment.quantity);
    equipment.quantity = updateQuantity;
    setState(() => updatedEquipment = updatedEquipment);
  }

  Future<int> _buildDialog(int initialValue) {
    final _quantityController =
        TextEditingController(text: initialValue.toString());
    return showDialog<int>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update quantity"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: new InputDecoration(
                      labelText: "Quantity",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop(initialValue);
              },
            ),
            FlatButton(
              child: Text(
                'Ok',
              ),
              onPressed: () {
                Navigator.of(context).pop(int.parse(_quantityController.text));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Edit Equipment"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.done), onPressed: _handleReturn)
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Text("Edit"),
            SmartSelect<Equipment>.multiple(
              title: 'Equipments',
              value: updatedEquipment,
              isTwoLine: true,
              isLoading: _loadingEquipment,
              options: equipmentSrc,
              modalConfig: SmartSelectModalConfig(useFilter: true),
              choiceType: SmartSelectChoiceType.checkboxes,
              choiceConfig: SmartSelectChoiceConfig<Equipment>(
                isGrouped: true,
                secondaryBuilder: (context, item) => CircleAvatar(
                  backgroundImage: NetworkImage(item.value.imageURL),
                ),
              ),
              onChange: (val) {
                // set quantity = 1 for every selected item
                val.forEach((element) {
                  // only new item will be set to 1
                  if (updatedEquipment.indexOf(element) < 0)
                    element.quantity = 1;
                });
                setState(() {
                  updatedEquipment = val;
                });
              },
            ),

            // render selected equipment
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    children: updatedEquipment
                        .map(
                          (e) => Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                child: ImageNetwork(
                                  imageURL: e.imageURL,
                                ),
                              ),
                              title: Text(e.name),
                              subtitle: Text(e.quantity.toString()),
                              trailing: IconButton(
                                icon: Icon(Icons.edit),
                                tooltip: "Edit quantity",
                                onPressed: () => _handleUpdateQuantity(e),
                              ),
                            ),
                          ),
                        )
                        .toList()),
              ),
            )
          ],
        ),
      ),
    );
  }

  _loadEquipmentSrc() async {
    setState(() {
      _loadingEquipment = true;
      err = null;
    });
    try {
      List<Equipment> result =
          await equipmentRepository.getEquipments(status: "available");
      setState(() {
        equipmentSrc = SmartSelectOption.listFrom<Equipment, dynamic>(
          source: result,
          value: (index, item) => item,
          title: (index, item) => (item as Equipment).name,
          subtitle: (index, item) => (item as Equipment).quantity.toString(),
          group: (index, item) => (item as Equipment).status,
        );
      });
    } catch (e) {
      setState(() {
        err = e;
      });
    } finally {
      setState(() {
        _loadingEquipment = false;
      });
    }
  }
}
