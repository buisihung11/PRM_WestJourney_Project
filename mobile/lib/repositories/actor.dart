import 'package:mobile/models/Actor.dart';
import 'package:mobile/utils/index.dart';

class ActorRepository {
  Future<List<Actor>> getActors() async {
    try {
      final res = await request.get('/actors');
      final success = res.statusCode == 200;
      if (success) {
        final result = Actor.fromList(res.data);
        return result;
      } else {
        throw Exception(res.data["error"]);
      }
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<bool> deleteActor(int actorId) async {
    try {
      final res = await request.delete('/actors/$actorId');
      final success = res.statusCode == 200;
      return success;
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
