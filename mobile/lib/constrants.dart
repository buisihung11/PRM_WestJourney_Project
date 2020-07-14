import 'package:flutter/material.dart';

final textHeaderStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);

const String DEV_SERVER_API = "http://192.168.56.1:3000";
const String SERVER_API = "https://journey-to-west.herokuapp.com";

enum EditMode { read, update, create }
