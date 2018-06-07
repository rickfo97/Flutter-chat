import 'package:flutter_chat/utils/message.dart';
import 'dart:convert';

class MessageEvent{
  final String channel;
  final Message message;

  MessageEvent(this.channel, this.message);

  MessageEvent.fromJson(Map<String, dynamic> json)
    : channel = json['channel'],
      message = new Message.fromJson(jsonDecode(json['message']));

  Map<String, dynamic> toJson() =>
      {
        'event': 'message',
        'channel': channel,
        'message': json.encode(message),
      };
}