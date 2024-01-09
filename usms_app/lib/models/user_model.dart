class User {
  final String id;
  final String pwd;

  User({
    required this.id,
    required this.pwd,
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        pwd = json['pwd'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'pwd': pwd,
      };
}
