import '../src/index.dart';
import './app.dart';

void main() {
    var srv = new TargetServer(8080, 'localhost');
    srv.Run();

    srv.Router(new Router());

}