import 'package:mysql1/mysql1.dart';

class TargetModel {
  String name;
  String primary_key;
  var db;

  List<TargetField> fields;
  List<String> blockedFields = [];

  TargetModel() {}

  void Update(var db, Function Logger, config) async {
    this.db = db;
    Logger("Starting updating for table/model   | => |    $name"); 

    List<TargetField> fields = [
      TargetField(primary_key, "int", "", true), 
      ...this.fields, 
      TargetField("last_update", "text", "", false), 
      TargetField("created_at", "text", "", false)
    ];

    // Creating table if not exists
    // #region
    String sql = "CREATE TABLE IF NOT EXISTS $name (";

    int i = 0;

    for(var field in fields) {
      var name = field.name, type = field.type, def = field.def;
      sql += "$name $type ";
      
      if(def != '') {
        sql += " DEFAULT '$def'";
      }
      if(field.isPrimary) {
        sql += " AUTO_INCREMENT";
      }

      if(i != fields.length + 100) sql += ',';
      i++;
    }

    sql += "PRIMARY KEY (`$primary_key`)";
    sql += ")";

    (await db.getConnection()).query(sql);

    // #endregion

    // Updating tables
    String db_name = config.database_name;
    String table_name = this.name;

    // String column_names_query = "SHOW COLUMNS FROM $db_name.$table_name;";
    // var column_names = await (await db.getConnection()).query(column_names_query);

    for(var row in fields) {
      String column_name = row.name; 
      String type = row.type;
      String db_name = config.database_name;

      String sql = '''SELECT * FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = \'$db_name\' AND TABLE_NAME = \'$table_name\' AND COLUMN_NAME = \'$column_name\'''';

      bool exists = ((await (await db.getConnection()).query(sql)).length) == 1;

      if(!exists) {
        String sql = 'ALTER TABLE $table_name ADD $column_name $type';
        (await db.getConnection()).query(sql);
      }
    }

  }

  List<Map> ResultsToMap(Results res) {
    List<Map> array = [];

    for(var row in res) {
      Map<String, String> map = Map();
      for(var key in row.fields.keys) {
        var value = row.fields[key];

        map[key] = "$value";        
      }

      array.add(map);
    }

    return array;
  }

  Future<List<Map>> all() async {
    String sql = "SELECT * FROM $name";

    return this.ResultsToMap(await (await db.getConnection()).query(sql));
  }

  Future<List<Map>> find(int id) async {
    String sql = "SELECT * FROM $name WHERE id = '$id'";

    return this.ResultsToMap(await (await db.getConnection()).query(sql));
  }

  Future<List<Map>> where(String key, String value) async {
    String sql = "SELECT * FROM $name WHERE '$key' = '$value'";

    return this.ResultsToMap(await (await db.getConnection()).query(sql));
  }

  Future<List<Map>> add(List values) async {
    String sql = "INSERT INTO $name VALUES (";

    for(var value in values) {
      if(value is String) sql += "'$value'";
      else if(value is int) sql += "$value";
      sql += ", ";
    }

    String timespan = DateTime.now().toString();

          // Created at updated at
    sql += "'$timespan', '$timespan'";
    sql += ")";

    return this.ResultsToMap(await (await db.getConnection()).query(sql));
  }

  Future<List<Map>> update(Map values) async {
    String sql = "UPDATE $name SET ";

    for(var key in values.keys) {
      var val = values[key];
      
      if(val is String) sql += "$key = '$val',";
      else if(val is int) sql += "$key = $val,";
    }

    var timespan = DateTime.now().toString();
    sql += "last_update = '$timespan'";

    return this.ResultsToMap(await (await db.getConnection()).query(sql));
  }

  Future<List<Map>> delete(int id) async {
    String sql = "DELETE FROM $name WHERE id = '$id'";

    return this.ResultsToMap(await (await db.getConnection()).query(sql));
  }
}

class TargetField {
  String name, type, def;
  bool isPrimary;
  TargetField(this.name, this.type, this.def, [bool isPrimary = false]) {
    this.isPrimary = isPrimary ? isPrimary : false;
  }
}