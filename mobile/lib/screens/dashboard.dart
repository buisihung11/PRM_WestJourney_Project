import 'package:flutter/material.dart';
import 'package:mobile/constrants.dart';
import 'package:mobile/layouts/layout_with_drawer.dart';
import 'package:mobile/repositories/user.dart';
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
  final UserRepository userRepository = new UserRepository();
  @override
  void initState() {
    super.initState();
    _loadUser();
    _sendFCMToken();
  }

  _sendFCMToken() async {
    // Get the token from local
    String fcmToken = await getFCMToken();
    print("FCMTOKEN: $fcmToken");
    // Save it to local
    if (fcmToken != null) {
      try {
        bool success = await userRepository.sendTokenToServer(fcmToken);
        if (success) print("Save FCM TOKEN SUCCESS");
      } catch (e) {
        print("Cannot send FCM Token to server: " + e.meesage);
      }
    }
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
