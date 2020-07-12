import 'package:mobile/utils/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  Future<bool> isLoggedIn() async {
    try {
      final jwtToken = await getToken();
      if (jwtToken != null) {
        requestObj.setToken = jwtToken;
        final res = await request.get("/me");
        final success = res.data["success"];
        if (success) {
          requestObj.setToken = jwtToken;
          await _setUpUser(res.data["userInfo"]);
          return true;
        } else {
          throw Exception(res.data["error"]);
        }
      }
      return false;
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<bool> login(String username, password) async {
    try {
      final res = await request
          .post("/login", data: {"username": username, "password": password});

      // set token
      // set token to req Obj
      // login status
      // set ROLE + USERNAME + USERID TO sharedPreference
      if (res.data["success"]) {
        await setToken(res.data["data"]["token"]);
        requestObj.setToken = res.data["data"]["token"];
        final saveToken = await setToken(res.data["data"]["token"]);
        print("Save Token $saveToken");
        // send FCM Token
        await _setUpUser(res.data["data"]);
        return true;
      } else {
        throw Exception(res.data["error"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  _setUpUser(dynamic resContent) async {
    final String userId = resContent["userId"].toString();
    final String role = resContent["role"];
    final String name = resContent["name"];
    final String imageURL = resContent["imageURL"];

    await setPref("userId", userId);
    await setPref("role", role);
    await setPref("name", name);
    await setPref("imageURL", imageURL);
  }

  Future<bool> logOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.clear();
  }
}
