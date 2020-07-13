import 'package:flutter/material.dart';

class TextError extends StatelessWidget {
  final dynamic err;
  const TextError({Key key, this.err}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return err != null
        ? Container(
            height: 40,
            child: Text(
              err.toString(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          )
        : SizedBox.shrink();
  }
}
