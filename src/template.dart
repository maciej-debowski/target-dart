import './server.dart';
import 'dart:isolate';

/**
 * .thtml
 */

class Target_THTML_File {
  String in_content;
  String out_content;
  bool completed = false;
  TargetServer serverInstance;

  Target_THTML_File(this.in_content, this.serverInstance) {}
  Future<bool> Compile() async {
    this.out_content = this.in_content; // First

    var ctnt = this.out_content;
    var splitted = ctnt.split("<%");
    int index = -1;
    int responses = 0;
    for (var element in splitted) {
      index++;
      if(index == 0) continue;

      var inside = element.split("%>")[0];
      var config = this.serverInstance.config;
      var path = this.serverInstance.path;  
      var appPath = '$path/app.dart';

      var recive_port_1 = new ReceivePort();
      var full = "<%$inside%>";
      await recive_port_1.listen((partial) {
        this.out_content = this.out_content.replaceFirst(full, partial.toString());
        responses++;

        if(responses == splitted.length - 1) {
          this.completed = true;
        }
      });

      final uri = Uri.dataFromString('''
      // @dart = 2.8
      import '$appPath';
      import "dart:async";
      import "dart:isolate";
      var config = Config();
      void main(args, SendPort port) { 
        port.send($inside);
      }''', mimeType: 'application/dart');

      await Isolate.spawnUri(uri, ["--no-sound-null-safet"], recive_port_1.sendPort);
    }

    // this.out_content = ctnt; // Last
    // while(responses != index) { print("Responses: $responses index: $index"); }

    return true;
  }

  String GetContent() {
    return this.out_content;
  }
}