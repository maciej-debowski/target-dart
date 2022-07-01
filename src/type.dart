import 'dart:io';

String THTML = 'app/thtml';

enum TargetType {
  THTML
}

class ExtendedContentType {
  ContentType contentType;
  String extendedType;

  ExtendedContentType(this.contentType, this.extendedType) {}
}