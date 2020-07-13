import 'package:flutter/material.dart';
import 'package:mobile/screens/admin/actor/actor_detail.dart';
import 'package:mobile/widgets/drawer.dart';

class LayoutWithDrawer extends StatelessWidget {
  final Widget body;
  final String title;
  final String tooltip;
  final Function onCreate;
  final Function onReload;

  const LayoutWithDrawer({
    Key key,
    this.body,
    this.title = "Default title",
    this.tooltip,
    this.onCreate,
    this.onReload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$title"),
        centerTitle: true,
        actions: <Widget>[
          onReload != null
              ? IconButton(
                  icon: Icon(Icons.replay),
                  onPressed: onReload,
                )
              : SizedBox.shrink(),
        ],
      ),
      body: body,
      drawer: MyDrawer(),
      floatingActionButton: onCreate != null
          ? FloatingActionButton(
              onPressed: onCreate,
              tooltip: tooltip,
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
