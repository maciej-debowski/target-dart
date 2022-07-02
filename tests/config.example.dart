class Config {
  String title = "super app";

  // Dart somehow close localhost connection with database so please use external database
  String database_host = "host";
  String database_user = "username";
  String database_pass = "pass";
  String database_name = "name";
  int database_port = 3306;
  int database_max_conns = 10;

  Config() {}
}