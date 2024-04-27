// test_driver/page_objects/login_page.dart
import 'package:flutter_driver/flutter_driver.dart';

class LoginPage {
  final FlutterDriver driver;

  LoginPage(this.driver);

  // Replace these methods with the actual identifiers used in your app.
  final SerializableFinder usernameFinder = find.byValueKey('usernameTextField');
  final SerializableFinder passwordFinder = find.byValueKey('passwordTextField');
  final SerializableFinder loginButtonFinder = find.byValueKey('loginButton');

  Future<void> navigateTo() async {
    // Logic to navigate to the login page
    // If the login page is the first screen, this might be empty
  }

  Future<void> enterUsername(String username) async {
    await driver.tap(usernameFinder);
    await driver.enterText(username);
  }

  Future<void> enterPassword(String password) async {
    await driver.tap(passwordFinder);
    await driver.enterText(password);
  }

  Future<void> pressLoginButton() async {
    await driver.tap(loginButtonFinder);
  }

// Add other interaction methods as necessary
}
