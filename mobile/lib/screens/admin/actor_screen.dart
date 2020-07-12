import 'package:flutter/material.dart';
import 'package:mobile/constrants.dart';
import 'package:mobile/layouts/layout_with_drawer.dart';
import 'package:mobile/models/Actor.dart';
import 'package:mobile/screens/admin/actor/actor_detail.dart';
import 'package:mobile/widgets/ListItem.dart';

class ActorScreen extends StatelessWidget {
  static const routeName = "/actor";
  const ActorScreen({Key key}) : super(key: key);

  static List<Actor> actorList = List<Actor>.generate(
      20,
      (int index) => Actor(
            name: "Actor ${index + 1}",
            description: "Description actor ${index + 1}",
            gender: index % 2 == 0 ? "Male" : "Female",
            phone: "0912121212",
            username: "actor@gmail.com",
          ));

  @override
  Widget build(BuildContext context) {
    return LayoutWithDrawer(
      onCreate: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ActorDetailScreen(
            mode: EditMode.create,
          ),
        ));
      },
      tooltip: "Create new actor",
      title: "Actor Screen",
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Actor List",
                style: textHeaderStyle,
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) => ListItem(
                    leading: Image.network(
                      actorList[index].imageURL,
                      width: 50,
                      height: 50,
                    ),
                    title: Text(actorList[index].name),
                    subtitle: Text(actorList[index].gender),
                    onListTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ActorDetailScreen(
                            mode: EditMode.read,
                            updateActor: actorList[index],
                          ),
                        ),
                      );
                    },
                    onDeleteTap: () {},
                  ),
                  // separatorBuilder: (context, index) => Divider(),
                  itemCount: actorList.length,
                ),
              ),
              // LIST TRIBULATION
            ],
          ),
        ),
      ),
    );
  }
}
