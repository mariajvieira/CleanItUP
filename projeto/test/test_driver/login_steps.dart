// test_driver/steps/login_steps.dart
import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:test/test.dart';

import '../test_driver/page_objects/login_page.dart';

StepDefinitionGeneric GivenIAmOnTheLoginPage() {
  return given1<String, FlutterWorld>(
    'I am on the login page',
        (input1, context) async {
          // to implement
    },
  );
}

StepDefinitionGeneric WhenIEnterUsernameAndPassword() {
  return when2<String, String, FlutterWorld>(
    'I enter {string} and {string}',
        (username, password, context) async {
      // to implement
    },
  );
}

StepDefinitionGeneric ThenIAmLoggedIn() {
  return then1<String, FlutterWorld>(
    'I should be logged in',
        (input1, context) async {
          // to implement
    },
  );
}