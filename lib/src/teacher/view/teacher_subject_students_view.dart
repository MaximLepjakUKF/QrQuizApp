import 'package:flutter/material.dart';
import '../../../shared/components/future_builder_component.dart';
import '../../../shared/services/navigation_service.dart';
import '../../../shared/utils/database/firebase.dart';
import '../../../shared/utils/extensions/shared_extensions.dart';

import '../../../shared/components/appbar_component.dart';
import '../components/teacher_students_list_tile_component.dart';
import 'teacher_subject_student_each_quiz_view.dart';

class TeacherSubjectStudentsView extends StatelessWidget {
  const TeacherSubjectStudentsView({
    super.key,
    required this.subjectName,
  });

  final String subjectName;

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    Set<String> uniqueStudentNames = {};
    return Scaffold(
      appBar: AppBarComponent(
        title: subjectName,
      ),
      body: SizedBox(
        height: context.height,
        width: context.width,
        child: FutureBuilderComponent(
          future: FirebaseEndPoints.teacherViewStudentQuizCollection
              .where('teacherId',
                  isEqualTo:
                      FirebaseAccess.firebaseAuthInstance.currentUser!.uid)
              .where('subjectName', isEqualTo: subjectName)
              .get(),
          builder: (context, snapshot) {
            List<String> studentNames = [];
            Map<String, String> studentIds = {};

            for (var document in snapshot.data!.docs) {
              Map<String, dynamic> data = document.data();
              final extract = data['studentName'].toString().split('@');
              final studentName = extract[0].toUpperCase();

              if (!studentNames.contains(studentName)) {
                studentNames.add(studentName);
                studentIds[studentName] = data['studentId'];
              }
            }

            List<Widget> tiles = studentNames.map((studentName) {
              return TeacherStudentsListTileComponent(
                studentName: studentName,
                onTap: () {
                  NavigationService().push(
                    TeacherSubjectStudentEachQuizView(
                      subjectName: subjectName,
                      studentId: studentIds[studentName]!,
                    ),
                  );
                },
              );
            }).toList();

            return ListView(
              padding: EdgeInsets.symmetric(
                  horizontal: context.width * 0.04,
                  vertical: context.height * 0.02),
              children: tiles,
            );
          },
        ),
      ),
    );
  }
}
