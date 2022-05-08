import 'package:app_word/res/global.dart';

class User {
  String name;
  String surname;

  static const ADMIN = "admin";
  static const NAME = "name";
  static const SURNAME = "surname";

  User(this.name, this.surname);
  Map<String, dynamic> toMap() {
    return {
      ADMIN: false,
      NAME: Global.capitalize(name),
      SURNAME: Global.capitalize(surname),
    };
  }
}
