import 'package:eys/Commun/Drawer.dart';
import 'package:eys/Events/EventListItem.dart';
import 'package:flutter/material.dart';

class AvailableEvents extends StatelessWidget {
  static const String routeName = '/availableEvents';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Available Events")),
      body: Center(child: EventListItem()),
      drawer: AppDrawer(),
    );
  }
}