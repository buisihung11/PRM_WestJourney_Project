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
      this.imageURL =
          "https://i.pinimg.com/originals/9d/97/a2/9d97a28b5894f5118f5841810eacae80.png",
      this.username,
      this.name,
      this.gender,
      this.phone});

  factory Actor.fromMap(Map<String, dynamic> map) => Actor(
        id: map["id"],
        description: map["description"],
        imageURL: map["imageURL"],
        username: map["User"]["username"],
        name: map["User"]["name"],
        gender: map["User"]["gender"],
        phone: map["User"]["phone"],
      );

  static List<Actor> fromList(List<dynamic> list) =>
      List<Actor>.from(list.map((e) => Actor.fromMap(e)));
}
