import 'dart:developer';

import 'package:eys/Events/Event.dart';
import 'package:eys/Events/EventDetails.dart';
import 'package:eys/Globals.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json, base64, ascii;

final String SERVER_IP = Globals.SERVER_IP;

class EventListItem extends StatefulWidget {
  @override
  _EventListItemState createState() => _EventListItemState();
}

class _EventListItemState extends State<EventListItem> {
  List<Event> _events;
  final _biggerFont = TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildAvailableEvents(),
    );
  }

  Widget _buildAvailableEvents() {
    return ListView.builder(
        padding: EdgeInsets.all(5.0),
        itemCount: _events == null ? 0 : _events.length,
        itemBuilder: (context, index) {
          return _buildRow(_events[index], index);
        });
  }

  Widget _buildRow(Event event, int index) {
    return Container(
        decoration: new BoxDecoration(color: index % 2 == 0? Colors.blue[50] : Colors.blueGrey[25]),
        child: new ListTile(
            title: Text(
              event.name,
              style: _biggerFont,
            ),
            subtitle: Text(event.startDate + " ~ " + event.endDate),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetails(event: event),
                ),
              );
            } //onTap
            ));
  }

  Future<String> fetchNextEvents() async {
    log("golabls.token: " + Globals.token);
    final response = await http.get(
      '$SERVER_IP/events/next',
      headers: {
        'Authorization': 'Bearer ' + Globals.token,
        'Accept': 'application/json'
      },
    );

    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    List<Event> evs =
        parsed.map<Event>((json) => Event.fromJson(json)).toList();
    // Use the compute function to run parsePhotos in a separate isolate.
    setState(() {
      // Get the JSON data
      _events = evs;
    });
    return "data fetched";
  }

// A function that converts a response body into a List<Event>.
  List<Event> parseEvents(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Event>((json) => Event.fromJson(json)).toList();
  }

  @override
  void initState() {
    super.initState();
    this.fetchNextEvents();
  }
}
