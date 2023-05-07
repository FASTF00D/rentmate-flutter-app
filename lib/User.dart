class User {
  final String name;
  final int age;
  final String city;

  User({required this.name, required this.age, required this.city});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      age: json['age'],
      city: json['city'],
    );
  }

}