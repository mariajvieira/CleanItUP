import 'package:flutter_test/flutter_test.dart';
import 'package:projeto/screens/signup_screen.dart';
import 'package:projeto/utilities/validation_utils.dart';


void main() {
  group('Validation Functions', () {
    test('Email Validation - Valid Email', () {
      expect(validateEmail('UP1@up.pt'), isTrue);
    });

    test('Email Validation - Valid Email', () {
      expect(validateEmail('up1@up.pt'), isTrue);
    });

    test('Email Validation - Valid Email', () {
      expect(validateEmail('Up1@up.pt'), isTrue);
    });

    test('Email Validation - Valid Email', () {
      expect(validateEmail('uP12@up.pt'), isTrue);
    });

    test('Email Validation - Invalid Email', () {
      expect(validateEmail('UP12U@up.pt'), isFalse);
    });

    test('Email Validation - Invalid Email', () {
      expect(validateEmail('UP12p@up.pt'), isFalse);
    });

    test('Email Validation - Invalid Email', () {
      expect(validateEmail('UP12!@up.pt'), isFalse);
    });

    test('Email Validation - Invalid Email', () {
      expect(validateEmail('UP1'), isFalse);
    });

    test('Email Validation - Invalid Email', () {
      expect(validateEmail('UP2@pu.pt'), isFalse);
    });

    test('Password Validation - Valid Password', () {
      expect(validatePassword('ValidPassword123'), isTrue);
    });

    test('Password Validation - Valid Password', () {
      expect(validatePassword('ValidPassword123!'), isTrue);
    });

    test('Password Validation - Invalid Password (Too Short)', () {
      expect(validatePassword('short'), isFalse);
    });

    test('Password Validation - Invalid Password (No Uppercase)', () {
      expect(validatePassword('nouppercase123'), isFalse);
    });

    test('Password Validation - Invalid Password (No Lowercase)', () {
      expect(validatePassword('NOLOWERCASE123'), isFalse);
    });

    test('Password Validation - Invalid Password (No Number)', () {
      expect(validatePassword('NoNumber'), isFalse);
    });
  });
    testWidgets('Valid Signup', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(MaterialApp(home: SignUp()));

    // Enter valid data
    await tester.enterText(find.byType(TextFormField).at(0), 'Valid');
    await tester.enterText(find.byType(TextFormField).at(1), 'Code');
    await tester.enterText(find.byType(TextFormField).at(2), 'up123@up.pt');
    await tester.enterText(find.byType(TextFormField).at(3), 'ValidCode1');
    await tester.enterText(find.byType(TextFormField).at(4), 'ValidCode1');

    // Tap signup button
    await tester.tap(find.text('SIGN UP'));
    await tester.pumpAndSettle(); // Wait for navigation and widget animations to complete

    // Verify navigation to login screen
    expect(find.byType(Login), findsOneWidget);
  });
}
