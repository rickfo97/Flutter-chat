import 'channel.dart';
import 'dart:convert';
import 'package:flutter_chat/events/message_event.dart';
import 'package:flutter_chat/utils/server_connection.dart';

class ChannelManager{
  static ChannelManager _singleton;
  List<Channel> _channels = new List<Channel>();

  ChannelManager(){
    _singleton = this;

    Connection.getChannel().stream.listen((jsonString) {
      Map message = json.decode(jsonString);
      if(message['event'] == 'message'){
        MessageEvent event = new MessageEvent.fromJson(message);
        newMessage(event);
      }
    });
  }

  static ChannelManager getManager(){
    if(_singleton == null)
      ChannelManager();

    return _singleton;
  }

  static void add(Channel channel){
    ChannelManager manager = getManager();

    manager._channels.add(channel);
  }

  static Channel getChannel(int index){
    ChannelManager manager = getManager();

    return manager._channels[index];
  }

  static void remove(String guid){
    ChannelManager manager = getManager();

    for(Channel channel in manager._channels){
      if(channel.guid == guid){
        manager._channels.remove(channel);
        break;
      }
    }
  }

  static void newMessage(MessageEvent event){
    ChannelManager manager = getManager();

    for(Channel channel in manager._channels){
      if(channel.guid == event.channel){
        channel.addMessage(event);
      }
    }
  }
}