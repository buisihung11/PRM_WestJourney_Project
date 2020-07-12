import 'package:mobile/models/Tribulation.dart';
import 'package:mobile/utils/index.dart';

class TribulationRepository {
  Future<List<Tribulation>> getTribulation({String filter = "default"}) async {
    try {
      final res = await request.get("/me/scences", queryParameters: {
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
}
