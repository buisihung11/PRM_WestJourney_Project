import 'package:flutter/material.dart';
import 'package:mobile/constrants.dart';
import 'package:mobile/layouts/layout_with_drawer.dart';
import 'package:mobile/utils/index.dart';

class DashBoardScreen extends StatefulWidget {
  static const routeName = "/";

  const DashBoardScreen({Key key}) : super(key: key);

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  String userName;
  String imageURL;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUser();
  }

  _loadUser() async {
    final name = await getPref("name");
    final userImageURL = await getPref("imageURL");

    if (name != null && userImageURL != null) {
      setState(() {
        userName = name;
        imageURL = userImageURL;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutWithDrawer(
      title: "Dashboard",
      body: Container(
        padding: EdgeInsets.all(10),
        child: Text(
          "Hello $userName",
          style: textHeaderStyle,
        ),
      ),
    );
  }
}
