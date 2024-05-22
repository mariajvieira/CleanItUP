import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projeto/screens/signup_screen.dart';
import 'package:projeto/screens/login_screen.dart';

// Criação das classes de mock utilizando o Mockito
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockUserCredential extends Mock implements UserCredential {}
class MockUser extends Mock implements User {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockDocumentSnapshot extends Mock implements DocumentSnapshot<Map<String, dynamic>> {}
class MockQuerySnapshot extends Mock implements QuerySnapshot<Map<String, dynamic>> {}
class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot<Map<String, dynamic>> {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final mockAuth = MockFirebaseAuth();
  final mockFirestore = MockFirebaseFirestore();
  final mockUserCredential = MockUserCredential();
  final mockUser = MockUser();
  final mockDocumentReference = MockDocumentReference();
  final mockCollectionReference = MockCollectionReference();
  final mockDocumentSnapshot = MockDocumentSnapshot();
  final mockQuerySnapshot = MockQuerySnapshot();
  final mockQueryDocumentSnapshot = MockQueryDocumentSnapshot();

  setUp(() {
    // Mock dos métodos do Firebase Auth
    when(mockAuth.createUserWithEmailAndPassword(
      email: anyNamed('email') ?? '',
      password: anyNamed('password') ?? '',
    )).thenAnswer((_) async => mockUserCredential);
    when(mockUserCredential.user).thenReturn(mockUser);
    when(mockUser.uid).thenReturn('testUserId');

    // Mock dos métodos de referência de documento do Firestore
    when(mockFirestore.collection('users')).thenReturn(mockCollectionReference);
    when(mockCollectionReference.doc('testUserId')).thenReturn(mockDocumentReference);
    when(mockDocumentReference.set(any ?? <String, dynamic>{})).thenAnswer((_) async => Future.value());

    // Mock do método get do Firestore para dados do user
    when(mockDocumentReference.get()).thenAnswer((_) async => mockDocumentSnapshot);
    when(mockDocumentSnapshot.data()).thenReturn({
      'postCount': 5,
      'points': 100
    });

    // Mock dos métodos de collection e where do Firestore para amigos
    when(mockFirestore.collection('friends')).thenReturn(mockCollectionReference);
    when(mockCollectionReference.where('userId', isEqualTo: 'testUserId')).thenReturn(mockCollectionReference);
    when(mockCollectionReference.get()).thenAnswer((_) async => mockQuerySnapshot);
    when(mockQuerySnapshot.docs).thenReturn([
      mockQueryDocumentSnapshot,
      mockQueryDocumentSnapshot,
    ]);
    when(mockQueryDocumentSnapshot.data()).thenReturn({
      'friendId': 'friend1',
    });

    // Mock do método snapshots do Firestore para posts
    when(mockFirestore.collection('Posts')).thenReturn(mockCollectionReference);
    when(mockCollectionReference.where('userId', isEqualTo: 'testUserId')).thenReturn(mockCollectionReference);
    when(mockCollectionReference.snapshots()).thenAnswer((_) => Stream.value(mockQuerySnapshot));
    when(mockQuerySnapshot.docs).thenReturn([
      mockQueryDocumentSnapshot,
      mockQueryDocumentSnapshot,
    ]);
    when(mockQueryDocumentSnapshot.data()).thenReturn({
      'imageUrl': 'https://example.com/image1.jpg',
      'description': 'Test post 1',
    });
  });

  testWidgets('SignUp screen displays and functions correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SignUp(),
      ),
    );

    expect(find.text('CleanIt'), findsOneWidget);
    expect(find.text('UP'), findsOneWidget);
    expect(find.text('Sign up with your UP email'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(5));
    expect(find.byType(FloatingActionButton), findsOneWidget);

    // Entrada de texto nos campos
    await tester.enterText(find.byType(TextFormField).at(0), 'Test');
    await tester.enterText(find.byType(TextFormField).at(1), 'User');
    await tester.enterText(find.byType(TextFormField).at(2), 'test@up.pt');
    await tester.enterText(find.byType(TextFormField).at(3), 'password');
    await tester.enterText(find.byType(TextFormField).at(4), 'password');

    // Toque no botão Sign Up
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Verificação de que createUserWithEmailAndPassword foi chamado
    verify(mockAuth.createUserWithEmailAndPassword(
      email: 'test@up.pt',
      password: 'password',
    )).called(1);

    // Verificação de que o perfil do user foi criado
    verify(mockFirestore.collection('users').doc('testUserId').set({
      'firstName': 'Test',
      'lastName': 'User',
      'email': 'test@up.pt',
    })).called(1);

    // Verificação da navegação para a tela de Login
    expect(find.byType(Login), findsOneWidget);
  });

  testWidgets('SignUp screen shows error on invalid email', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SignUp(),
      ),
    );

    // Entrada de texto nos campos
    await tester.enterText(find.byType(TextFormField).at(0), 'Test');
    await tester.enterText(find.byType(TextFormField).at(1), 'User');
    await tester.enterText(find.byType(TextFormField).at(2), 'invalid_email');
    await tester.enterText(find.byType(TextFormField).at(3), 'password');
    await tester.enterText(find.byType(TextFormField).at(4), 'password');

    // Toque no botão Sign Up
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // Verificação de que a mensagem de erro é exibida
    expect(find.text('Invalid email. Use your UP email'), findsOneWidget);
  });

  testWidgets('SignUp screen shows error on password mismatch', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SignUp(),
      ),
    );

    // Entrada de texto nos campos
    await tester.enterText(find.byType(TextFormField).at(0), 'Test');
    await tester.enterText(find.byType(TextFormField).at(1), 'User');
    await tester.enterText(find.byType(TextFormField).at(2), 'test@up.pt');
    await tester.enterText(find.byType(TextFormField).at(3), 'password');
    await tester.enterText(find.byType(TextFormField).at(4), 'different_password');

    // Toque no botão Sign Up
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // Verificação de que a mensagem de erro é exibida
    expect(find.text('Passwords do not match'), findsOneWidget);
  });
}
