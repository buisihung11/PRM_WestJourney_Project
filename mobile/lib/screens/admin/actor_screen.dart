import 'package:flutter/material.dart';
import 'package:mobile/constrants.dart';
import 'package:mobile/layouts/layout_with_drawer.dart';
import 'package:mobile/models/Actor.dart';
import 'package:mobile/repositories/actor.dart';
import 'package:mobile/screens/admin/actor/actor_detail.dart';
import 'package:mobile/utils/index.dart';
import 'package:mobile/widgets/ListItem.dart';
import 'package:mobile/widgets/image_network.dart';
import 'package:mobile/widgets/text_error.dart';

class ActorScreen extends StatefulWidget {
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
  _ActorScreenState createState() => _ActorScreenState();
}

class _ActorScreenState extends State<ActorScreen> {
  String role;
  String filter;
  dynamic err;
  bool loading = true;
  List<Actor> actorList;
  final ActorRepository actorRepository = ActorRepository();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setUp();
    // load Tribulation
  }

  _setUp() async {
    await _loadActor();
  }

  _loadActor() async {
    setState(() {
      loading = true;
    });
    try {
      final result = await actorRepository.getActors();
      setState(() {
        actorList = result;
      });
    } catch (e) {
      setState(() {
        err = e;
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  _onDelete(int itemId, BuildContext context) async {
    print("Delete $itemId");
    try {
      final success = await actorRepository.deleteActor(itemId);
      if (success) {
        final snackBar = SnackBar(
            content: Text(
          "Delete success!",
          style: TextStyle(
            color: Colors.greenAccent,
          ),
        ));
        Scaffold.of(context).showSnackBar(snackBar);
        _loadActor();
      } else {
        final snackBar = SnackBar(
            content: Text(
          "Delete fail!",
          style: TextStyle(
            color: Colors.redAccent,
          ),
        ));
        Scaffold.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      setState(() {
        err = e;
      });
    } finally {
      // setState(() {
      //   loading = false;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutWithDrawer(
      onReload: _loadActor,
      onCreate: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ActorDetailScreen(
            mode: EditMode.create,
          ),
        ));
      },
      tooltip: "Create new actor",
      title: "Actor Screen",
      body: Builder(
        builder: (context) => Padding(
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
                TextError(err: err),
                loading
                    ? Center(child: CircularProgressIndicator())
                    : Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) => ListItem(
                            leading: ImageNetwork(
                              imageURL: actorList[index].imageURL,
                            ),
                            title: Text(actorList[index].name),
                            subtitle: Text(actorList[index].gender),
                            onListTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ActorDetailScreen(
                                    mode: EditMode.read,
                                    updateActor: actorList[index],
                                  ),
                                ),
                              );
                              _loadActor();
                            },
                            onDeleteTap: () {
                              _onDelete(actorList[index].id, context);
                            },
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
      ),
    );
  }
}
