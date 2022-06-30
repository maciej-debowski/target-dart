import 'dart:io';
import '../src/index.dart';

class Router extends TargetRouter {
  GetRoutes() {
    return [
      // @Url: http://localhost:8080/?name=Facio
      // @Response:  Hello Facio!
      new TargetRoute("GET", "/", (HttpRequest request) {
        var query = request.uri.query;
        TargetQuery _query = TargetQuery(query);

        var name = _query.Get("name");
        return "Hello $name!";
      })
    ];
  }
}