import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mobile/constrants.dart';
import 'package:mobile/repositories/user.dart';
import 'package:mobile/screens/dashboard.dart';
import 'package:mobile/utils/index.dart';
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

  final FirebaseMessaging _fcm = FirebaseMessaging();
  @override
  void initState() {
    super.initState();
    // check is login
    setState(() {
      isLogging = true;
    });
    _getUser();
    _saveDeviceToken();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        _showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch $message');
        _showItemDialog(message["data"]);
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume $message');
        _showItemDialog(message["data"]);
      },
    );
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
                          SizedBox(height: 15),
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

  _saveDeviceToken() async {
    // Get the token for this device
    String fcmToken = await _fcm.getToken();
    print("FCMTOKEN: $fcmToken");
    // Save it to local
    if (fcmToken != null) {
      await setFCMToken(fcmToken);
    }
  }

  void _showItemDialog(Map<String, dynamic> message) async {
    print("Showing dialog");
    final result = await showDialog(
      context: context,
      builder: (context) => _buildDialog(
        context,
        message["notification"]['title'],
        message["notification"]['body'],
      ),
    );
    // if (isConfirmToNavigate) _navigateToPhaseScore(message);
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
          child: const Text('Ok'),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }
}
