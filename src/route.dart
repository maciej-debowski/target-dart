import 'dart:io';
import './type.dart';
import './server.dart';

class TargetRoute {
  String method;
  String path;
  Future<String> Function(HttpRequest request, TargetServer srv) callback;
  ExtendedContentType type;

  bool isOriginal = true;

  TargetRoute(this.method, this.path, this.callback, this.type) {}
}