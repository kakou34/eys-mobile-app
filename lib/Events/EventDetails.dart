import 'package:eys/Commun/Drawer.dart';
import 'package:eys/Events/Event.dart';
import 'package:eys/Events/FormQuestions.dart';
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(event.name),
            Text("Start Date: " + event.startDate),
            Text("End Date: " + event.endDate),
            FlatButton(
              onPressed: () => _launchMapsUrl(event.latitude , event.longitude),
              child: Text("Show on Maps"),
            ),
            FlatButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FormQuestions(event.name),
                ),
              ),
              child: Text("Application Form"),
            ),
          ],
        ),
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
