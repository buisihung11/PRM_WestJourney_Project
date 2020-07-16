import 'package:flutter/material.dart';
import 'package:mobile/constrants.dart';
import 'package:mobile/models/Charactor.dart';
import 'package:mobile/models/Tribulation.dart';
import 'package:mobile/repositories/tribulation.dart';
import 'package:mobile/utils/index.dart';
import 'package:mobile/widgets/info_item.dart';
import 'package:mobile/widgets/text_error.dart';

class TribulationDetail extends StatefulWidget {
  static String routename = "/tribulationDetail";
  final Tribulation tribulation;
  final String role;
  const TribulationDetail(
      {Key key, @required this.tribulation, @required this.role})
      : super(key: key);

  @override
  _TribulationDetailState createState() => _TribulationDetailState();
}

class _TribulationDetailState extends State<TribulationDetail> {
  List<CharactorOfActor> actorCharacters;
  bool loading = true;
  dynamic err;
  final TribulationRepository tribulationRepository = TribulationRepository();
  @override
  void initState() {
    super.initState();

    _loadCharacterForActor();
  }

  _loadCharacterForActor() async {
    try {
      setState(() {
        loading = true;
      });
      final res = await tribulationRepository
          .getCharactorInTribulationForActor(widget.tribulation.id);
      setState(() {
        actorCharacters = res;
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

  Widget _buildTribulationForActor(BuildContext context) {
    return actorCharacters == null || actorCharacters?.length == 0
        ? Text("Empty charactors")
        : Column(
            children: <Widget>[
              ...(actorCharacters
                  .map((c) => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: <Widget>[
                              Info(label: "Name", content: c.name),
                              IconButton(
                                icon: Icon(Icons.file_download),
                                onPressed: () {
                                  _onDownloadFile(
                                      c.descriptionFileURL, context);
                                },
                              )
                            ],
                          ),
                        ),
                      ))
                  .toList())
            ],
          );
  }

  _onDownloadFile(String url, BuildContext context) {
    url = url ??
        "https://firebasestorage.googleapis.com/v0/b/prm-journey-west.appspot.com/o/files%2FQuestions.txt?alt=media&token=c1e3045c-06a6-4d3e-8189-71a4bd518ddb";
    if (url != null) {
      openLink(url);
    } else {
      final snackBar =
          SnackBar(content: Text("This character doesn't have file"));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tribulation.name),
      ),
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Tribulation Info: ",
                  style: textHeaderStyle.copyWith(
                      fontSize: 25, color: Colors.grey),
                ),
                Container(
                  height: 250,
                  child: GridView.count(
                    crossAxisCount: 2,
                    padding: EdgeInsets.all(20),
                    childAspectRatio: 2,
                    children: <Widget>[
                      Info(label: "Name", content: widget.tribulation.name),
                      Info(
                          label: "Description",
                          content: widget.tribulation.description),
                      Info(
                          label: "Start",
                          content: widget.tribulation.filmingStartDate),
                      Info(
                          label: "End",
                          content: widget.tribulation.filmingEndDate),
                      Info(
                        label: "Set Quantity",
                        content: widget.tribulation.setQuantity.toString(),
                      ),
                    ],
                  ),
                ),
                Divider(),
                Container(
                  height: 50,
                  child: TextError(err: err),
                ),
                Text(
                  "Charactors: ",
                  style: textHeaderStyle.copyWith(
                      fontSize: 25, color: Colors.grey),
                ),
                Container(
                    height: 300,
                    child: loading
                        ? Center(child: CircularProgressIndicator())
                        : _buildTribulationForActor(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEquipment() {
    return Container(
      width: 300,
      height: 150,
      child: Card(
        child: ListTile(
          title: Text(
            "Equipment 1",
            style: textHeaderStyle,
          ),
          leading: Image.network(
            "https://images.unsplash.com/photo-1581550279519-e2b2baf70ba6?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=300&q=200",
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          subtitle: Text("Quantity: 10"),
        ),
      ),
    );
  }

  Widget _buildChip() {
    return Chip(
      avatar: CircleAvatar(
        backgroundColor: Colors.grey.shade800,
        child: Text('AB'),
      ),
      label: Text(
        'Aaron Burr',
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildCharactor() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Vai dien 1",
                    style: textHeaderStyle,
                  ),
                  Text(
                    "Cast by: ",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Container(
                    height: 50,
                    width: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        _buildChip(),
                        _buildChip(),
                        _buildChip(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text(
                    'EDIT',
                    style: TextStyle(color: Colors.greenAccent),
                  ),
                  onPressed: () {/* ... */},
                ),
                FlatButton(
                  child: const Text('DOWNLOAD FILE'),
                  onPressed: () {
                    openLink("https://google.com");
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TribulationDetailAgrument {
  final Tribulation tribulation;

  TribulationDetailAgrument(this.tribulation);
}
