import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import '../../src/index.dart';

class UserController {
  UserController() {}

  Future<String> index(HttpRequest request, TargetServer srv) async {
      // @URL:  [URL]/users
      // @Response: all users

      return jsonEncode(await srv.models.firstWhere((e) => e.name == "users").all());
  }

  Future<String> find(HttpRequest request, TargetServer srv) async {
    TargetModel model = await srv.models.firstWhere((e) => e.name == "users");

    String query = request.uri.query;
    TargetQuery q = TargetQuery(query);

    var obj = await model.find(int.parse(q.Get("id")));
    return jsonEncode(obj);
  }

  Future<String> add(HttpRequest request, TargetServer srv) async {
    TargetModel model = await srv.models.firstWhere((e) => e.name == "users");

    model.add(["0", "Example User ...", "example_password", "mail@mail.mail", "example bio", 100]);
    return "true";
  }
}