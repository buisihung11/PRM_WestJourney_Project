import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class Link extends StatelessWidget {
  const Link({Key key}) : super(key: key);

  Future<void> _onOpen(LinkableElement link) async {
    print("Clicked $link.url");
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Linkify(
      onOpen: _onOpen,
      text: "Made by https://cretezy.com",
    );
  }
}
