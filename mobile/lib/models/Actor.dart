import 'package:equatable/equatable.dart';

class Actor extends Equatable {
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
        username: map["username"] ?? map["User"]["username"],
        name: map["name"] ?? map["User"]["name"],
        gender: map["gender"] ?? map["User"]["gender"],
        phone: map["phone"] ?? map["User"]["phone"],
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

  @override
  // TODO: implement props
  List<Object> get props => [id];
}
