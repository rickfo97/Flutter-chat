import 'package:flutter_chat/utils/user.dart';
import 'dart:convert';

class Message{
  final String message;
  final DateTime created;
  final User user;

  Message(String message, User user)
      : message = message,
        created = new DateTime.now(),
        user = user;

  Message.fromJson(Map<String, dynamic> json)
    : message = json['message'],
      created = DateTime.parse(json['created']),
      user = new User.fromJson(jsonDecode(json['user']));

  Map<String, dynamic> toJson() =>
      {
        'message': message,
        'created': created.toUtc().toString(),
        'user': json.encode(user),
      };
}