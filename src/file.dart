import 'dart:io';
import 'dart:convert';
import 'dart:async';


class TargetFile {
    String path;
    String base;
    TargetFile(this.path, this.base)  {
      this.base = this.base.split("file:///")[1];
      this.path = this.base + this.path;
    }

    Future<String> Content_Utf8() async {
      final file = File(this.path);
      String lines = "";

      var text = await file.readAsBytes();

      try {
        lines = utf8.decode(text);
      } catch(error) {
        try {
          lines = "--utf-error";
        } catch(error) {
          print(error);
        }
      }

      return lines;
    }

    Future<List<int>> GetRaw() async {
      final file = File(this.path);
      return await file.readAsBytes();
    }
}