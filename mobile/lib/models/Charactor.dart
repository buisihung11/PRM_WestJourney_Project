class Charactor {
  final String name;
  final String descriptionFileURL;

  Charactor({this.name, this.descriptionFileURL});

  factory Charactor.fromMap(Map<String, dynamic> map) => Charactor(
        name: map["name"],
        descriptionFileURL: map["descriptionFileURL"],
      );

  static List<Charactor> fromList(List<dynamic> list) =>
      List<Charactor>.from(list.map((e) => Charactor.fromMap(e)));
}
