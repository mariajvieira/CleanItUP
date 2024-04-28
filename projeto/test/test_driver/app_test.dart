import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import '../../../projeto/test/test_driver/login_steps.dart';
import 'my_step_definitions.dart';

void main() {
  final config = FlutterTestConfiguration(
      features: [RegExp(r'test_driver/features/*.feature')],
      reporters: [ProgressReporter()],
      //stepDefinitions: [MyStepDefinitions()],
      //restartAppBetweenScenarios: true,
      //targetAppPath: 'test_driver/app.dart'
  );

  GherkinRunner().execute(config);
}
