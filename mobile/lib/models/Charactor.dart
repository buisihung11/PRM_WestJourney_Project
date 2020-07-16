import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:mobile/models/Actor.dart';

class Charactor extends Equatable {
  String name;
  String descriptionFileURL;
  List<Actor> actors = [];

  Charactor({
    this.name,
    this.descriptionFileURL,
    this.actors,
  });

  factory Charactor.fromMap(Map<String, dynamic> map) => Charactor(
        name: map["name"],
        descriptionFileURL: map["descriptionFileURL"],
        actors: Actor.fromList(map["Actors"]),
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "descriptionFileURL": descriptionFileURL,
        "actors": json.encode(new List<dynamic>.from(actors.map((e) => e.id))),
      };

  static List<Charactor> fromList(List<dynamic> list) =>
      List<Charactor>.from(list.map((e) => Charactor.fromMap(e)));

  @override
  // TODO: implement props
  List<Object> get props => [name, actors];
}
