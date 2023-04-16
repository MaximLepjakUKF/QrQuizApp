import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../shared/components/appbar_component.dart';
import '../../../shared/components/future_builder_component.dart';
import '../../../shared/components/quiz_questions_component.dart';
import '../../../shared/components/subject_container_component.dart';
import '../../../shared/services/navigation_service.dart';
import '../../../shared/utils/database/firebase.dart';
import '../../../shared/utils/extensions/shared_extensions.dart';

class TeacherSubjectStudentEachQuizView extends StatelessWidget {
  const TeacherSubjectStudentEachQuizView({
    super.key,
    required this.subjectName,
    required this.studentId,
  });

  final String subjectName;
  final dynamic studentId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        title: '$subjectName Quiz',
      ),
      body: SizedBox(
        height: context.height,
        width: context.width,
        child: FutureBuilderComponent<QuerySnapshot<Map<String, dynamic>>>(
          future: FirebaseEndPoints.studentDirectQuizCollection
              .where('studentId', isEqualTo: studentId)
              .where('subjectName', isEqualTo: subjectName)
              .orderBy('submittedQuizDateTime', descending: true)
              .get(),
          builder: (context, snapshot) {
            final docs = snapshot.data?.docs;

            final subjectWidgets = <Widget>[];
            for (final doc in docs!) {
              final subjectName = doc['submittedQuizDateTime'];

              DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(
                  subjectName.microsecondsSinceEpoch);
              String formattedDateTime =
                  DateFormat('dd MMMM, y - hh:mm a').format(dateTime);

              subjectWidgets.add(
                SubjectContainerComponent(
                  onTap: () {

                    NavigationService().push(
                      QuizQuestionsComponent(
                        appbarTitle:
                            "${doc['studentName'].toString().split('@')[0].toUpperCase()} Quiz Result",
                        studentQuizSubmittedDateTime:
                            doc['submittedQuizDateTime'],
                        studentQuizSubmittedSubjectName: doc['subjectName'],
                        teacherCreatedQuizDateTimeToCompare:
                            doc['teacherCreatedQuizDateTime'],
                        studentAnswersSubmittedList: doc['questions'],
                        isQuizAutoSubmitted: doc['isQuizAutoSubmitted'],
                      ),
                    );
                  },
                  subjectName: formattedDateTime,
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.only(
                left: context.width * 0.04,
                right: context.width * 0.04,
                top: context.height * 0.02,
              ),
              itemCount: subjectWidgets.length,
              separatorBuilder: (context, index) => SizedBox(
                height: context.height * 0.02,
              ),
              itemBuilder: (context, index) => subjectWidgets[index],
            );
          },
        ),
      ),
    );
  }
}
