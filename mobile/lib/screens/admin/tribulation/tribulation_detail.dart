import 'package:flutter/material.dart';
import 'package:mobile/constrants.dart';
import 'package:mobile/models/Tribulation.dart';
import 'package:mobile/utils/index.dart';
import 'package:mobile/widgets/info_item.dart';

class TribulationDetail extends StatelessWidget {
  static String routename = "/tribulationDetail";

  const TribulationDetail({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Tribulation tribulation =
        (ModalRoute.of(context).settings.arguments as TribulationDetailAgrument)
            .tribulation;

    return Scaffold(
      appBar: AppBar(
        title: Text(tribulation.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Tribulation Info: ",
                style:
                    textHeaderStyle.copyWith(fontSize: 25, color: Colors.grey),
              ),
              Container(
                height: 200,
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: EdgeInsets.all(20),
                  childAspectRatio: 3,
                  children: <Widget>[
                    Info(label: "Name", content: tribulation.name),
                    Info(
                        label: "Description", content: tribulation.description),
                    Info(label: "Start", content: tribulation.filmingStartDate),
                    Info(label: "End", content: tribulation.filmingEndDate),
                    Info(
                      label: "Set Quantity",
                      content: tribulation.setQuantity.toString(),
                    ),
                  ],
                ),
              ),
              Divider(),
              Text(
                "Charactors: ",
                style:
                    textHeaderStyle.copyWith(fontSize: 25, color: Colors.grey),
              ),
              Container(
                height: 180,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    _buildCharactor(),
                    _buildCharactor(),
                    _buildCharactor(),
                  ],
                ),
              ),
              Divider(),
              Text(
                "Equipments: ",
                style:
                    textHeaderStyle.copyWith(fontSize: 25, color: Colors.grey),
              ),
              Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    _buildEquipment(),
                    _buildEquipment(),
                    _buildEquipment(),
                  ],
                ),
              ),
            ],
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
                  )
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
