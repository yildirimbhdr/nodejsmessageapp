import 'package:flutter/material.dart';
import 'package:nodejsmessageapp/home_provider.dart';
import 'package:nodejsmessageapp/message_model.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MessageView extends StatefulWidget {
  final String username;
  const MessageView({super.key, required this.username});

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  late IO.Socket _socket;
  _connectSocket() async {
    _socket.connect();
    _socket.onConnect((data) => print("CONNECTED"));
    _socket.onConnectError((data) => print("NOT CONNECTED $data"));
    _socket.on('message', (data) {
      Provider.of<HomeProvider>(context, listen: false)
          .addMessage(Message.fromJson(data));
    });
  }

  final TextEditingController _messageInput = TextEditingController();

  @override
  void initState() {
    _socket = IO.io(
        "http://104.247.163.113:3000",
        IO.OptionBuilder().setTransports(['websocket']).setQuery(
            {'username': widget.username}).build());
    _connectSocket();
  }

  _sendMessage() {
    _socket.emit(
      'message',
      {'message': _messageInput.text, 'sender': widget.username},
    );
    _messageInput.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: context.watch<HomeProvider>().messages.length,
            itemBuilder: ((context, index) {
              Message _message = context.watch<HomeProvider>().messages[index];
              return Row(
                mainAxisAlignment:  _message.senderUsername == widget.username ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(5),
                    color: _message.senderUsername == widget.username ?  Colors.purple.withOpacity(0.2) : Colors.green.withOpacity(0.2),
                    
                    child: Text(_message.message),
                  ),
                ],
              );
            }),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageInput,
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      _sendMessage();
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
