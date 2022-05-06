class User {
  String name;
  String surname;

  static const NAME = "name";
  static const SURNAME = "surname";

  User(this.name, this.surname);
  Map<String, dynamic> toMap() {
    return {
      NAME: name.substring(0, 1).toUpperCase() + name.substring(1),
      SURNAME: surname.substring(0, 1).toUpperCase() + surname.substring(1),
    };
  }
}
