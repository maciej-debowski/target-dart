import 'dart:io';
import './type.dart';

class TargetResponse {
  ExtendedContentType type;
  String content;
  String mime;
  var raw;

  TargetResponse(this.type, this.content, this.mime, this.raw) {}
}