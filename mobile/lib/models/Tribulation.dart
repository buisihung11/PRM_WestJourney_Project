class Tribulation {
  final int id;
  final String name;
  final String description;
  final String filmingAddress;
  final String filmingStartDate;
  final String filmingEndDate;
  final int setQuantity;

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

  static List<Tribulation> fromList(List<dynamic> list) =>
      List<Tribulation>.from(list.map((e) => Tribulation.fromMap(e)));
}
