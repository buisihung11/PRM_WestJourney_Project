import 'package:flutter/material.dart';
import 'package:mobile/widgets/drawer.dart';

class LayoutWithDrawer extends StatelessWidget {
  final Widget body;
  final String title;
  final String createRoute;
  final String tooltip;
  final Object agruments;
  const LayoutWithDrawer(
      {Key key,
      this.body,
      this.title = "Default title",
      this.tooltip,
      this.createRoute,
      this.agruments})
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
      floatingActionButton: createRoute != null
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  createRoute,
                  arguments: agruments,
                );
              },
              tooltip: tooltip,
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
