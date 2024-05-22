import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projeto/screens/calendar_screen.dart';
import 'package:projeto/screens/map_screen.dart';
import 'package:projeto/screens/userprofile_screen.dart';
import 'package:projeto/JsonModels/event.dart';
import 'package:projeto/JsonModels/users.dart';
import 'package:table_calendar/table_calendar.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}

class MockQuerySnapshot extends Mock implements QuerySnapshot<Map<String, dynamic>> {}

class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot<Map<String, dynamic>> {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('Calendar loads events correctly', (WidgetTester tester) async {
    // Mock Firestore
    final mockFirestore = MockFirebaseFirestore();
    final mockCollection = MockCollectionReference();
    final mockQuerySnapshot = MockQuerySnapshot();
    final mockQueryDocumentSnapshot = MockQueryDocumentSnapshot();

    // Mock user
    final user = Users(id: '1', firstName: 'Test', lastName: 'User', email: 'up123@up.pt');

    // Stub the Firestore collection method to return a mocked collection
    when(mockFirestore.collection('events')).thenReturn(mockCollection);

    // Stub the Firestore collection's get method to return a mocked query snapshot
    when(mockCollection.get()).thenAnswer((_) async => mockQuerySnapshot);

    // Stub the Firestore query snapshot to have mock documents
    when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
    when(mockQueryDocumentSnapshot.data()).thenReturn({
      'title': 'Test Event',
      'description': 'Test Description',
      'location': 'Test Location',
      'time': '10:00 AM',
      'district': 'Lisbon',
      'date': Timestamp.now(),
    });

    // Build the CalendarScreen widget
    await tester.pumpWidget(
      MaterialApp(
        home: CalendarScreen(user: user),
      ),
    );

    // Verify if the CalendarScreen is displayed
    expect(find.text('Upcoming Events'), findsOneWidget);

    // Verify if the calendar widget is displayed
    expect(find.byType(TableCalendar), findsOneWidget);

    // Wait for events to load
    await tester.pumpAndSettle();

    // Verify if events are loaded correctly (you can customize this as needed)
    expect(find.byType(Card), findsOneWidget); // Adjust the expected number of widgets
  });

  testWidgets('District dropdown changes and filters events', (WidgetTester tester) async {
    // Mock user
    final user = Users(id: '1', firstName: 'Test', lastName: 'User', email: 'up123@up.pt');

    // Build the CalendarScreen widget
    await tester.pumpWidget(
      MaterialApp(
        home: CalendarScreen(user: user),
      ),
    );

    // Verify the dropdown is displayed
    expect(find.byType(DropdownButton<String>), findsOneWidget);

    // Select a district from the dropdown
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lisbon').last);
    await tester.pumpAndSettle();

    // Verify if the selected district is changed and displayed correctly
    expect(find.text('Lisbon'), findsOneWidget);

    // Verify if events are filtered correctly (you can customize this as needed)
    // Add events to mock Firestore and check if they are filtered by district
  });

  testWidgets('Bottom navigation bar navigation', (WidgetTester tester) async {
    // Mock user
    final user = Users(id: '1', firstName: 'Test', lastName: 'User', email: 'up123@up.pt');

    // Build the CalendarScreen widget
    await tester.pumpWidget(
      MaterialApp(
        home: CalendarScreen(user: user),
      ),
    );

    // Verify the bottom navigation bar is displayed
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Tap on the Map icon and verify the navigation
    await tester.tap(find.byIcon(Icons.map));
    await tester.pumpAndSettle();

    // Verify if the MapScreen is displayed
    expect(find.byType(MapScreen), findsOneWidget);

    // Navigate back to CalendarScreen
    await tester.tap(find.byIcon(Icons.calendar_today));
    await tester.pumpAndSettle();

    // Tap on the Profile icon and verify the navigation
    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();

    // Verify if the UserProfile is displayed
    expect(find.byType(UserProfile), findsOneWidget);

    // Navigate back to CalendarScreen
    await tester.tap(find.byIcon(Icons.calendar_today));
    await tester.pumpAndSettle();
  });
}
