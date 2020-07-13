import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  const ListItem(
      {Key key,
      this.onListTap,
      this.onDeleteTap,
      this.leading,
      this.title,
      this.subtitle,
      this.canDelete = true})
      : super(key: key);

  final Function onListTap;
  final Function onDeleteTap;
  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final bool canDelete;

  Future<bool> _showMyDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Would you like to delete this item'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Approve',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            FlatButton(
              child: Text(
                'Cancel',
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }

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
          trailing: canDelete
              ? IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                  onPressed: () async {
                    final accept = await _showMyDialog(context);
                    if (accept && onDeleteTap != null) {
                      onDeleteTap();
                    }
                  })
              : null,
        ),
      ),
    );
  }
}
