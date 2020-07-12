import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mobile/screens/admin/actor_screen.dart';
import 'package:mobile/screens/admin/equipment_screen.dart';
import 'package:mobile/screens/admin/tribulation_screen.dart';
import 'package:mobile/screens/dashboard.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key key}) : super(key: key);

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
            child: Text('Drawer Header'),
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
        ],
      ),
    );
  }
}
