import 'package:flutter/material.dart';
import 'package:mobile/constrants.dart';
import 'package:mobile/layouts/layout_with_drawer.dart';
import 'package:mobile/models/Tribulation.dart';
import 'package:mobile/repositories/tribulation.dart';
import 'package:mobile/screens/admin/tribulation/tribulation_detail.dart';
import 'package:mobile/screens/admin/tribulation/tribulation_detail_admin.dart';
import 'package:mobile/utils/index.dart';
import 'package:mobile/widgets/ListItem.dart';

class TribulationScreen extends StatefulWidget {
  static const routeName = "/tribulation";
  const TribulationScreen({Key key}) : super(key: key);

  @override
  _TribulationScreenState createState() => _TribulationScreenState();
}

class _TribulationScreenState extends State<TribulationScreen> {
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
          filter: filter,
          role: role,
        );
        if (result != null) {
          setState(() {
            tribulationList = result;
          });
        }
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

  _navigateToDetai(Tribulation tribulation) async {
    if (role == 'actor') {
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => TribulationDetail(
          tribulation: tribulation,
          role: role,
        ),
      ));
    } else {
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => TribulationAdminDetail(
          tribulation: tribulation,
          role: role,
        ),
      ));
    }
    _loadTribulation();
  }

  _navigateToCreate() async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TribulationAdminDetail(
        role: role,
        mode: EditMode.create,
      ),
    ));
    _loadTribulation();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutWithDrawer(
      title: "Tribulation",
      onReload: _loadTribulation,
      onCreate: role == 'admin' ? _navigateToCreate : null,
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
                              subtitle: Text(
                                  tribulationList[index].description ?? ""),
                              onListTap: () {
                                _navigateToDetai(tribulationList[index]);
                              },
                              onDeleteTap: () {
                                _onDelete(tribulationList[index].id, context);
                              },
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

  _onDelete(int itemId, [BuildContext context]) async {
    print("Delete $itemId");
    try {
      final success = await tribulationRepository.deleteTribulation(itemId);
      if (success) {
        final snackBar = SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Delete success!",
              style: TextStyle(
                color: Colors.white,
              ),
            ));
        Scaffold.of(context).showSnackBar(snackBar);
        _loadTribulation();
      } else {
        final snackBar = SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Delete fail!",
              style: TextStyle(
                color: Colors.white,
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
}
