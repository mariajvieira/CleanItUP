import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:projeto/JsonModels/users.dart';
import 'package:projeto/screens/quiz_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final Users testUser = Users(id: 'testUserId', firstName: 'Test', lastName: 'User', email: 'test@example.com');

  testWidgets('QuizScreen shows questions and answers', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: QuizScreen(user: testUser)));

    expect(find.text('What is the primary cause of global warming?'), findsOneWidget);
    expect(find.text('Deforestation'), findsOneWidget);
    expect(find.text('Greenhouse gases'), findsOneWidget);
    expect(find.text('Ocean pollution'), findsOneWidget);
    expect(find.text('None of the above'), findsOneWidget);
  });

  testWidgets('QuizScreen updates score after answering questions', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: QuizScreen(user: testUser)));

    await tester.tap(find.text('Greenhouse gases'));
    await tester.pump();

    expect(find.text('Which gas is most responsible for the greenhouse effect?'), findsOneWidget);

    await tester.tap(find.text('Carbon dioxide'));
    await tester.pump();

    expect(find.text('Quiz Finished! Your score: 20'), findsOneWidget);
  });
}
