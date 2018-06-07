import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'utils/server_connection.dart';
import 'pages/channel.dart';
import 'package:flutter_chat/utils/channel.dart';
import 'package:flutter_chat/utils/channel_manager.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'WebSocket Demo';
    final server = 'ws://192.168.0.9:8000';

    Connection(server);

    Channel channel = new Channel();
    channel.guid = "123";
    ChannelManager.add(channel);

    return new MaterialApp(
      title: title,
      home: new ChannelPage(channel: channel),
    );
  }
}