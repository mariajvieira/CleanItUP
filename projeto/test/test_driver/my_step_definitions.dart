import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric GivenIHaveOpenedTheApp() {
  return given<FlutterWorld>(
    'I have opened the app',
        (context) async {
      //to do
    },
  );
}

StepDefinitionGeneric WhenIDoSomething() {
  return when1<String, FlutterWorld>(
    'I do something',
        (input1, context) async {
      // implementation code here, such as tapping a button
    },
  );
}


StepDefinitionGeneric ThenIExpectSomething() {
  return then1<String, FlutterWorld>(
    'I expect something',
        (input1, context) async {
// to implement
    },
  );
}
