import 'package:dio/dio.dart';
import 'package:mobile/models/Equipment.dart';
import 'package:mobile/utils/index.dart';

class EquipmentRepository {
  Future<List<Equipment>> getEquipments({String status}) async {
    try {
      final res =
          await request.get('/equipments', queryParameters: {"status": status});
      final success = res.statusCode == 200;
      if (success) {
        final result = Equipment.fromList(res.data);
        return result;
      } else {
        throw Exception(res.data["error"]);
      }
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<bool> createEquipment(Equipment createEquipment) async {
    try {
      final res =
          await request.post('/equipments', data: createEquipment.toMap());
      final success = res.statusCode == 201;
      return success;
    } on DioError catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<bool> updateEquipment(Equipment updateEquipment) async {
    try {
      final res = await request.put(
        '/equipments/${updateEquipment.id}',
        data: updateEquipment.toMap(),
      );
      final success = res.statusCode == 204;
      return success;
    } on DioError catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<bool> deleteEquipement(int equipmentId) async {
    try {
      final res = await request.delete('/equipments/$equipmentId');
      final success = res.statusCode == 200;
      if (success) {
        return success;
      } else {
        throw Exception(res.data["error"]);
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.response.data["error"]);
    }
  }
}
