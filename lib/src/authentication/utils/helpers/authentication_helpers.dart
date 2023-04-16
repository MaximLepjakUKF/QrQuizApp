
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../shared/utils/database/firebase.dart';
import '../../view/login_view.dart';
import '../../../../shared/services/navigation_service.dart';
import '../../../../shared/utils/database/firebase_exceptions.dart';
import '../../../../shared/utils/extensions/shared_extensions.dart';
import '../../../../shared/utils/helpers/shared_helpers.dart';
import '../enums/authentication_enums.dart';
import '../../../student/view/student_dashboard_view.dart';
import '../../../teacher/view/teacher_dashboard_view.dart';

class AuthenticationHelpers {
  static void loginUser({
    required BuildContext context,
    required TextEditingController emailTextEditingController,
    required TextEditingController paswordTextEditingController,
    required TextEditingController dropdownTextEditingController,
  }) async {
    if (emailTextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Email');
      return;
    }

    if (!emailTextEditingController.text.isValidEmail) {
      SharedHelpers.textFieldsPopup(text: 'Enter Valid Email');
      return;
    }

    if (paswordTextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Password');
      return;
    }

    SharedHelpers.loadingPopUp(context: context, text: 'Signing in');

    try {
      final UserCredential userCredential =
          (await FirebaseAccess.firebaseAuthInstance.signInWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: paswordTextEditingController.text,
      ));

      if (userCredential.user != null) {
        final DocumentReference docRef = FirebaseAccess
            .firebaseFirestoreInstance
            .collection(FirebaseCollectionNames.teacherCollection)
            .doc(userCredential.user?.uid);

        final DocumentSnapshot docSnap = await docRef.get();

        if (docSnap.exists) {
          Future.delayed(
            Duration.zero,
            () {
              FirebaseAccess.sharedPreferences.setString('userType', 'teacher');
              context.authenticationViewModelRead.obsecurePassword = true;
              NavigationService().pushAndRemoveUntil(
                const TeacherDashboardView(),
              );
            },
          );
        } else {
          Future.delayed(
            Duration.zero,
            () {
              FirebaseAccess.sharedPreferences.setString('userType', 'student');
              context.authenticationViewModelRead.obsecurePassword = true;
              NavigationService().pushAndRemoveUntil(
                const StudentDashboardView(),
              );
            },
          );
        }
      }
    } on FirebaseAuthException catch (error) {
      FirebaseAccess.firebaseAuthInstance.signOut();
      NavigationService().pop();
      String errorMessage = FirebaseAuthExceptionHandler.getMessage(error.code);
      SharedHelpers.errorPopUp(context: context, text: errorMessage);
    }
  }

  static void forgetPassword({
    required BuildContext context,
    required TextEditingController emailTextEditingController,
  }) async {
    if (emailTextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Email');
      return;
    }

    if (!emailTextEditingController.text.isValidEmail) {
      SharedHelpers.textFieldsPopup(text: 'Enter Valid Email');
      return;
    }

    Future.delayed(
      Duration.zero,
      () {
        SharedHelpers.loadingPopUp(context: context, text: 'Sending Mail');
      },
    );

    try {
      await FirebaseAccess.firebaseAuthInstance
          .sendPasswordResetEmail(email: emailTextEditingController.text);
      Future.delayed(
        Duration.zero,
        () {
          SharedHelpers.successPopUp(
            context: context,
            text: 'Check your inbox/spam folder to recover password',
            onTap: () {
              NavigationService().pushAndRemoveUntil(LoginView());
            },
          );
        },
      );
    } on FirebaseAuthException catch (error) {
      NavigationService().pop();
      String errorMessage = FirebaseAuthExceptionHandler.getMessage(error.code);
      SharedHelpers.errorPopUp(context: context, text: errorMessage);
    }
  }

  static void createUser({
    required BuildContext context,
    required TextEditingController emailTextEditingController,
    required TextEditingController paswordTextEditingController,
    required TextEditingController dropdownTextEditingController,
  }) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (emailTextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Email');
      return;
    }

    if (!emailTextEditingController.text.isValidEmail) {
      SharedHelpers.textFieldsPopup(text: 'Enter Valid Email');
      return;
    }

    if (paswordTextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Password');
      return;
    }

    SharedHelpers.loadingPopUp(context: context, text: 'Creating Account');

    try {
      final UserCredential userCredential = (await FirebaseAccess
          .firebaseAuthInstance
          .createUserWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: paswordTextEditingController.text,
      ));

      if (userCredential.user != null) {
        if (dropdownTextEditingController.text.toLowerCase() ==
            AuthenticationEnums.student.name) {
          await FirebaseEndPoints.studentCollection
              .doc(userCredential.user?.uid)
              .set({
            'id': userCredential.user?.uid,
            'email': emailTextEditingController.text,
            'password': paswordTextEditingController.text,
          }).catchError((onError) {
            FirebaseAccess.firebaseAuthInstance.signOut();
            NavigationService().pop();
            SharedHelpers.errorPopUp(
                context: context, text: onError.toString());
          }).then((_) {
            FirebaseAccess.firebaseAuthInstance.signOut();
            SharedHelpers.successPopUp(
              context: context,
              text: 'Account Created',
              onTap: () {
                NavigationService().pushAndRemoveUntil(
                  LoginView(),
                );
              },
            );
          });
        }

        if (dropdownTextEditingController.text.toLowerCase() ==
            AuthenticationEnums.teacher.name) {
          await FirebaseEndPoints.teacherCollection
              .doc(userCredential.user?.uid)
              .set({
            'id': userCredential.user?.uid,
            'email': emailTextEditingController.text,
            'password': paswordTextEditingController.text,
          }).catchError((onError) {
            FirebaseAccess.firebaseAuthInstance.signOut();
            NavigationService().pop();
            SharedHelpers.errorPopUp(
                context: context, text: onError.toString());
          }).then((_) {
            FirebaseAccess.firebaseAuthInstance.signOut();
            SharedHelpers.successPopUp(
              context: context,
              text: 'Account Created',
              onTap: () {
                NavigationService().pushAndRemoveUntil(
                  LoginView(),
                );
              },
            );
          });
        }
      }
    } on FirebaseAuthException catch (error) {
      FirebaseAccess.firebaseAuthInstance.signOut();
      NavigationService().pop();
      String errorMessage = FirebaseAuthExceptionHandler.getMessage(error.code);
      SharedHelpers.errorPopUp(context: context, text: errorMessage);
    }
  }
}
