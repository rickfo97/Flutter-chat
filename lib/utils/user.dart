
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

class UserManager{
  User _active;
  static UserManager _singleton;

  UserManager(){
    _singleton = this;
  }

  static UserManager getManager(){
    if(_singleton == null)
      UserManager();

    return _singleton;
  }

  static void setUser(User user){
    UserManager manager = getManager();

    manager._active = user;
  }

  static User getUser(){
    UserManager manager = getManager();

    return manager._active;
  }
}