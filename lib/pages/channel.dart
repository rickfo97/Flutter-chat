import 'package:flutter/material.dart';
import 'package:flutter_chat/utils/channel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat/utils/server_connection.dart';
import 'package:flutter_chat/utils/message.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_chat/utils/user.dart';
import 'package:flutter_chat/utils/channel_manager.dart';
import 'package:flutter_chat/events/message_event.dart';


class ChannelPage extends StatefulWidget {
  final String title = "Test";
  final Channel channel;

  ChannelPage({Key key, @required this.channel})
    : super(key: key);

  ChannelState createState() => new ChannelState();
}

class ChannelState extends State<ChannelPage> {
  TextEditingController _controller = new TextEditingController();
  bool _isWriting = false;
  User currentUser;

  void initState() {
    super.initState();
    currentUser = new User(new Random().nextInt(10000000).toString(), new Random().nextInt(532151).toString());

    Connection.getChannel().stream.listen(
            (jsonString){
              Map message = json.decode(jsonString);
              print(message);
              var event = new MessageEvent.fromJson(message);
              ChannelManager.newMessage(event);
              setState(() => currentUser);
            }
    );
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(20.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Flexible(
                child: new ListView.builder(
                    shrinkWrap: false,
                    itemBuilder: (BuildContext context, int index) =>
                        _makeElement(index),
                  reverse: true,
                  padding: new EdgeInsets.all(6.0),
                )
            ),
            new Divider(height: 1.0,),
            new Container(
              child: _buildComposer(),
              decoration: new BoxDecoration(color: Theme.of(context).cardColor),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 9.0),
          child: new Row(
            children: <Widget>[
              new Flexible(
                child: new TextField(
                  controller: _controller,
                  onChanged: (String txt) {
                    setState(() {
                      _isWriting = txt.length > 0;
                    });
                  },
                  onSubmitted: _submitMsg,
                  decoration:
                  new InputDecoration.collapsed(
                      hintText: "Send a message",
                      //enabled: Connection.getChannel().closeReason == null
                  ),
                ),
              ),
              new Container(
                  margin: new EdgeInsets.symmetric(horizontal: 3.0),
                  child: Theme.of(context).platform == TargetPlatform.iOS
                      ? new CupertinoButton(
                      child: new Text("Submit"),
                      onPressed: _isWriting ? () => _submitMsg(_controller.text)
                          : null
                  )
                      : new IconButton(
                    icon: new Icon(Icons.message),
                    onPressed: _isWriting
                        ? () => _submitMsg(_controller.text)
                        : null,
                  )
              ),
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? new BoxDecoration(
              border:
              new Border(top: new BorderSide(color: Colors.brown))) :
          null
      ),
    );
  }

  Widget _makeElement(int index) {
    if (index >= widget.channel.messageHistory.length) return null;

    Message msg = widget.channel.messageHistory[index];

    TextAlign sender = msg.user.guid == currentUser.guid ? TextAlign.right : TextAlign.left;

    return Container(
      padding: EdgeInsets.all(5.0),
      child: Text(
        msg.message,
        textAlign: sender,
      ),
    );
  }

  void _submitMsg(String txt) {
    MessageEvent messageEvent;
    if (_controller.text.isNotEmpty) {
      messageEvent = new MessageEvent(widget.channel.guid, new Message(_controller.text, currentUser));
      Connection.getChannel().sink.add(json.encode(messageEvent));
      _controller.text = '';
    }

    setState(() {
      _isWriting = false;
      widget.channel.addMessage(messageEvent);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
