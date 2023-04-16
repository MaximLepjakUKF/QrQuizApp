import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../src/authentication/view/login_view.dart';
import '../src/student/view/student_dashboard_view.dart';
import '../src/teacher/view/teacher_dashboard_view.dart';

import '../main.dart';
import '../src/authentication/utils/enums/authentication_enums.dart';
import 'components/view_not_found_component.dart';
import 'theme/native_theme.dart';
import 'utils/constants/app_texts.dart';
import 'utils/database/firebase.dart';
import 'utils/helpers/shared_helpers.dart';

class QrQuiz extends StatelessWidget {
  const QrQuiz({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: SharedHelpers().controllers,
      child: MaterialApp(
        useInheritedMediaQuery: true,
        title: AppTexts.appTitle,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: NativeThemeData().nativeLightTheme(),
        home: FirebaseAccess.firebaseAuthInstance.currentUser != null
            ? FirebaseAccess.sharedPreferences.getString('userType') ==
                    AuthenticationEnums.student.name
                ? const StudentDashboardView()
                : FirebaseAccess.sharedPreferences.getString('userType') ==
                        AuthenticationEnums.teacher.name
                    ? const TeacherDashboardView()
                    : LoginView()
            : LoginView(),
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (context) => ViewNotFoundComponent(viewName: settings.name!),
        ),
      ),
    );
  }
}
