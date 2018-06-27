import 'package:flutter/material.dart';
import 'package:flutter_chat/utils/channel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat/utils/server_connection.dart';
import 'package:flutter_chat/utils/message.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:flutter_chat/utils/user.dart';
import 'package:flutter_chat/utils/channel_manager.dart';
import 'package:flutter_chat/events/message_event.dart';

class ChannelPage extends StatefulWidget {
  final String title = "Test";
  final Channel channel;

  ChannelPage({Key key, @required this.channel}) : super(key: key);

  ChannelState createState() => new ChannelState();
}

class ChannelState extends State<ChannelPage> {
  TextEditingController _controller = new TextEditingController();
  bool _isWriting = false;
  final String hintText = "Send a message";
  StreamSubscription _subscription;

  void initState() {
    _subscription = widget.channel.newMessage.listen((m) => setState(() => _isWriting));

    super.initState();
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
                // TODO: Switch to animatedList or scrollview?
                child: new ListView.builder(
              // Want it to take up as much space as possible
              shrinkWrap: false,
              itemBuilder: (BuildContext context, int index) =>
                  _makeElement(index),
              reverse: true,
              padding: new EdgeInsets.all(6.0),
            )),
            new Divider(
              height: 1.0,
            ),
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
                  decoration: new InputDecoration.collapsed(
                    hintText: hintText,
                    //enabled: Connection.getChannel().closeReason == null
                  ),
                ),
              ),
              new Container(
                  margin: new EdgeInsets.symmetric(horizontal: 3.0),
                  child: Theme.of(context).platform == TargetPlatform.iOS
                      ? new CupertinoButton(
                          child: new Text("Submit"),
                          onPressed: _isWriting
                              ? () => _submitMsg(_controller.text)
                              : null)
                      : new IconButton(
                          icon: new Icon(Icons.message),
                          onPressed: _isWriting
                              ? () => _submitMsg(_controller.text)
                              : null,
                        )),
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? new BoxDecoration(
                  border: new Border(top: new BorderSide(color: Colors.brown)))
              : null),
    );
  }

  /*
  *   make each element of the listview based on the channel messages list
  *   TODO: Style if message is being sent or failed to deliver
   */
  Widget _makeElement(int index) {
    if (index >= widget.channel.messageHistory.length) return null;

    Message msg = widget.channel.messageHistory[index];

    bool previousSender = false;
    if(index < widget.channel.messageHistory.length){
      Message previousMsg = widget.channel.messageHistory[index + 1];
      previousSender = msg.user.guid == previousMsg.user.guid;
    }

    bool sender = msg.user.guid == UserManager.getUser().guid;

    TextAlign msgAlign = sender ? TextAlign.right : TextAlign.left;

    return Container(
        padding: EdgeInsets.all(10.0),
        margin: previousSender ? null : new EdgeInsets.all(4.0),
        decoration: new BoxDecoration(
          color: sender
              ? Theme.of(context).primaryColor
              : Theme.of(context).splashColor,
          borderRadius:
              new BorderRadius.all(new Radius.elliptical(120.0, 120.0)),
        ),
        child: new Column(
          crossAxisAlignment:
              sender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children:
            _buildMessage(msg, msgAlign, previousSender),
        ));
  }

  List<Widget> _buildMessage(Message msg, TextAlign align, bool previous){
    List<Widget> messageWidget = new List();
    if(previous)
      messageWidget.add(Text(
        msg.user.username,
        textAlign: align,
        style: Theme.of(context).textTheme.subhead,
      ));
    messageWidget.add(Text(
      msg.message,
      textAlign: align,
    ));
    return messageWidget;
  }

  //  Send a new message to server and add it to message history
  void _submitMsg(String txt) {
    MessageEvent messageEvent;
    if (_controller.text.isNotEmpty) {
      messageEvent = new MessageEvent(widget.channel.guid,
          new Message(_controller.text, UserManager.getUser()));
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
    _subscription.cancel();
    super.dispose();
  }
}
