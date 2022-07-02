import '../src/index.dart';
import './app.dart';
import 'package:path/path.dart' as p;
import 'dart:io' show Platform;
import './models/all.dart';

void main() async {
  var srv = new TargetServer(8080, 'localhost', p.dirname(Platform.script.toString()));
  srv.Config(new Config());
  srv.Models(active_models);
  srv.Router(new Router());

  // Running
  await srv.Run();
}