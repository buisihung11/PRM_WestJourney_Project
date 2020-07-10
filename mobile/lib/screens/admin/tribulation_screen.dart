import 'package:flutter/material.dart';
import 'package:mobile/layouts/layout_with_drawer.dart';

class TribulationScreen extends StatelessWidget {
  static const routeName = "/tribulation";
  const TribulationScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutWithDrawer(
      title: "Tribulation",
      body: Container(
        child: Text("Tribulation Screen"),
      ),
    );
  }
}
