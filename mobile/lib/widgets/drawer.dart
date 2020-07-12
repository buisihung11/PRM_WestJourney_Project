import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mobile/repositories/user.dart';
import 'package:mobile/screens/admin/actor_screen.dart';
import 'package:mobile/screens/admin/equipment_screen.dart';
import 'package:mobile/screens/admin/tribulation_screen.dart';
import 'package:mobile/screens/dashboard.dart';
import 'package:mobile/screens/login.dart';
import 'package:mobile/utils/index.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String userName;
  String imageURL;
  String role;
  final UserRepository userRepository = UserRepository();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUser();
  }

  _loadUser() async {
    final name = await getPref("name");
    final userImageURL = await getPref("imageURL");
    final userRole = await getPref("role");

    if (name != null && userImageURL != null && userRole != null) {
      setState(() {
        userName = name;
        imageURL = userImageURL;
        role = userRole;
      });
    }
  }

  _logOut() async {
    if (await userRepository.logOut()) {
      Navigator.of(context).pop();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => route.isCurrent ? true : false);
    }
  }

  List<Widget> _buildDrawer() {
    if (role == null) return [];
    switch (role) {
      case "admin":
        return [
          ListTile(
            leading: Icon(AntDesign.calculator),
            title: Text('Tribulations'),
            onTap: () {
              Navigator.of(context).pop();
              // Navigator.pushNamed(context, TribulationScreen.routeName);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => TribulationScreen()),
                  (route) => route.isCurrent ? true : false);
            },
          ),
          ListTile(
            leading: Icon(AntDesign.user),
            title: Text('Actors'),
            onTap: () {
              Navigator.of(context).pop();
              // Navigator.pushNamed(context, ActorScreen.routeName);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => ActorScreen()),
                  (route) => route.isCurrent ? true : false);
            },
          ),
          ListTile(
            leading: Icon(AntDesign.tool),
            title: Text('Equipments'),
            onTap: () {
              Navigator.of(context).pop();
              // Navigator.pushNamed(context, EquipmentScreen.routeName);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => EquipmentScreen(),
                  ),
                  (route) => route.isCurrent ? true : false);
            },
          ),
        ];
      case "actor":
        return [
          ListTile(
            leading: Icon(AntDesign.calculator),
            title: Text('Tribulations'),
            onTap: () {
              Navigator.of(context).pop();
              // Navigator.pushNamed(context, TribulationScreen.routeName);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => TribulationScreen()),
                  (route) => route.isCurrent ? true : false);
            },
          ),
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                imageURL != null
                    ? Image.network(imageURL)
                    : Container(
                        color: Colors.grey,
                        width: 150,
                        height: 150,
                      ),
                Text(
                  '$userName',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: Icon(AntDesign.home),
            title: Text('Home'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => DashBoardScreen()),
                  (route) => route.isCurrent ? true : false);
              // Navigator.pushNamed(context, DashBoardScreen.routeName);
            },
          ),
          ..._buildDrawer(),
          ListTile(
            leading: Icon(AntDesign.logout),
            title: Text('Logout'),
            onTap: _logOut,
          ),
        ],
      ),
    );
  }
}
