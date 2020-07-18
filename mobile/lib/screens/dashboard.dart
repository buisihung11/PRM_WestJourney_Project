import 'package:firebase_messaging/firebase_messaging.dart';
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
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final UserRepository userRepository = new UserRepository();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUser();
    _saveDeviceToken();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessagea: $message");
        _showItemDialog(message);
        // _handleNotification(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // _navigateToPhaseScore(message);
        _showItemDialog(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // _navigateToPhaseScore(message);
        _showItemDialog(message);
      },
    );
  }

  void _showItemDialog(Map<String, dynamic> message) async {
    print('Showing Dialog');
    bool isConfirmToNavigate = await showDialog<bool>(
        context: context,
        builder: (context) => _buildDialog(
              context,
              message['notification']['title'],
              message['notification']['body'],
            ));
    // if (isConfirmToNavigate) _navigateToPhaseScore(message);
  }

  Future<void> _handleNotification(Map<dynamic, dynamic> message) async {
    var data = message['data'] ?? message;
    print(data.toString());
  }

  Widget _buildDialog(BuildContext context, String msg, String content) {
    return AlertDialog(
      content: Text(
        content,
        style: TextStyle(
          color: Colors.grey[400],
        ),
      ),
      title: Text(msg),
      actions: <Widget>[
        FlatButton(
          child: const Text(
            'No',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        FlatButton(
          child: const Text('Yes'),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }

  _saveDeviceToken() async {
    // Get the token for this device
    String fcmToken = await _fcm.getToken();
    print("FCMTOKEN: $fcmToken");
    // Save it to local
    if (fcmToken != null) {
      setFCMToken(fcmToken);
      // send to server
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
