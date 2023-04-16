import 'package:flutter/material.dart';

import 'shared/app.dart';
import 'shared/components/console_error_component.dart';
import 'shared/utils/helpers/shared_helpers.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  await SharedHelpers.initilizeApp();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return ConsoleErrorComponent(
      flutterErrorDetails: details,
    );
  };

  runApp(
    const QrQuiz(),
  );
}
