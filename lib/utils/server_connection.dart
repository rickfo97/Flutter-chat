import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

class Connection{
  static Connection singleton;
  WebSocketChannel _channel;

  Connection(String url){
    _channel = new IOWebSocketChannel.connect(url);
    _channel.stream.asBroadcastStream();

    Connection.singleton = this;
  }

  static WebSocketChannel getChannel(){
    if(singleton == null)
      Connection('ws://192.168.0.9:8000');

    return singleton._channel;
  }

  void dispose(){
    _channel.sink.close();
  }
}