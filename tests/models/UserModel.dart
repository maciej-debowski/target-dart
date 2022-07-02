import '../../src/index.dart';

class UserModel extends TargetModel {
  String name = "users";
  String primary_key = "id";

  // Names of fields after model create can be only changed in database.
  // You can only delete field in database.
  List<TargetField> fields = [
    new TargetField("name", "text", ""),
    new TargetField("password", "text", ""),
    new TargetField("email", "text", ""),
    new TargetField("bio", "text", ""),
    new TargetField("money", "int", ""),
  ]; 
}