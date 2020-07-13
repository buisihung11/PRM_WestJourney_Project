import 'package:flutter/material.dart';
import 'package:mobile/constrants.dart';
import 'package:mobile/repositories/user.dart';
import 'package:mobile/screens/dashboard.dart';
import 'package:mobile/utils/validators.dart';
import 'package:mobile/widgets/input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username;
  String password;
  bool isLogging = true;
  dynamic err;
  final _formKey = GlobalKey<FormState>();
  final UserRepository userRepository = UserRepository();
  @override
  void initState() {
    super.initState();
    // check is login
    setState(() {
      isLogging = true;
    });
    _getUser();
  }

  _getUser() async {
    try {
      final isLoggeedIn = await userRepository.isLoggedIn();
      if (isLoggeedIn) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => DashBoardScreen(),
        ));
      }
      print("ISloggedIn: $isLoggeedIn");
      // if (user != null) {}
    } catch (e) {
      // set error
      setState(() {
        err = e;
      });
    } finally {
      setState(() {
        isLogging = false;
      });
    }
  }

  _onLogin() async {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    try {
      setState(() {
        isLogging = true;
      });
      final success =
          await userRepository.login(username.trim(), password.trim());
      if (success) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => DashBoardScreen(),
        ));
      }
    } catch (e) {
      setState(() {
        err = e;
      });
    } finally {
      setState(() {
        isLogging = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Login Page",
            style: TextStyle(
              color: Colors.white,
            )),
        centerTitle: true,
      ),
      body: Center(
          child: isLogging
              ? CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height,
                    child: Form(
                      key: _formKey,
                      autovalidate: true,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Journey to West",
                            style: textHeaderStyle.copyWith(
                                color: Colors.orangeAccent),
                          ),
                          err != null
                              ? Text(
                                  err.toString(),
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                )
                              : Text(""),
                          Input(
                            label: "Username",
                            keyboardType: TextInputType.emailAddress,
                            isRequired: true,
                            onSaved: (String value) {
                              {
                                username = value;
                              }
                            },
                            validator: validateEmail,
                          ),
                          Input(
                            label: "Password",
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            isRequired: true,
                            onSaved: (String value) {
                              {
                                password = value;
                              }
                            },
                          ),
                          RaisedButton(
                            color: Colors.blue,
                            onPressed: _onLogin,
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )),
    );
  }
}
