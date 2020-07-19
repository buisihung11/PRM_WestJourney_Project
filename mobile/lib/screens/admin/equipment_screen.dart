import 'package:flutter/material.dart';
import 'package:mobile/constrants.dart';
import 'package:mobile/layouts/layout_with_drawer.dart';
import 'package:mobile/models/Equipment.dart';
import 'package:mobile/repositories/equipment.dart';
import 'package:mobile/screens/admin/equipment/equipment_detail.dart';
import 'package:mobile/utils/index.dart';
import 'package:mobile/widgets/ListItem.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:mobile/widgets/image_network.dart';
import 'package:mobile/widgets/info_item.dart';
import 'package:mobile/widgets/text_error.dart';

class EquipmentScreen extends StatefulWidget {
  static const routeName = "/equipment";
  const EquipmentScreen({Key key}) : super(key: key);

  static List<Equipment> equipmentList = List<Equipment>.generate(
      20,
      (int index) => Equipment(
            name: "Equipment ${index + 1}",
            description: "Description equipment ${index + 1}",
            status: index % 2 == 0 ? "Available" : "Unavailable",
            quantity: 5 * (index + 1),
          ));

  @override
  _EquipmentScreenState createState() => _EquipmentScreenState();
}

class _EquipmentScreenState extends State<EquipmentScreen> {
  String status;
  String fromDate;
  String toDate;

  String filter;
  dynamic err;
  bool loading = true;
  List<Equipment> equipmentList;
  final EquipmentRepository equipmentRepository = EquipmentRepository();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setUp();
    // load Tribulation
  }

  _setUp() async {
    await _loadEquipment();
  }

  _loadEquipment() async {
    setState(() {
      loading = true;
      err = null;
    });
    try {
      final result = await equipmentRepository.getEquipments(status: status);
      setState(() {
        equipmentList = result;
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

  _onDelete(int itemId, BuildContext context) async {
    print("Delete $itemId");
    try {
      final success = await equipmentRepository.deleteEquipement(itemId);
      if (success) {
        final snackBar = SnackBar(
            backgroundColor: Colors.greenAccent,
            content: Text(
              "Delete success!",
              style: TextStyle(
                color: Colors.white,
              ),
            ));
        Scaffold.of(context).showSnackBar(snackBar);
        _loadEquipment();
      } else {
        final snackBar = SnackBar(
            content: Text(
          "Delete fail!",
          style: TextStyle(
            color: Colors.redAccent,
          ),
        ));
        Scaffold.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      setState(() {
        err = e;
      });
    } finally {
      // setState(() {
      //   loading = false;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutWithDrawer(
      onReload: _loadEquipment,
      onCreate: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EquipmentDetailScreen(
            mode: EditMode.create,
          ),
        ));
      },
      tooltip: "Create new equipment",
      title: "Equipment",
      body: Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Equipment List",
                  style: textHeaderStyle,
                ),
                // Container(
                //   width: MediaQuery.of(context).size.width,
                //   height: 50,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                //     children: <Widget>[
                //       Info(label: "From", content: fromDate),
                //       Info(label: "To", content: toDate),
                //     ],
                //   ),
                // ),

                // FILTERS
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: DropdownButtonFormField(
                            items: ["All", "Available", "Unavailable"]
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
                              status = newValue;
                              _loadEquipment();
                            },
                            value: status,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              hintText: "Status",
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        // Expanded(
                        //   child: RaisedButton(
                        //     color: Colors.blue,
                        //     onPressed: () async {
                        //       final List<DateTime> picked =
                        //           await DateRagePicker.showDatePicker(
                        //         context: context,
                        //         initialFirstDate: new DateTime.now(),
                        //         initialLastDate: (new DateTime.now()),
                        //         firstDate: new DateTime(2015),
                        //         lastDate: new DateTime(2021),
                        //       );
                        //       if (picked != null && picked.length == 2) {
                        //         setState(() {
                        //           fromDate = formatDate(picked[0]);
                        //           toDate = formatDate(picked[1]);
                        //         });
                        //       }
                        //     },
                        //     child: Text(
                        //       "Pick date range",
                        //       style: TextStyle(
                        //         color: Colors.white,
                        //         fontSize: 15,
                        //       ),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
                Center(
                  child: TextError(
                    err: err,
                  ),
                ),
                SizedBox(height: 20),
                loading
                    ? Center(child: CircularProgressIndicator())
                    : equipmentList.length == 0
                        ? Center(
                            child: Text("Empty list", style: textHeaderStyle))
                        : Expanded(
                            child: ListView.builder(
                              itemBuilder: (context, index) => ListItem(
                                leading: ImageNetwork(
                                  imageURL: equipmentList[index].imageURL,
                                ),
                                title: Text(equipmentList[index].name),
                                subtitle: Text(
                                    equipmentList[index].quantity.toString()),
                                onListTap: () {
                                  Navigator.of(context)
                                      .push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EquipmentDetailScreen(
                                        updateEquipment: equipmentList[index],
                                      ),
                                    ),
                                  )
                                      .then((value) {
                                    _loadEquipment();
                                  });
                                },
                                onDeleteTap: () {
                                  _onDelete(equipmentList[index].id, context);
                                },
                              ),
                              // separatorBuilder: (context, index) => Divider(),
                              itemCount: equipmentList.length,
                            ),
                          ),
                // LIST TRIBULATION
              ],
            ),
          ),
        ),
      ),
    );
  }
}
