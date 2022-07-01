import 'dart:io';
import './type.dart';

class TargetRoute {
  String method;
  String path;
  Future<String> Function(HttpRequest request) callback;
  ExtendedContentType type;

  bool isOriginal = true;

  TargetRoute(this.method, this.path, this.callback, this.type) {}
}