import 'package:flutter/material.dart';
import '../../../shared/components/appbar_component.dart';
import '../../../shared/components/future_builder_component.dart';
import '../../../shared/services/navigation_service.dart';
import '../../../shared/utils/extensions/shared_extensions.dart';
import 'teacher_subject_students_view.dart';

import '../../../shared/components/subject_container_component.dart';
import '../../../shared/utils/database/firebase.dart';

class TeacherQuizSubjectsView extends StatelessWidget {
  const TeacherQuizSubjectsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarComponent(
        title: 'Quiz Subjects',
      ),
      body: SizedBox(
        height: context.height,
        width: context.width,
        child: FutureBuilderComponent(
          future: FirebaseAccess.firebaseFirestoreInstance
              .collection(FirebaseCollectionNames.teacherCollection)
              .doc(FirebaseAccess.firebaseAuthInstance.currentUser?.uid)
              .collection(FirebaseCollectionNames.teacherSubjectCollection)
              .get(),
          builder: (context, snapshot) {
            final itemCount = snapshot.data?.docs.length;
            return ListView.separated(
              padding: EdgeInsets.only(
                left: context.width * 0.04,
                right: context.width * 0.04,
                top: context.height * 0.02,
              ),
              itemCount: itemCount!,
              separatorBuilder: (context, index) => SizedBox(
                height: context.height * 0.02,
              ),
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];
                return SubjectContainerComponent(
                  onTap: () {
                    NavigationService().push(TeacherSubjectStudentsView(
                      subjectName: data['subjectName'],
                    ));
                  },
                  subjectName: data['subjectName'],
                  subjectImage: data['subjectImage'],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
