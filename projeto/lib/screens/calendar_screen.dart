import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../JsonModels/users.dart';
import 'add_event_screen.dart';

const Color backgroundColor = Color(0xFFF5F5F5);
const Color appBarColor = Color(0xFF00796B);
const Color cardColor = Color(0xFFFFFFFF);
const Color primaryTextColor = Color(0xFF212121);
const Color secondaryTextColor = Color(0xFF757575);

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

class CalendarScreen extends StatefulWidget {
  final Users user;

  const CalendarScreen({Key? key, required this.user}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String _selectedDistrict = 'All';
  List<String> _districts = [
    'All', 'Aveiro', 'Beja', 'Braga', 'Bragança', 'Castelo Branco', 'Coimbra',
    'Évora', 'Faro', 'Guarda', 'Leiria', 'Lisbon', 'Portalegre', 'Porto',
    'Santarém', 'Setúbal', 'Viana do Castelo', 'Vila Real', 'Viseu'
  ];

  Map<DateTime, List<Event>> _events = {};

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  DateTime _stripTime(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  Future<void> _loadEvents() async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('events').get();
      Map<DateTime, List<Event>> events = {};
      for (var doc in snapshot.docs) {
        DateTime date = _stripTime((doc['date'] as Timestamp).toDate());
        if (events[date] == null) events[date] = [];
        events[date]!.add(Event.fromMap(doc.data()));
      }
      setState(() {
        _events = events;
      });
      print('Events loaded: $_events');
    } catch (e) {
      print('Error loading events: $e');
    }
  }

  Future<void> _addEvent(Event event, DateTime date) async {
    try {
      await FirebaseFirestore.instance.collection('events').add({
        'title': event.title,
        'description': event.description,
        'location': event.location,
        'time': event.time,
        'district': event.district,
        'date': Timestamp.fromDate(date),
      });

      setState(() {
        DateTime eventDate = _stripTime(date);
        if (_events[eventDate] == null) _events[eventDate] = [];
        _events[eventDate]!.add(event);
      });
    } catch (e) {
      print('Error adding event: $e');
    }
  }

  void _launchURL(String url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }

  Widget _buildEventCard(Event event) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            title: Text(event.title, style: TextStyle(color: primaryTextColor)),
            subtitle: Text('${event.time} - ${event.location}', style: TextStyle(color: secondaryTextColor)),
          ),
        ],
      ),
    );
  }

  void _showEventDetails(List<Event> events) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: events.map((event) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(event.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text(event.description, style: TextStyle(fontSize: 18)),
              Text('Location: ${event.location}', style: TextStyle(fontSize: 16)),
              Text('Time: ${event.time}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              ElevatedButton(
                child: Text("Share"),
                onPressed: () {
                  _launchURL(""); //acrescentar
                },
              ),
              ElevatedButton(
                child: Text("I'll attend"),
                onPressed: () {
                  // acrescentar
                },
              ),
              Divider()
            ],
          )).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Event>? _selectedEvents = _selectedDay != null
        ? _events[_stripTime(_selectedDay!)]
        ?.where((event) =>
    _selectedDistrict == 'All' || event.district == _selectedDistrict)
        .toList()
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text('Upcoming Events', style: TextStyle(color: Colors.white)),
        backgroundColor: appBarColor,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddEventScreen()));
              if (result != null && result is Map<String, dynamic>) {
                final newEvent = Event.fromMap(result);
                _addEvent(newEvent, result['date']);
              }
            },
          )
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                value: _selectedDistrict,
                onChanged: (value) {
                  setState(() {
                    _selectedDistrict = value!;
                  });
                },
                items: _districts.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2025, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              List<Event>? dayEvents = _events[_stripTime(selectedDay)];
              if (dayEvents != null && dayEvents.isNotEmpty) {
                _showEventDetails(dayEvents);
              } else {
                print('No events on this day');
              }
            },
            eventLoader: (day) {
              return _events[_stripTime(day)]
                  ?.where((event) => _selectedDistrict == 'All' || event.district == _selectedDistrict)
                  .toList() ??
                  [];
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _selectedEvents?.length ?? 0,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_selectedEvents![index].title),
                  subtitle: Text('Location: ${_selectedEvents[index].location} - ${_selectedEvents[index].district}'),
                  onTap: () {
                    List<Event>? dayEvents = _events[_stripTime(_selectedDay!)];
                    if (dayEvents != null) {
                      _showEventDetails(dayEvents);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
