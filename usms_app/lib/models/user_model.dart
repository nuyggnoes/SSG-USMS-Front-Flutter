class User {
  final String username;
  final String password;
  String person_name = '';
  String email = '';
  String phone_number = '';
  int security_state = 0;
  bool is_lock = false;

  User({
    required this.username,
    required this.password,
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
}
