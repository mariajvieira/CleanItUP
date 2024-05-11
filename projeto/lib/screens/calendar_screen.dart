import 'package:flutter/material.dart';
import 'package:projeto/JsonModels/users.dart';
import 'forum_screen.dart';
import 'map_screen.dart';
import 'userprofile_screen.dart';
import 'package:projeto/screens/calendar_screen.dart';

class CalendarScreen extends StatefulWidget {
  final Users user; // Add this line to accept a Users object

  const CalendarScreen({Key? key, required this.user}) : super(key: key); // Modify constructor

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int _selectedIndex = 3; // Index for 'Calendar'

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ForumScreen()));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const MapScreen()));
        break;
      case 2:
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfile(user: widget.user))); // Pass the user to UserProfile
        break;
    }
  }

  String selectedDate = ""; // Store the selected date
  Map<String, List<String>> events = {
    '02.05.2024': ["Some activity 1"],
    '08.05.2024': ["Some activity 2"],
    '16.05.2024': ["Some activity 3"],
    '22.05.2024': ["Some activity 4"],
    '28.05.2024': ["Some activity 5"],
    '03.06.2024': ["Some activity 6", "Some activity 7"],
  };

  List<MapEntry<String, String>> getUpcomingEvents() {
    List<MapEntry<String, String>> upcomingEvents = [];
    var now = DateTime.now();
    events.forEach((key, value) {
      var dateComponents = key.split('.');
      var eventDate = DateTime(
          int.parse(dateComponents[2]), int.parse(dateComponents[1]),
          int.parse(dateComponents[0]));
      if (eventDate.isAfter(now) || eventDate.isAtSameMomentAs(now)) {
        upcomingEvents.add(MapEntry(key, value.join(", ")));
      }
    });
    upcomingEvents.sort((a, b) {
      var aDate = DateTime.parse("${a.key.split('.').reversed.join('-')}T00:00:00Z");
      var bDate = DateTime.parse("${b.key.split('.').reversed.join('-')}T00:00:00Z");
      return aDate.compareTo(bDate);
    });
    return upcomingEvents.take(2).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<MapEntry<String, String>> upcomingEvents = getUpcomingEvents();

    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 24.0),
            const Text(
              'Upcoming Sustainability Activities',
              style: TextStyle(
                color: Colors.black,
                letterSpacing: 2.0,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              'Selected Date: $selectedDate',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            if (selectedDate.isNotEmpty)
              Text(
                events[selectedDate]?.join(", ") ?? "No events on this date",
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2025),
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = "${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}";
                  });
                }
              },
              child: const Text('Pick a Date'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedDate = "";
                });
              },
              child: const Text('Reset'),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Next Events:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: ListView.builder(
                itemCount: upcomingEvents.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = upcomingEvents[index].key;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        '${upcomingEvents[index].value} (${upcomingEvents[index].key})',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: selectedDate == upcomingEvents[index].key
                              ? Colors.blue
                              : Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
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
    );
  }
}
