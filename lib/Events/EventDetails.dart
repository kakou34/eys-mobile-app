import 'package:eys/Commun/Drawer.dart';
import 'package:eys/Events/Event.dart';
import 'package:eys/Events/FormQuestions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetails extends StatelessWidget {
  // Declare a field that holds the Event.
  final Event event;

  // In the constructor, require an Event
  EventDetails({Key key, @required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the Event to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text(event.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              decoration: new BoxDecoration(color: Colors.blue),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(10.0),
              child: new Text(event.name,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white))),
          Padding(
              padding: EdgeInsets.fromLTRB(40, 40, 20, 20),
              child: Text('Start Date: \t' + event.startDate,
                  style: TextStyle(fontSize: 18))),
          Padding(
              padding: EdgeInsets.fromLTRB(40, 20, 20, 20),
              child: Text('End Date: \t' + event.startDate,
                  style: TextStyle(fontSize: 18))),
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(10.0),
              child: new ButtonBar(
                children: <Widget>[
                  FlatButton(
                    onPressed: () => _launchMapsUrl(event.latitude, event.longitude),
                    color: Colors.blue,
                    child: Icon(Icons.location_on),
                  ),
                  FlatButton(
                    color: Colors.blue,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FormQuestions(event.name),
                      ),
                    ),
                    child: Text("Application Form"),
                  ),
                ],
              )),


        ],
      ),
      drawer: AppDrawer(),
    );
  }

  void _launchMapsUrl(double lat, double lon) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
