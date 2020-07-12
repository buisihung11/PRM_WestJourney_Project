import 'package:flutter/material.dart';
import 'package:mobile/constrants.dart';
import 'package:mobile/layouts/layout_with_drawer.dart';
import 'package:mobile/models/Equipment.dart';
import 'package:mobile/screens/admin/equipment/equipment_detail.dart';
import 'package:mobile/widgets/ListItem.dart';

class EquipmentScreen extends StatelessWidget {
  static const routeName = "/equipment";
  const EquipmentScreen({Key key}) : super(key: key);

  static List<Equipment> equipmentList = List<Equipment>.generate(
      20,
      (int index) => Equipment(
            name: "Equipment ${index + 1}",
            description: "Description equipment ${index + 1}",
            status: index % 2 == 0 ? "available" : "unavailable",
            quantity: 5 * (index + 1),
          ));

  @override
  Widget build(BuildContext context) {
    return LayoutWithDrawer(
      title: "Equipment",
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Actor List",
                style: textHeaderStyle,
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) => ListItem(
                    leading: Image.network(
                      equipmentList[index].imageURL,
                    ),
                    title: Text(equipmentList[index].name),
                    subtitle: Text(equipmentList[index].quantity.toString()),
                    onListTap: () {
                      Navigator.of(context).pushNamed(
                        EquipmentDetailScreen.routeName,
                        arguments:
                            EquipmentDetailAgrument(equipmentList[index]),
                      );
                    },
                    onDeleteTap: () {},
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
    );
  }
}
