class User {
  final int id;
  final String username;
  final int age;
  final String location;

  User({
    required this.id,
    required this.username,
    required this.age,
    required this.location,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: int.parse(json['id'].toString()),
      username: json['username'] as String,
      age: int.parse(json['age'].toString()),
      location: json['location'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'age': age,
      'location': location,
    };
  }
}