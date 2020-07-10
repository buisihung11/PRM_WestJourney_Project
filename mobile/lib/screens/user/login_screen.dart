import 'package:flutter/material.dart';
import 'package:mobile/layouts/layout_with_drawer.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = "/login";
  const LoginScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutWithDrawer(
      title: "Login",
      body: Container(
        child: Text("Login Screen"),
      ),
    );
  }
}
