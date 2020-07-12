import 'package:flutter/material.dart';
import 'package:mobile/constrants.dart';
import 'package:mobile/layouts/layout_with_drawer.dart';
import 'package:mobile/models/Equipment.dart';
import 'package:mobile/screens/admin/equipment/equipment_detail.dart';
import 'package:mobile/utils/index.dart';
import 'package:mobile/widgets/ListItem.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:mobile/widgets/info_item.dart';

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

  @override
  Widget build(BuildContext context) {
    return LayoutWithDrawer(
      onCreate: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EquipmentDetailScreen(
            mode: EditMode.create,
          ),
        ));
      },
      tooltip: "Create new equipment",
      title: "Equipment",
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Equipment List",
                style: textHeaderStyle,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Info(label: "From", content: fromDate),
                    Info(label: "To", content: toDate),
                  ],
                ),
              ),

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
                            status = newValue;
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
                      Expanded(
                        child: RaisedButton(
                          color: Colors.blue,
                          onPressed: () async {
                            final List<DateTime> picked =
                                await DateRagePicker.showDatePicker(
                              context: context,
                              initialFirstDate: new DateTime.now(),
                              initialLastDate: (new DateTime.now()),
                              firstDate: new DateTime(2015),
                              lastDate: new DateTime(2021),
                            );
                            if (picked != null && picked.length == 2) {
                              setState(() {
                                fromDate = formatDate(picked[0]);
                                toDate = formatDate(picked[1]);
                              });
                            }
                          },
                          child: Text(
                            "Pick date range",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) => ListItem(
                    leading: Image.network(
                      EquipmentScreen.equipmentList[index].imageURL,
                    ),
                    title: Text(EquipmentScreen.equipmentList[index].name),
                    subtitle: Text(EquipmentScreen.equipmentList[index].quantity
                        .toString()),
                    onListTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EquipmentDetailScreen(
                            updateEquipment:
                                EquipmentScreen.equipmentList[index],
                          ),
                        ),
                      );
                    },
                    onDeleteTap: () {},
                  ),
                  // separatorBuilder: (context, index) => Divider(),
                  itemCount: EquipmentScreen.equipmentList.length,
                ),
              ),
              // LIST TRIBULATION
            ],
          ),
        ),
      ),
    );
  }
}
