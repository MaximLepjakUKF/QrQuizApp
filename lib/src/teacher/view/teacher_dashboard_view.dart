import 'package:flutter/material.dart';
import '../../../shared/components/appbar_component.dart';
import '../../../shared/components/willpop_component.dart';
import '../../../shared/services/navigation_service.dart';
import '../../../shared/utils/constants/app_images.dart';
import '../../../shared/utils/extensions/shared_extensions.dart';
import 'teacher_create_subject.dart';

import '../../../shared/components/stack_button_component.dart';
import 'teacher_create_quiz.dart';
import 'teacher_quiz_subjects_view.dart';

final List<String> authDropDown = ['Student', 'Teacher'];

class TeacherDashboardView extends StatelessWidget {
  const TeacherDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopComponent(
      child: Scaffold(
        appBar: const AppBarComponent(
          title: 'Teacher Dashboard',
          isDashboard: true,
        ),
        body: SizedBox(
          width: context.width,
          height: context.height,
          child: Padding(
            padding: EdgeInsets.only(
              left: context.width * 0.04,
              right: context.width * 0.04,
              top: context.height * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Let’s Play",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: const Color.fromRGBO(92, 176, 254, 1),
                      ),
                ),
                SizedBox(
                  height: context.height * 0.014,
                ),
                StackButtonComponent(
                  onTap: () {
                    NavigationService().push(TeacherCreateSubject());
                  },
                  imagePath1: AppImages.subjectPNG,
                  imagePath2: AppImages.subject2PNG,
                  title: 'Create Subject',
                ),
                SizedBox(
                  height: context.height * 0.02,
                ),
                StackButtonComponent(
                  onTap: () {
                    NavigationService().push(const TeacherCreateQuiz());
                  },
                  imagePath1: AppImages.quiz1PNG,
                  imagePath2: AppImages.quiz2PNG,
                  title: 'Create Quiz',
                ),
                SizedBox(
                  height: context.height * 0.02,
                ),
                StackButtonComponent(
                  onTap: () {
                    NavigationService().push(const TeacherQuizSubjectsView());
                  },
                  imagePath1: AppImages.result1PNG,
                  imagePath2: AppImages.result2PNG,
                  title: 'View Quiz Results',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
