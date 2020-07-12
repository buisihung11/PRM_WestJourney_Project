import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  final String label;
  final String content;
  const Info({Key key, this.label, this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "$label: ",
          style: TextStyle(
              color: Colors.blueAccent.withOpacity(0.7), fontSize: 15),
        ),
        Text(
          content,
          style: TextStyle(
            color: Colors.blueAccent,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
