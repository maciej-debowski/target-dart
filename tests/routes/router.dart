import 'dart:io';
import '../../src/index.dart';

class Router extends TargetRouter {
  GetRoutes(TargetServer srv) {
    return [
      new TargetRoute("GET", "/", (HttpRequest request) async {
        var tf = TargetFile("/views/home.thtml", srv.path); 
      
        return tf.Content_Utf8();
      }, ExtendedContentType(ContentType.html, "THTML")),

      new TargetRoute("GET", "/name", (HttpRequest request) async {
        // @URL:  [URL]/name?name=Maciej
        // @Response: Your name is: Maciej
        var query = request.uri.query;
        TargetQuery _query = TargetQuery(query);

        var name = _query.Get("name");

        return "Your name is: $name";
      }, ExtendedContentType(ContentType.html, "THTML"))
    ];
  }
}