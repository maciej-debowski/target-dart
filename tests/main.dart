import '../src/index.dart';
import './app.dart';
import 'package:path/path.dart' as p;
import 'dart:io' show Platform;

void main() {
  var srv = new TargetServer(8080, 'localhost', p.dirname(Platform.script.toString()));
  srv.Config(new Config());
  srv.Run();

  srv.Router(new Router());
}