
import 'package:flutter/material.dart';
import '../../../../shared/utils/database/firebase.dart';
import '../../../../shared/utils/extensions/shared_extensions.dart';
import '../../../../shared/services/navigation_service.dart';
import '../../../../shared/utils/helpers/shared_helpers.dart';

import '../../view/student_dashboard_view.dart';

class StudentHelpers {
  static void submitQuiz({
    required BuildContext context,
    required List<TextEditingController> answerTextEditingControllerList,
    required String subjectName,
    required dynamic teacherId,
    required String teacherCreatedQuizDateTime,
    bool autoSubmitQuiz = false,
  }) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (autoSubmitQuiz == false) {
      for (int i = 0; i < answerTextEditingControllerList.length; i++) {
        if (answerTextEditingControllerList[i].text.isEmpty) {
          SharedHelpers.textFieldsPopup(text: 'Answer#${i + 1} is missing');
          // break;
          return;
        }
      }
    }
    if (autoSubmitQuiz == false) {
      SharedHelpers.confirmPopUp(
        context: context,
        text: 'Do you want to submit the quiz',
        onYes: () {
          NavigationService().pop();
          SharedHelpers.loadingPopUp(context: context, text: 'Submitting Quiz');
          SharedHelpers.firebaseFirestoreStorage(
            context: context,
            method: () {
              FirebaseEndPoints.studentQuizCollection.add({
                'isQuizAutoSubmitted': autoSubmitQuiz,
                'submittedQuizDateTime': DateTime.now(),
                'teacherCreatedQuizDateTime': teacherCreatedQuizDateTime,
                'subjectName': subjectName,
                'studentName':
                    FirebaseAccess.firebaseAuthInstance.currentUser?.email,
                'studentId':
                    FirebaseAccess.firebaseAuthInstance.currentUser?.uid,
                'teacherId': teacherId,
                'questions': answerTextEditingControllerList
                    .map((answer) => {
                          'answer': answer.text,
                        })
                    .toList(),
              });
              Future.delayed(
                const Duration(seconds: 2),
                () {
                  context.studentViewModelRead.disposeValues();
                },
              );
              Future.delayed(
                const Duration(seconds: 2),
                () {
                  NavigationService()
                      .pushAndRemoveUntil(const StudentDashboardView());
                },
              );
            },
          );
        },
      );
    } else {
      SharedHelpers.loadingPopUp(
          context: context, text: 'Quiz Auto Submitting');
      FirebaseEndPoints.studentQuizCollection.add({
        'isQuizAutoSubmitted': autoSubmitQuiz,
        'submittedQuizDateTime': DateTime.now(),
        'teacherCreatedQuizDateTime': teacherCreatedQuizDateTime,
        'subjectName': subjectName,
        'studentName': FirebaseAccess.firebaseAuthInstance.currentUser?.email,
        'studentId': FirebaseAccess.firebaseAuthInstance.currentUser?.uid,
        'teacherId': teacherId,
        'questions': answerTextEditingControllerList
            .map((answer) => {
                  'answer': answer.text,
                })
            .toList(),
      });
      Future.delayed(
        const Duration(seconds: 2),
        () {
          context.studentViewModelRead.disposeValues();
        },
      );
      Future.delayed(
        const Duration(seconds: 2),
        () {
          NavigationService().pushAndRemoveUntil(const StudentDashboardView());
        },
      );
    }
  }
}
