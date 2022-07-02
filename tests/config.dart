class Config {
  String title = "super app";

  // Dart somehow close localhost connection with database so please use external database
  // This is test database.
  String database_host = "54.38.50.59";
  String database_user = "www7803_target";
  String database_pass = "----";
  String database_name = "www7803_target";
  int database_port = 3306;
  int database_max_conns = 10;

  Config() {}
}
