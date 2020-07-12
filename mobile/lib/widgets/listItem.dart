import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  const ListItem(
      {Key key,
      this.onListTap,
      this.onDeleteTap,
      this.leading,
      this.title,
      this.subtitle})
      : super(key: key);

  final Function onListTap;
  final Function onDeleteTap;
  final Widget leading;
  final Widget title;
  final Widget subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onListTap,
        child: ListTile(
          leading: leading,
          title: title,
          subtitle: subtitle,
          isThreeLine: false,
          trailing: IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.redAccent,
              ),
              onPressed: onDeleteTap),
        ),
      ),
    );
  }
}
