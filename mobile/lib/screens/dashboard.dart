import 'package:flutter/material.dart';
import 'package:mobile/layouts/layout_with_drawer.dart';
import 'package:mobile/widgets/drawer.dart';

class DashBoardScreen extends StatelessWidget {
  static const routeName = "/";

  const DashBoardScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutWithDrawer(
      title: "Dashboard",
      body: Container(
        child: Text("This screen is for both admin and actor"),
      ),
    );
  }
}
