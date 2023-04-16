import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../shared/components/appbar_component.dart';
import '../../../shared/components/future_builder_component.dart';
import '../../../shared/services/navigation_service.dart';
import '../../../shared/utils/database/firebase.dart';
import '../../../shared/utils/extensions/shared_extensions.dart';

import '../../../shared/components/subject_container_component.dart';
import 'student_each_subject_quiz_view.dart';

class StudentSubjectsView extends StatelessWidget {
  const StudentSubjectsView({super.key});

  @override
  Widget build(BuildContext context) {
    final Set<String> displayedSubjects = {};
    return Scaffold(
      appBar: const AppBarComponent(
        title: 'Quiz Subjects',
      ),
      body: SizedBox(
        height: context.height,
        width: context.width,
        child: FutureBuilderComponent<QuerySnapshot<Map<String, dynamic>>>(
          future: FirebaseEndPoints.studentQuizCollection
              .where('studentId',
                  isEqualTo:
                      FirebaseAccess.firebaseAuthInstance.currentUser!.uid)
              .get(),
          builder: (context, snapshot) {
            final docs = snapshot.data?.docs;

            final subjectWidgets = <Widget>[];
            for (final doc in docs!) {
              final subjectName = doc['subjectName'] as String;
              if (!displayedSubjects.contains(subjectName)) {
                displayedSubjects.add(subjectName);
                subjectWidgets.add(
                  SubjectContainerComponent(
                    onTap: () {
                      NavigationService().push(
                        StudentEachSubjectQuizView(
                          subjectName: subjectName,
                        ),
                      );
                    },
                    subjectName: subjectName,
                  ),
                );
              }
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
