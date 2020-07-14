import 'package:flutter/material.dart';
import 'package:mobile/constrants.dart';
import 'package:mobile/layouts/layout_with_drawer.dart';
import 'package:mobile/models/Tribulation.dart';
import 'package:mobile/repositories/tribulation.dart';
import 'package:mobile/screens/admin/tribulation/tribulation_detail.dart';
import 'package:mobile/utils/index.dart';
import 'package:mobile/widgets/ListItem.dart';

class TribulationScreen extends StatefulWidget {
  static const routeName = "/tribulation";
  const TribulationScreen({Key key}) : super(key: key);

  @override
  _TribulationScreenState createState() => _TribulationScreenState();
}

class _TribulationScreenState extends State<TribulationScreen> {
  // final List<Tribulation> tribulationList = List<Tribulation>.generate(
  //     20,
  //     (int index) => Tribulation(
  //           name: "Tribulation ${index + 1}",
  //           description: "Description ${index + 1}",
  //           filmingAddress: "Address ${index + 1}",
  //           setQuantity: (index + 1) * 5,
  //           filmingStartDate: "22/02/2020",
  //           filmingEndDate: "30/03/2020",
  //         ));
  List<Tribulation> tribulationList;
  final TribulationRepository tribulationRepository = TribulationRepository();

  String role;
  String filter;
  dynamic err;
  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setUp();
    // load Tribulation
  }

  _setUp() async {
    await _loadUser();
    await _loadTribulation();
  }

  _loadTribulation() async {
    setState(() {
      loading = true;
    });
    try {
      if (role != null) {
        final result = await tribulationRepository.getTribulation(
            filter: filter, role: role);
        setState(() {
          tribulationList = result;
        });
      }
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

  _loadUser() async {
    final userRole = await getPref("role");

    if (userRole != null) {
      setState(() {
        role = userRole;
      });
    }
  }

  Widget _buildFilter() {
    if (role == null || role == 'admin') return null;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: DropdownButtonFormField(
                items: ["Done", "Not-yet"].map((String category) {
                  return new DropdownMenuItem(
                      value: category,
                      child: Row(
                        children: <Widget>[
                          Text(category),
                        ],
                      ));
                }).toList(),
                onChanged: (newValue) {
                  filter = newValue;
                  _loadTribulation();
                },
                value: filter,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: "Status",
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // load tribulation
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutWithDrawer(
      title: "Tribulation",
      onReload: _loadTribulation,
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
              _buildFilter() ?? SizedBox.shrink(),
              SizedBox(height: 20),
              Expanded(
                child: loading
                    ? Center(child: CircularProgressIndicator())
                    : tribulationList.length == 0
                        ? Text("Empty list")
                        : ListView.builder(
                            itemBuilder: (context, index) => ListItem(
                              canDelete: role == 'admin',
                              title: Text(tribulationList[index].name),
                              subtitle:
                                  Text(tribulationList[index].description),
                              onListTap: () {
                                //               Navigator.of(context).pushReplacement(MaterialPageRoute(
                                //   builder: (context) => DashBoardScreen(),
                                // ));
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => TribulationDetail(
                                    tribulation: tribulationList[index],
                                    role: role,
                                  ),
                                ));
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
