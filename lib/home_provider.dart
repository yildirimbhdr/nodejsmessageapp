import 'package:flutter/widgets.dart';
import 'package:nodejsmessageapp/message_model.dart';

class HomeProvider extends ChangeNotifier{
  final List<Message> messages = [];

  addMessage(Message message){
    messages.add(message);
    notifyListeners();
    print(messages);
  }
}