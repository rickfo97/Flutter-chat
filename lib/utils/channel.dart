import 'package:flutter_chat/utils/message.dart';
import 'package:flutter_chat/utils/user.dart';
import 'package:flutter_chat/events/message_event.dart';
import 'dart:async';

class Channel{
  String guid;

  List<Message> messageHistory = new List<Message>();
  List<User> users;
  StreamController<String> _controller;

  Channel(){
    _controller = new StreamController.broadcast();
  }

  Stream get newMessage => _controller.stream;

  bool loadChannel(){
    if(guid.length == 0)
      return false;

    return false;
  }

  void addMessage(MessageEvent event){
    if(guid == event.channel)
      messageHistory.insert(0, event.message);
    //TODO: Sort message list for old or laggy messages
  }
}