import 'package:flutter_driver/flutter_driver.dart' as driver;
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';


import 'package:flutter_driver/flutter_driver.dart';

class CustomFlutterWorld extends FlutterWorld {
  late FlutterDriver driver;

  @override
  Future<void> dispose() async {
    await driver.close();
    }
}


void customExpect(dynamic actual, dynamic matcher, String reason) {
  if (actual != matcher) {
    throw Exception('Test failed: $reason');
  }
}

StepDefinitionGeneric GivenIamOnTheForumScreen() {
  return given<CustomFlutterWorld>(
    'I am on the Forum Screen',
        (context) async {
      final titleFinder = driver.find.byValueKey('ForumScreenTitle');
      // Access the driver from the context's world correctly
      final title = await context.world.driver.getText(titleFinder, timeout: Duration(seconds: 2));
      customExpect(title, 'CleanItUP', 'Title does not match');
    },
  );
}



StepDefinitionGeneric WhenITapAddPostButton() {
  return when<CustomFlutterWorld>(
    'I tap the add post button',
        (context) async {
      final finder = find.byType('FloatingActionButton');
      await context.world.driver.tap(finder);
    },
  );
}


StepDefinitionGeneric ThenIShouldBeNavigatedToAddPostScreen() {
  return then<CustomFlutterWorld>(
    'I should be navigated to the Add Post Screen',
        (context) async {
      final addPostScreenFinder = driver.find.byValueKey('AddPostScreen');
      try {
        // Wait for the AddPostScreen to be present within a reasonable time frame
        await context.world.driver.waitFor(addPostScreenFinder, timeout: Duration(seconds: 5));
      } catch (e) {
        throw Exception('Failed to navigate to Add Post Screen: ${e.toString()}');
      }
    },
  );
}
