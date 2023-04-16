import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../firebase_options.dart';
import '../../../src/teacher/view_model/teacher_view_model.dart';
import '../../services/navigation_service.dart';
import '../../../src/authentication/view/login_view.dart';
import '../../../src/authentication/view_model/authentication_view_model.dart';
import 'package:quickalert/quickalert.dart';

import '../../../src/student/view_model/student_view_model.dart';
import '../database/firebase.dart';
import '../database/firebase_exceptions.dart';

class SharedHelpers {
  static Future<void> initilizeApp() async {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FirebaseAccess.firebaseAuthInstance = FirebaseAuth.instance;
    FirebaseAccess.firebaseFirestoreInstance = FirebaseFirestore.instance;
    FirebaseAccess.firebaseStorageInstance = FirebaseStorage.instance;
    FirebaseAccess.sharedPreferences = await SharedPreferences.getInstance();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    Future.delayed(const Duration(seconds: 1)).then((_) {
      FlutterNativeSplash.remove();
    });
  }

  final List<SingleChildWidget> controllers = [
    ChangeNotifierProvider(
      create: (context) => AuthenticationViewModel(),
    ),
    ChangeNotifierProvider(
      create: (context) => StudentViewModel(),
    ),
    ChangeNotifierProvider(
      create: (context) => TeacherViewModel(),
    ),
  ];

  static void successPopUp({
    required BuildContext context,
    required String text,
    required VoidCallback onTap,
  }) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: text,
      onConfirmBtnTap: onTap,
      barrierDismissible: false,
      
    );
  }

  static void loadingPopUp({
    required BuildContext context,
    required String text,
  }) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: text,
      text: 'Please Wait',
    );
  }

  static void errorPopUp({
    required BuildContext context,
    required String text,
  }) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Error',
      text: text,
    );
  }

  static void confirmPopUp({
    required BuildContext context,
    required String text,
    required VoidCallback onYes,
  }) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      barrierDismissible: false,
      confirmBtnText: 'Yes',
      cancelBtnText: 'No',
      title: 'Are you sure?',
      text: text,
      onConfirmBtnTap: onYes,
    );
  }

  static void logout({
    required BuildContext context,
  }) {
    confirmPopUp(
      context: context,
      text: 'Do you want to log out?',
      onYes: () async {
        NavigationService().pop();
        try {
          await FirebaseAccess.firebaseAuthInstance.signOut();
          Future.delayed(
            Duration.zero,
            () {
              loadingPopUp(context: context, text: 'Signing out');
            },
          );
          Future.delayed(
            const Duration(seconds: 2),
            () async {
              await FirebaseAccess.sharedPreferences.clear();
              NavigationService().pushAndRemoveUntil(LoginView());
            },
          );
        } on FirebaseAuthException catch (error) {
          String errorMessage =
              FirebaseAuthExceptionHandler.getMessage(error.code);
          SharedHelpers.errorPopUp(context: context, text: errorMessage);
        }
      },
    );
  }

  static void textFieldsPopup({
    required String text,
  }) {
    BotToast.showText(
      text: text,
    );
  }

  static void firebaseFirestoreStorage({
    required BuildContext context,
    required VoidCallback method,
  }) async {
    try {
      if (!await checkInternetAvailable()) {
        NavigationService().pop();
        Future.delayed(
          Duration.zero,
          () {
            SharedHelpers.errorPopUp(
                context: context, text: 'Internet not available.');
          },
        );
        return;
      }
          method();
    } on SocketException catch (_) {
      NavigationService().pop();
      SharedHelpers.errorPopUp(
          context: context, text: 'Internet not available.');
    } on FirebaseException catch (e) {
      NavigationService().pop();
      String errorMessage = FirebaseAuthExceptionHandler.getMessage(e.code);
      SharedHelpers.errorPopUp(context: context, text: errorMessage);
    } catch (e) {
      NavigationService().pop();
      SharedHelpers.errorPopUp(context: context, text: e.toString());
    }
  }

  static Future<bool> checkInternetAvailable() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }
}
