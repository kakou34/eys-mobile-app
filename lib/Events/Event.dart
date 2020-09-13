class Event {
  final String name;
  final String startDate;
  final String endDate;
  final double latitude;
  final double longitude;

  Event({this.name,
    this.startDate,
    this.endDate,
    this.latitude,
    this.longitude,
    });



  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      name: json['name'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      latitude: json['altitude'],
      longitude: json['longitude'],
    );
  }
}
