import 'channel.dart';
import 'package:flutter_chat/events/message_event.dart';

class ChannelManager{
  static ChannelManager _singleton;
  List<Channel> _channels = new List<Channel>();

  ChannelManager(){
    _singleton = this;
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