import 'dart:convert';

import 'package:mobile/models/Actor.dart';
import 'package:mobile/models/Charactor.dart';
import 'package:mobile/models/Equipment.dart';
import 'package:mobile/models/Tribulation.dart';
import 'package:mobile/utils/index.dart';

class TribulationRepository {
  Future<List<Tribulation>> getTribulation2({String role, String filter}) {
    switch (role) {
      case 'actor':
        return getTribulation(filter: filter);
        break;
      case 'admin':
        // return getCharactorInTribulationForActor();
        break;
      default:
        return null;
    }
  }

  Future<bool> updateTribulation(int tribulationId,
      {Tribulation tribulation,
      List<Equipment> equipments = const [],
      List<Charactor> charactors = const []}) async {
    try {
      String url = "/scences/$tribulationId";
      final data = {
        "tribulation": tribulation.toMap(),
        "equipments":
            json.encode(List<dynamic>.from(equipments.map((e) => e.toMap()))),
        "characters":
            json.encode(List<dynamic>.from(charactors.map((e) => e.toMap()))),
      };
      final res = await request.put(url, data: data);
      final success = res.statusCode == 200;
      if (success) {
        return true;
      } else {
        throw Exception(res.data["error"]);
      }
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<Map<String, dynamic>> getTribulationDetailForAdmin(
      int tribulationId) async {
    try {
      String url = "/scences/$tribulationId";
      Map<String, dynamic> result = Map<String, dynamic>();
      Tribulation tribulation;
      List<Charactor> characters;
      List<Equipment> equipments;
      final res = await request.get(url);
      final success = res.statusCode == 200;
      if (success) {
        tribulation = Tribulation.fromMap(res.data);
        characters = Charactor.fromList(res.data["Characters"]);
        equipments = Equipment.fromList(res.data["Equipment"]);
        print(characters);
        print(equipments);
        result.putIfAbsent("tribulation", () => tribulation);
        result.putIfAbsent("characters", () => characters);
        result.putIfAbsent("equipments", () => equipments);
        return result;
      } else {
        throw Exception(res.data["error"]);
      }
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<List<Tribulation>> getTribulation(
      {String filter = "default", String role}) async {
    try {
      String url = role == 'actor' ? "/me/scences" : '/scences';
      final res = await request.get(url, queryParameters: {
        "filter": filter?.toLowerCase(),
      });
      final success = res.statusCode == 200;
      if (success) {
        final result = Tribulation.fromList(res.data);
        return result;
      } else {
        throw Exception(res.data["error"]);
      }
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<List<Charactor>> getCharactorInTribulationForActor(
      int tribulationId) async {
    try {
      final res = await request.get("/me/scences/$tribulationId");
      final success = res.statusCode == 200;
      if (success) {
        final result = Charactor.fromList(res.data["Characters"]);
        return result;
      } else {
        throw Exception(res.data["error"]);
      }
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
