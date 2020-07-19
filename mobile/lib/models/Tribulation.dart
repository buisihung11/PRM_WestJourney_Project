import 'package:mobile/utils/index.dart';

class Tribulation {
  final int id;
  String name;
  String description;
  String filmingAddress;
  String filmingStartDate;
  String filmingEndDate;
  int setQuantity;

  Tribulation(
      {this.id,
      this.name,
      this.description,
      this.filmingAddress,
      this.filmingStartDate,
      this.filmingEndDate,
      this.setQuantity});

  factory Tribulation.fromMap(Map<String, dynamic> map) => Tribulation(
        name: map["name"],
        id: map["id"],
        description: map["description"],
        filmingAddress: map["filmingAddress"],
        filmingStartDate: map["filmingStartDate"],
        filmingEndDate: map["filmingEndDate"],
        setQuantity: map["setQuantity"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "description": description,
        "filmingAddress": filmingAddress,
        "filmingStartDate": filmingStartDate,
        "filmingEndDate": filmingEndDate,
        "setQuantity": setQuantity,
      };

  static List<Tribulation> fromList(List<dynamic> list) =>
      List<Tribulation>.from(list.map((e) => Tribulation.fromMap(e)));
}
