import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

class Chatbot extends StatefulWidget {
  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<Chatbot> {
  final List<Message> _messages = <Message>[];
  final TextEditingController _textController = TextEditingController();

  void _getMessage(text) async {
    _textController.clear();
    AuthGoogle authGoogle = await AuthGoogle(
      fileJson: "assets/flutterchatbot-rntr-ae3bdfe9d4a9.json",
    ).build();

    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse response = await dialogflow.detectIntent(text);

    Message message = Message(
      text: response.getMessage() ??
          CardDialogflow(
            response.getListMessage()[0],
          ).title,
      name: "Flutter ChatBot",
      isMyMessage: false,
    );
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _sendMessage(String text) {
    _textController.clear();
    Message message = Message(
      text: text,
      name: "Matej",
      isMyMessage: true,
    );
    setState(() {
      _messages.insert(0, message);
    });
    _getMessage(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter ChatBot"),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
              child: ListView.builder(
            padding: EdgeInsets.all(8.0),
            reverse: true,
            itemBuilder: (_, int index) => _messages[index],
            itemCount: _messages.length,
          )),
          Divider(height: 1.0),
          Container(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      controller: _textController,
                      autocorrect: false,
                      enableSuggestions: false,
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () => _sendMessage(_textController.text),
                    ),
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

class Message extends StatelessWidget {
  final String text;
  final String name;
  final bool isMyMessage;

  Message({
    this.text,
    this.name,
    this.isMyMessage,
  });

  List<Widget> botMessage(context) {
    return <Widget>[
      Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: CircleAvatar(
          child: Text(this.name[0]),
          backgroundColor: Colors.red,
        ),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              this.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: Text(text),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> myMessage(context) {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              this.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: Text(text),
            ),
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: CircleAvatar(
          child: Text(this.name[0]),
        ),
      ),
    ];
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.isMyMessage ? myMessage(context) : botMessage(context),
      ),
    );
  }
}
// inspirated by: Promise Amadi, @promise_amadi1