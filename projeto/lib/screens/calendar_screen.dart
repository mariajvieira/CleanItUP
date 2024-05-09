import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  String selectedDate = ""; // Store the selected date

  List<String> achievementIcons = [
    '05.05.2024',
    '06.05.2024',
    '07.05.2024',
    '08.05.2024',
    '09.05.2024',
    '10.05.2024',
  ];

  List<String> dailyActivities = [
    "Some activity 1",
    "Some activity 2",
    "Some activity 3",
    "Some activity 4",
    "Some activity 5",
    "Some activity 6",
    "Some activity 7",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 24.0),
              const Text(
                'Upcoming Sustainability Activities',
                style: TextStyle(
                    color: Colors.black,
                    letterSpacing: 2.0,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Date',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Wrap(
                    children: [
                      Container(
                        height: 150.0,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: achievementIcons.length,
                          separatorBuilder: (context, index) => SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            return TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedDate = achievementIcons[index];
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  achievementIcons[index],
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    color: selectedDate == achievementIcons[index] ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.w700,
                                    backgroundColor: selectedDate == achievementIcons[index] ? Colors.blue : null,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Text(
                'Selected Date: $selectedDate',
                style: TextStyle(
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
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("You are joined to this event."),
                  ));
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text(
                  'Participate in this event.',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

    );
  }
}
