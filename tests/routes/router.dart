import 'dart:io';
import '../../src/index.dart';
import '../controllers/NameController.dart';
import '../controllers/UserController.dart';

NameController nameController = NameController();
UserController userController = UserController();

class Router extends TargetRouter {
  GetRoutes(TargetServer srv) {
    return [
      new TargetRoute("GET", "/", (HttpRequest request, TargetServer srv) async {
        var tf = TargetFile("/views/home.thtml", srv.path); 
      
        return tf.Content_Utf8();
      }, ExtendedContentType(ContentType.html, "THTML")),

      new TargetRoute("GET", "/name", nameController.name, ExtendedContentType(ContentType.html, "THTML")),
      new TargetRoute("GET", "/vue", (HttpRequest request, TargetServer srv) async {
        var tf = TargetFile("/views/vue.thtml", srv.path); 
      
        return tf.Content_Utf8();
      }, ExtendedContentType(ContentType.html, "THTML")),
      new TargetRoute("GET", "/api/users", userController.index, ExtendedContentType(ContentType.json, "")),
      new TargetRoute("GET", "/api/users/id", userController.find, ExtendedContentType(ContentType.json, "")),
      new TargetRoute("GET", "/api/users/add", userController.add, ExtendedContentType(ContentType.text, ""))
    ];
  }
}