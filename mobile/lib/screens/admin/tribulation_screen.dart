import 'package:flutter/material.dart';
import 'package:mobile/constrants.dart';
import 'package:mobile/layouts/layout_with_drawer.dart';
import 'package:mobile/models/Tribulation.dart';
import 'package:mobile/screens/admin/tribulation/tribulation_detail.dart';
import 'package:mobile/widgets/ListItem.dart';

class TribulationScreen extends StatelessWidget {
  static const routeName = "/tribulation";
  const TribulationScreen({Key key}) : super(key: key);

  static List<Tribulation> tribulationList = List<Tribulation>.generate(
      20,
      (int index) => Tribulation(
            name: "Tribulation ${index + 1}",
            description: "Description ${index + 1}",
            filmingAddress: "Address ${index + 1}",
            setQuantity: (index + 1) * 5,
            filmingStartDate: "22/02/2020",
            filmingEndDate: "30/03/2020",
          ));

  @override
  Widget build(BuildContext context) {
    return LayoutWithDrawer(
      title: "Tribulation",
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Tribulation Screen",
                style: textHeaderStyle,
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) => ListItem(
                    title: Text(tribulationList[index].name),
                    subtitle: Text(tribulationList[index].description),
                    onListTap: () {
                      Navigator.of(context).pushNamed(
                        TribulationDetail.routename,
                        arguments:
                            TribulationDetailAgrument(tribulationList[index]),
                      );
                    },
                    onDeleteTap: () {},
                  ),
                  // separatorBuilder: (context, index) => Divider(),
                  itemCount: tribulationList.length,
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
