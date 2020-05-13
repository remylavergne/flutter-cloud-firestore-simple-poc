class User {
  String id;
  String name;
  String email;
  String phoneNumber;
  String role;

  User(
      {String id, String name, String email, String phoneNumber, String role}) {
    this.id = id;
    this.name = name;
    this.email = email;
    this.phoneNumber = phoneNumber;
    this.role = role;
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'name': this.name,
        'email': this.email,
        'phoneNumber': this.phoneNumber,
        'role': this.role,
      };
}
