import 'dart:io';
class TargetRoute {
  String method;
  String path;
  String Function(HttpRequest request) callback;

  bool isOriginal = true;

  TargetRoute(this.method, this.path, this.callback) {}
}