import 'package:flutter/material.dart';
import 'package:mobile/constrants.dart';
import 'package:mobile/layouts/layout_with_drawer.dart';

class DashBoardScreen extends StatelessWidget {
  static const routeName = "/";

  const DashBoardScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutWithDrawer(
      title: "Dashboard",
      body: Container(
        padding: EdgeInsets.all(10),
        child: Text(
          "Hello Hung Bui",
          style: textHeaderStyle,
        ),
      ),
    );
  }
}
