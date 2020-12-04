import 'package:flutter/material.dart';
import 'package:finished_chatbot_dartup/chatbot.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter ChatBot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Chatbot(),
    );
  }
}
