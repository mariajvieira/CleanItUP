
class Event {
  final String title;
  final String description;
  final String location;
  final String time;
  final String district;

  Event(this.title, this.description, this.location, this.time, this.district);

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'time': time,
      'district': district,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      map['title'],
      map['description'],
      map['location'],
      map['time'],
      map['district'],
    );
  }
}