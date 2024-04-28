import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  
  
  const CalendarScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 60.0),
              const Text(
                'Upcoming Sustainability Activities',
                style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 2.0,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold
                ),
              ),

              const SizedBox(height: 20.0),
              
              _buildAchievementsSection(),
              
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Events seen succesfully."),
                    )); 
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red
                ),
                child: const Text(
                  'Set all events seen',
                  style: TextStyle(
                    color: Colors.white
                  ),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



  Widget _buildAchievementsSection() {
    // part of achievements
    List<String> achievementIcons = [
      //acrescentar
      'assets/icon.png',
      'assets/icon_.png',
      'assets/icon_.png',
      'assets/icon_.png',
      'assets/icon_.png',
      'assets/icon_.png',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'My events',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Wrap(
          children: [Container(
            height: 350.0,
          child: ListView.separated(
            scrollDirection: Axis.vertical,
            itemCount: achievementIcons.length,
            separatorBuilder: (context, index) => SizedBox(width: 10),
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.all(10),
                
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget> [
                      const Text(
                        "Storm",
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          backgroundColor: Colors.blue
                        ),
                      ),
                    
                    const Text(
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Color.fromARGB(255, 114, 114, 114),
                          fontWeight: FontWeight.w400
                        ),
                      ),

                  const SizedBox(height: 5.0),

                  const Divider(height: 2.0)

                  ],

                )
              );
            },
          ),
        ),
       ],
        ),
         
      ],
    );
  }

