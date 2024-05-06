import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

  class _CalendarScreenState extends State<CalendarScreen>{
    
    String dailyAction = "";

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
    

    void updateSelectedItem(String item) {
    setState(() {
      dailyAction = item;
      print("Daily action updated to: $dailyAction");
    });
  }


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
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            return TextButton(
                              onPressed: () => {
                                updateSelectedItem(dailyActivities[index])
                              },
                              child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: 
                                      Text(
                                        achievementIcons[index],
                                        selectionColor: Colors.black,
                                        style: TextStyle(
                                            fontSize: 24.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            backgroundColor: Colors.blue),
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

              
              Text(
                dailyAction,
                style : TextStyle(
                  color : Colors.black
                )
              ),

              const SizedBox(height: 200.0),

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