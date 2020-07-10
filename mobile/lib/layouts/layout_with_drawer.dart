import 'package:flutter/material.dart';
import 'package:mobile/widgets/drawer.dart';

class LayoutWithDrawer extends StatelessWidget {
  final Widget body;
  final String title;
  const LayoutWithDrawer({Key key, this.body, this.title = "Default title"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$title"),
        centerTitle: true,
      ),
      body: body,
      drawer: MyDrawer(),
    );
  }
}
