import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:projeto/screens/calendar_screen.dart';
import 'package:projeto/JsonModels/users.dart';


void main() {
  group('CalendarScreen', () {
    test('getUpcomingEvents should return upcoming events', () {
      // Create a mock Users object to pass to the CalendarScreen
      final Users user = Users(
        userName: "jd123@up.pt",
        userPassword: "password123",
        firstName: "John",
        lastName: "Doe",
      );

      // Create a CalendarScreen instance passing the mock Users object
      final calendarScreen = CalendarScreen(user: user);

      // Get the state of the CalendarScreen
      final calendarScreenState = calendarScreen.createState();

      // Call the getUpcomingEvents method
      final upcomingEvents = calendarScreenState.getUpcomingEvents();

      // Assertions
      // Assert that upcomingEvents is not null
      expect(upcomingEvents, isNotNull);

      // Assert that the length of upcomingEvents is as expected
      expect(upcomingEvents.length, equals(1)); //Expected length is 1
    });

    test('getUpcomingEvents should handle edge cases', () {
      // Test when there are no upcoming events
      // Create a mock Users object to pass to the CalendarScreen
      final Users user = Users(
        userName: "john_doe",
        userPassword: "password123",
        firstName: "John",
        lastName: "Doe",
      );

      // Create a CalendarScreen instance passing the mock Users object
      final calendarScreen = CalendarScreen(user: user);

      // Get the state of the CalendarScreen
      final calendarScreenState = calendarScreen.createState();

      // Call the getUpcomingEvents method
      final upcomingEvents = calendarScreenState.getUpcomingEvents();

      expect(upcomingEvents, anyOf(isNull, isEmpty));

      // Test when there are no upcoming events
    });
    test('Date formatting function should format dates correctly', () {
      // Create a sample date to format
      final DateTime sampleDate = DateTime(2024, 5, 15);

      // Call the formatting function from DateUtils
      final formattedDate = Date_Utils.formatDate(sampleDate);

      // Assertions
      // Assert that the formatted date matches the expected format
      expect(formattedDate, equals('15.05.2024')); // Expected format: dd.mm.yyyy
    });

  group('CalendarScreen', () {
    testWidgets('Initial state test', (WidgetTester tester) async {
      // Build the CalendarScreen widget
      await tester.pumpWidget(MaterialApp(
        home: CalendarScreen(
          user: Users(
            userName: "jd123@up.pt",
            userPassword: "password123",
            firstName: "John",
            lastName: "Doe",
          ),
        ),
      ));

      // Verify initial state
      expect(find.text('Selected Date: '), findsOneWidget); // Selected date should be empty initially
      expect(find.text('Next Events:'), findsOneWidget); // Next events section should be present
    });

    testWidgets('Date picking test', (WidgetTester tester) async {
      // Build the CalendarScreen widget
      await tester.pumpWidget(MaterialApp(
        home: CalendarScreen(
          user: Users(
            userName: "jd123@up.pt",
            userPassword: "password123",
            firstName: "John",
            lastName: "Doe",
          ),
        ),
      ));

      // Tap the 'Pick a Date' button
      await tester.tap(find.text('Pick a Date'));
      await tester.pumpAndSettle(); // Wait for date picker dialog to appear
      
      // Select a date from the date picker
      await tester.tap(find.text('15'));
      await tester.pumpAndSettle(); // Wait for date picker to close

      // Verify selected date is updated
      expect(find.text('Selected Date: 15.05.2024'), findsOneWidget);
    });

  });
});
}
