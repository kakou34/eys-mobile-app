import 'dart:developer';

import 'package:eys/Commun/Drawer.dart';
import 'package:eys/Commun/MessageResponse.dart';
import 'package:eys/Events/FormQuestion.dart';
import 'package:eys/Globals.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json, base64, ascii;

final String SERVER_IP = Globals.SERVER_IP;

class FormQuestions extends StatefulWidget {
  final String eventName;

  FormQuestions(this.eventName);

  @override
  _FormQuestionState createState() => _FormQuestionState(eventName: eventName);
}

class _FormQuestionState extends State<FormQuestions> {
  final String eventName;

  _FormQuestionState({this.eventName});

  List<FormQuestion> _questions = [
    new FormQuestion("First Name:"),
    new FormQuestion("Last Name:"),
    new FormQuestion("TC:")
  ];
  List<TextEditingController> _controllers = [
    new TextEditingController(text: Globals.currentUser.firstname),
    new TextEditingController(text: Globals.currentUser.lastname),
    new TextEditingController(text: Globals.currentUser.turkishID),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Apply for :" + eventName)),
      body: Column(
          children: _questions
              .asMap()
              .entries
              .map(
                (question) => TextField(
                  enabled: (question.key > 2),
                  controller: _controllers[question.key],
                  decoration:
                      InputDecoration(labelText: question.value.question),
                ),
              )
              .toList()),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var response = await applyForEvent();
          log(response);
          if(response == "success") {
            displayDialog(context, "Success", "Your application has been submitted");
          }
        },
        child: Icon(Icons.assignment_turned_in),
        backgroundColor: Colors.blue,
      ),
      drawer: AppDrawer(),
    );
  }

  Future<String> fetchQuestions(String eventName) async {
    final response = await http.get(
      '$SERVER_IP/events/$eventName/questions',
      headers: {
        'Authorization': 'Bearer ' + Globals.token,
        'Accept': 'application/json'
      },
    );

    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    List<FormQuestion> quesList = parsed
        .map<FormQuestion>((json) => FormQuestion.fromJson(json))
        .toList();

    List<TextEditingController> controllers = [];

    quesList.forEach((element) {
      controllers.add(new TextEditingController());
    });
    setState(() {
      _questions.addAll(quesList);
      _controllers.addAll(controllers);
    });
    return "data fetched";
  }

  Future<String> applyForEvent() async {
    bool empty = _controllers.any((element) => element.text.trim().length == 0);
    if (empty) {
      displayDialog(
          context, "ERROR", "Please answer all questions and try again");
    } else {
      try {
        var res = await http.post(
          "$SERVER_IP/apply/" + eventName + "/" + Globals.currentUser.username,
          headers: {
            'Authorization': 'Bearer ' + Globals.token,
            'Accept': 'application/json'
          },
          body: null,
        );
        MessageResponse msg = MessageResponse.fromJson(json.decode(res.body));
        if (msg.messageType == "ERROR") {
          displayDialog(context, "ERROR", msg.message);
          return "Error";
        } else {
          if (_questions.length > 3) {
            for (int i = 3; i < _questions.length; i++) {
              Future<MessageResponse> ms =
                  answerQuestion(_questions[i].question, _controllers[i].text);
            }
          }
        }
        return "success";
      } catch (e) {
        log("EXCEPTION: " + e.toString());
        return null;
      }
    }
  }

  Future<MessageResponse> answerQuestion(String question, String answer) async {
    try {
      final ans = json.encode({"answer": answer});
      var res = await http.post(
        "$SERVER_IP/apply/" +
            Uri.encodeComponent(eventName) +
            "/" +
            Uri.encodeComponent(Globals.currentUser.username) +
            "/" +
            Uri.encodeComponent(question),
        headers: {
          'Authorization': 'Bearer ' + Globals.token,
          'content-type': 'application/json'
        },
        body: ans,
      );
      return MessageResponse.fromJson(json.decode(res.body));
    } catch (e) {
      log("EXCEPTION" + e.toString());
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    this.fetchQuestions(eventName);
    log("controllers length: " + _controllers.length.toString());
  }

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );
}
