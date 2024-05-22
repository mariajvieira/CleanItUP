import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';
import 'package:projeto/JsonModels/users.dart';
import 'package:projeto/screens/userprofile_screen.dart';

// Mock classes for Firestore
class MockFirestoreInstance extends Mock implements FirebaseFirestore {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot<Map<String, dynamic>> {
  final Map<String, dynamic> _data;

  MockDocumentSnapshot(this._data);

  @override
  Map<String, dynamic> data() => _data;
}

class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot<Map<String, dynamic>> {
  final Map<String, dynamic> _data;

  MockQueryDocumentSnapshot(this._data);

  @override
  Map<String, dynamic> data() => _data;
}

class MockQuerySnapshot extends Mock implements QuerySnapshot<Map<String, dynamic>> {
  final List<MockQueryDocumentSnapshot> _docs;

  MockQuerySnapshot(this._docs);

  @override
  List<QueryDocumentSnapshot<Map<String, dynamic>>> get docs => _docs;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final Users testUser = Users(id: 'testUserId', firstName: 'Test', lastName: 'User', email: 'test@example.com');

  testWidgets('UserProfile displays user data and posts', (WidgetTester tester) async {
    final mockFirestore = MockFirestoreInstance();

    when(mockFirestore.collection('users').doc('testUserId').get()).thenAnswer((_) async => MockDocumentSnapshot({
      'postCount': 5,
      'points': 100,
    }));

    when(mockFirestore.collection('friends').where('userId', isEqualTo: 'testUserId').get()).thenAnswer((_) async => MockQuerySnapshot([
      MockQueryDocumentSnapshot({'friendId': 'friend1'}),
      MockQueryDocumentSnapshot({'friendId': 'friend2'}),
    ]));

    when(mockFirestore.collection('Posts').where('userId', isEqualTo: 'testUserId').snapshots()).thenAnswer((_) => Stream.value(MockQuerySnapshot([
      MockQueryDocumentSnapshot({'imageUrl': 'https://example.com/image1.jpg', 'description': 'Test post 1'}),
      MockQueryDocumentSnapshot({'imageUrl': 'https://example.com/image2.jpg', 'description': 'Test post 2'}),
    ])));

    await tester.pumpWidget(MaterialApp(home: UserProfile(user: testUser)));

    expect(find.text('Test User'), findsOneWidget);
    expect(find.text('FRIENDS'), findsOneWidget);
    expect(find.text('POSTS'), findsOneWidget);
    expect(find.text('GREEN SCORE'), findsOneWidget);

    await tester.pump();

    expect(find.byType(Image), findsNWidgets(2));
    expect(find.text('Test post 1'), findsOneWidget);
    expect(find.text('Test post 2'), findsOneWidget);
  });
}
