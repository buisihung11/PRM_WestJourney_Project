import 'package:mobile/models/Actor.dart';

final List<Actor> actorList = List<Actor>.generate(
    20,
    (int index) => Actor(
          name: "Actor ${index + 1}",
          description: "Description actor ${index + 1}",
          gender: index % 2 == 0 ? "male" : "female",
        ));
