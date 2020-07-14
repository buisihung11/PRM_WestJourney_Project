class Equipment {
  final int id;
  String name;
  String description;
  String imageURL;
  String status;
  int quantity;

  Equipment(
      {this.id,
      this.name,
      this.description,
      this.imageURL,
      this.status,
      this.quantity});

  factory Equipment.fromMap(Map<String, dynamic> map) => Equipment(
        id: map["id"],
        name: map["name"],
        description: map["description"],
        imageURL: map["imageURL"],
        quantity: map["quantity"],
        status: map["status"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
        "imageURL": imageURL,
        "status": status,
        "quantity": quantity,
      };

  static List<Equipment> fromList(List<dynamic> list) =>
      List<Equipment>.from(list.map((e) => Equipment.fromMap(e)));
}
