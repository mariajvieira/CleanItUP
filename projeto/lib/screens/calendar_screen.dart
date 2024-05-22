import 'package:flutter/material.dart';
import 'package:projeto/screens/userprofile_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../JsonModels/event.dart';
import '../JsonModels/users.dart';
import 'add_event_screen.dart';
import 'forum_screen.dart';
import 'map_screen.dart';
import 'near_me_screen.dart';

const Color backgroundColor = Color(0xFFF5F5F5);
const Color appBarColor = Color(0xFF00796B);
const Color cardColor = Color(0xFFFFFFFF);
const Color primaryTextColor = Color(0xFF212121);
const Color secondaryTextColor = Color(0xFF757575);

class CalendarScreen extends StatefulWidget {
  final Users user;
  const CalendarScreen({Key? key, required this.user}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int _selectedIndex = 3;
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
  List<Event> _attendingEvents = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
    _loadAttendingEvents();
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

  Future<void> _loadAttendingEvents() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.id)
          .collection('attendingEvents')
          .get();
      List<Event> attendingEvents = snapshot.docs.map((doc) => Event.fromMap(doc.data())).toList();
      setState(() {
        _attendingEvents = attendingEvents;
      });
      print('Attending events loaded: $_attendingEvents');
    } catch (e) {
      print('Error loading attending events: $e');
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

  Future<void> _markEventAsAttending(Event event) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.id)
          .collection('attendingEvents')
          .doc(event.title)
          .set(event.toMap());

      setState(() {
        _attendingEvents.add(event);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Marked as attending')),
      );
    } catch (e) {
      print('Error marking event as attending: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to mark as attending')),
      );
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
                  _launchURL("");
                },
              ),
              ElevatedButton(
                child: Text("I'll attend"),
                onPressed: () {
                  _markEventAsAttending(event);
                },
              ),
              Divider()
            ],
          )).toList(),
        ),
      ),
    );
  }

  void _showAttendingEvents() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: _attendingEvents.map((event) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(event.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text(event.description, style: TextStyle(fontSize: 18)),
              Text('Location: ${event.location}', style: TextStyle(fontSize: 16)),
              Text('Time: ${event.time}', style: TextStyle(fontSize: 16)),
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.teal,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            label: 'Global',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.radio_button_checked),
            label: 'Near me',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
      appBar: AppBar(
        title: Text('Upcoming Events', style: TextStyle(color: Colors.white)),
        backgroundColor: appBarColor,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: _showAttendingEvents,
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddEventScreen(user: widget.user)));
              if (result != null && result is Map<String, dynamic>) {
                final newEvent = Event.fromMap(result);
                _addEvent(newEvent, result['date']);
              }
            },
          ),
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ForumScreen(user: widget.user)),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MapScreen(user: widget.user)),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NearMeScreen(user: widget.user)),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CalendarScreen(user: widget.user)),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserProfile(user: widget.user)),
        );
        break;
    }
  }
}
