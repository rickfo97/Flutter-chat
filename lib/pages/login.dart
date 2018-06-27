import 'package:flutter/material.dart';
import 'package:flutter_chat/utils/user.dart';
import 'package:flutter_chat/utils/channel_manager.dart';
import 'package:flutter_chat/pages/channel.dart';
import 'dart:math';

class LoginPage extends StatelessWidget {
  final _hintText = "Username";
  TextEditingController _controller = new TextEditingController();
  BuildContext _context;

  Widget build(BuildContext context) {
    _context = context;
    return new Material(
      color: Colors.lightBlueAccent,
      child: new InkWell(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              "Flutter chat app",
              style: new TextStyle(
                  color: Colors.white,
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold),
            ),
            new Text(
              "Select a username",
              style: new TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            new Container(
              margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: new TextField(
                  autocorrect: false,
                  autofocus: true,
                  controller: _controller,
                  textAlign: TextAlign.center,
                  onSubmitted: _gotoChat,
                  decoration: new InputDecoration.collapsed(hintText: _hintText)),
            ),
            new RaisedButton(
              onPressed: _gotoChat,
              child: new Text(
                "LOGIN",
              ),
            )
          ],
        ),
      ),
    );
  }

  void _gotoChat([name]) {
    User user =
        new User(new Random().nextInt(9999999).toString(), _controller.text);
    UserManager.setUser(user);
    Navigator.of(_context).push(new MaterialPageRoute(
        builder: (BuildContext context) =>
            new ChannelPage(channel: ChannelManager.getChannel(0))));
  }
}
