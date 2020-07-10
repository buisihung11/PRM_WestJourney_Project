import 'package:flutter/material.dart';
import 'package:mobile/layouts/layout_with_drawer.dart';

class EquipmentScreen extends StatelessWidget {
  static const routeName = "/equipment";
  const EquipmentScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutWithDrawer(
      title: "Equipment",
      body: Container(
        child: Text("Equipment Screen"),
      ),
    );
  }
}
