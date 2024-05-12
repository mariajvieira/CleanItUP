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
}
