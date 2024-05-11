import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

class FlutterWorld extends World {
  final FlutterDriver driver;

  FlutterWorld(this.driver);
}

StepDefinitionGeneric GivenIAmOnTheLoginPage() {
  return given1<String, FlutterWorld>(
    'I am on the login page',
        (input1, context) async {
          final FlutterDriver driver = context.world.driver; // Cast driver to FlutterDriver
          // Implement logic to navigate to the login page
          await driver.waitFor(find.byType('LoginPage'));
    },
  );
}

StepDefinitionGeneric WhenIEnterUsernameAndPassword() {
  return when2<String, String, FlutterWorld>(
    'I enter {string} and {string}',
        (username, password, context) async {
      final FlutterDriver driver = context.world.driver;
      final usernameField = find.byValueKey('username_field');
      final passwordField = find.byValueKey('password_field');

      await driver.tap(usernameField);
      await driver.enterText(username);
      await driver.tap(passwordField);
      await driver.enterText(password);
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