import 'package:mobile/models/Charactor.dart';
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
