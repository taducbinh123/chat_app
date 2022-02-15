class User {
  final String name;
  final String email;

  User( {required this.name, required this.email});

  @override
  String toString() {
    return 'User{name: $name, email: $email}';
  }
}
