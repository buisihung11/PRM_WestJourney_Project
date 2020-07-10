import 'package:flutter/material.dart';
import 'package:mobile/layouts/layout_with_drawer.dart';

class ActorScreen extends StatelessWidget {
  static const routeName = "/actor";
  const ActorScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutWithDrawer(
      title: "Actor",
      body: Container(
        child: Text("Actor Screen"),
      ),
    );
  }
}
