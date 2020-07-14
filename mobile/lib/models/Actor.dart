class Actor {
  final int id;
  String description;
  String imageURL;
  String username;
  String name;
  String gender;
  String phone;
  String password;
  Actor(
      {this.password = "123456",
      this.id,
      this.description,
      this.imageURL,
      this.username,
      this.name,
      this.gender,
      this.phone});

  factory Actor.fromMap(Map<String, dynamic> map) => Actor(
        id: map["id"],
        description: map["description"],
        imageURL: map["imageURL"],
        username: map["username"],
        name: map["name"],
        gender: map["gender"],
        phone: map["phone"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "description": description,
        "imageURL": imageURL,
        "username": username,
        "name": name,
        "gender": gender.toLowerCase(),
        "phone": phone,
        "password": password,
      };

  static List<Actor> fromList(List<dynamic> list) =>
      List<Actor>.from(list.map((e) => Actor.fromMap(e)));
}
