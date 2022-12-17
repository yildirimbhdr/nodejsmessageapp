import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nodejsmessageapp/home_provider.dart';
import 'package:nodejsmessageapp/message_view.dart';
import 'package:provider/provider.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controllerSender = TextEditingController();
  TextEditingController _controllerReceiver = TextEditingController();
  TextEditingController _controllerKonusmaId = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextFormField(
          decoration: InputDecoration(labelText: "Gönderici adı"),
          
          controller: _controllerSender,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: "Alıcı adı"),
          controller: _controllerReceiver,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: "Konusma id"),
          controller: _controllerKonusmaId,
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                  create: (context) => HomeProvider(),
                  builder: ((context, child) => MessageView(
                        konusmaId: int.parse(_controllerKonusmaId.text),
                        receiverUsername: _controllerReceiver.text,
                        senderUsername: _controllerSender.text,
                      )),
                ),
              ),
            );
          },
          child: const Text('Git'),
        ),
      ],
    ));
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
