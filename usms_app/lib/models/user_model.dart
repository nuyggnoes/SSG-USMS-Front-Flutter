class User {
  final String username;
  final String password;
  final String person_name;
  final String email;
  final String phone_number;
  final int security_state;
  final bool is_lock;

  User({
    required this.username,
    required this.password,
    required this.person_name,
    required this.email,
    required this.phone_number,
    required this.security_state,
    required this.is_lock,
  });

  User.fromJson(Map<String, dynamic> json)
      : username = json["username"],
        password = json['password'],
        person_name = json['person_name'],
        email = json['email'],
        phone_number = json['phone_number'],
        security_state = json['security_state'],
        is_lock = json['is_lock'];

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'person_name': person_name,
        'email': email,
        'phone_number': phone_number,
        'security_state': security_state,
        'is_lock': is_lock,
      };
  factory User.fromMap(Map<String, dynamic> map) {
    print("이 값이 도대체 뭐길래 ? ? ? ? ${map['is_lock']}");
    return User(
      username: map['username'],
      password: map['password'],
      person_name: map['person_name'],
      email: map['email'],
      phone_number: map['phone_number'],
      security_state: map['security_state'],
      is_lock: map['_lock'], // 고쳐
    );
  }
}
