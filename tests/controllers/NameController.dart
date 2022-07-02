import 'dart:io';
import '../../src/index.dart';

class NameController {
  NameController() {}

  Future<String> name(HttpRequest request, TargetServer srv) async {
      // @URL:  [URL]/name?name=Maciej
      // @Response: Your name is: Maciej
      var query = request.uri.query;
      TargetQuery _query = TargetQuery(query);

      var name = _query.Get("name");

      return "Your name is: $name";
  }
}