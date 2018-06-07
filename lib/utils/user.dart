
class User{
  final String guid;
  final String username;


  User(String guid, String username)
      : guid = guid,
        username = username;

  User.fromJson(Map<String, dynamic> json)
      : guid = json['guid'],
        username = json['username'];

  Map<String, dynamic> toJson() =>
      {
        'guid': guid,
        'username': username,
      };
}