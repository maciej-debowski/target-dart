import 'package:mysql1/mysql1.dart';

class TargetDatabase {
  var conn;
  String host;
  int port;
  String userName;
  String password;
  String databaseName;

  TargetDatabase() {}

  void Connect(var config) async {
    this.host = config.database_host;
    this.port = config.database_port;
    this.userName = config.database_user;
    this.password = config.database_pass;
    this.databaseName = config.database_name;
  }

  Future<MySqlConnection> getConnection() async {
    var settings = new ConnectionSettings(host: host, port: port, user: userName, password: password, db: databaseName);
    return await MySqlConnection.connect(settings);
  }

}