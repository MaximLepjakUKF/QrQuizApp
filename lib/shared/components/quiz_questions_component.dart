import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/navigation_service.dart';
import '../../src/student/view_model/student_view_model.dart';
import '../../src/teacher/view/teacher_dashboard_view.dart';
import '../utils/database/firebase.dart';
import '../utils/extensions/shared_extensions.dart';
import '../../src/teacher/view/teacher_create_quiz.dart';

import '../../../shared/components/appbar_component.dart';
import '../../src/student/components/student_question_options_component.dart';
import '../../src/teacher/components/teacher_question_options_component.dart';
import '../../src/teacher/utils/helpers/teacher_helpers.dart';
import 'future_builder_component.dart';

class QuizQuestionsComponent extends StatelessWidget {
  const QuizQuestionsComponent({
    super.key,
    required this.appbarTitle,
    this.isQuizCreation = false,
    this.svg,
    this.teacherQuestionComponentList,
    this.subjectTextEditingController,
    this.studentQuizSubmittedDateTime,
    this.studentQuizSubmittedSubjectName,
    this.teacherCreatedQuizDateTimeToCompare,
    this.studentAnswersSubmittedList,
    this.teacherId,
    this.isQuizAutoSubmitted = false,
  });

  final String appbarTitle;
  final bool isQuizCreation;
  final String? svg;
  final List<TeacherQuestionComponent>? teacherQuestionComponentList;
  final TextEditingController? subjectTextEditingController;
  final Timestamp? studentQuizSubmittedDateTime;
  final String? studentQuizSubmittedSubjectName;
  final String? teacherCreatedQuizDateTimeToCompare;
  final List<dynamic>? studentAnswersSubmittedList;
  final String? teacherId;
  final bool isQuizAutoSubmitted;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isQuizCreation) {
          NavigationService().pushAndRemoveUntil(const TeacherDashboardView());
          return true;
        } else {
          context.studentViewModelRead.totalMarks = 0;
          context.studentViewModelRead.obtainedMarks = 0;
          context.teacherViewModelRead.teacherQuestionComponentList = [];
          context.teacherViewModelRead.questionTextEditingControllerList = [];

          return true;
        }
      },
      child: Scaffold(
        appBar: AppBarComponent(
          title: appbarTitle,
          onPressed: () {
            if (isQuizCreation) {
              NavigationService()
                  .pushAndRemoveUntil(const TeacherDashboardView());
            } else {
              context.studentViewModelRead.totalMarks = 0;
              context.studentViewModelRead.obtainedMarks = 0;
              context.teacherViewModelRead.teacherQuestionComponentList = [];
              context.teacherViewModelRead.questionTextEditingControllerList =
                  [];
              NavigationService().pop();
            }
          },
        ),
        body: SizedBox(
          height: context.height,
          width: context.width,
          child: Padding(
            padding: EdgeInsets.only(
              top: context.height * 0.02,
              left: context.width * 0.04,
              right: context.width * 0.04,
            ),
            child: Column(
              children: [
                if (isQuizCreation)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            TeacherHelper.downloadQuiz(
                              context: context,
                              teacherQuestionComponentList:
                                  teacherQuestionComponentList!,
                              qrCode: svg!,
                              subjectTextEditingController:
                                  subjectTextEditingController!,
                            );
                          },
                          child: Text(
                            'Download',
                            style: GoogleFonts.aBeeZee(
                              fontWeight: FontWeight.w400,
                              fontSize: 25,
                              color: const Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: context.width * 0.03,
                      ),
                      SvgPicture.string(
                        svg!,
                        height: 120,
                        width: 120,
                      ),
                    ],
                  )
                else
                  Consumer<StudentViewModel>(builder: (context, value, _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text: 'Total Marks : ',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: const Color.fromRGBO(109, 106, 106, 1),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          TextSpan(
                            text: value.totalMarks.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: const Color.fromRGBO(109, 106, 106, 1),
                                  fontSize: 16,
                                ),
                          ),
                        ])),
                        SizedBox(
                          width: context.width * 0.009,
                        ),
                        Container(
                          color: const Color.fromRGBO(204, 204, 204, 1),
                          width: 2,
                          height: 19,
                        ),
                        SizedBox(
                          width: context.width * 0.009,
                        ),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text: 'Obtained Marks : ',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: const Color.fromRGBO(109, 106, 106, 1),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          TextSpan(
                            text: value.obtainedMarks.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: const Color.fromRGBO(109, 106, 106, 1),
                                  fontSize: 16,
                                ),
                          ),
                        ])),
                      ],
                    );
                  }),
                SizedBox(
                  height: context.height * 0.02,
                ),
                if (isQuizCreation)
                  Text(
                    '${subjectTextEditingController!.text} Quiz',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                if (!isQuizCreation)
                  Row(
                    children: [
                      const SizedBox(
                        height: 18,
                        width: 18,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(86, 228, 50, 1),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: context.width * 0.007,
                      ),
                      Text(
                        'Correct',
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                      ),
                      SizedBox(
                        width: context.width * 0.073,
                      ),
                      const SizedBox(
                        height: 18,
                        width: 18,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 21, 21, 1),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: context.width * 0.007,
                      ),
                      Text(
                        'Wrong',
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                      ),
                    ],
                  ),
                SizedBox(
                  height: context.height * 0.02,
                ),
                if (isQuizCreation)
                  Expanded(
                    child: ListView.separated(
                      itemCount: teacherQuestionComponentList!.length,
                      separatorBuilder: (context, index) => SizedBox(
                        height: context.height * 0.04,
                      ),
                      itemBuilder: (context, index) =>
                          TeacherQuestionOptionsComponent(
                        questionNo: (index + 1).toString(),
                        questionStatement: teacherQuestionComponentList![index]
                            .questionTextEditingController!
                            .text,
                        option1: teacherQuestionComponentList![index]
                            .optionATextEditingController!
                            .text,
                        option2: teacherQuestionComponentList![index]
                            .optionBTextEditingController!
                            .text,
                        option3: teacherQuestionComponentList![index]
                            .optionCTextEditingController!
                            .text,
                        option4: teacherQuestionComponentList![index]
                            .optionDTextEditingController!
                            .text,
                        correctOption: teacherQuestionComponentList![index]
                            .correctOptionTextEditingController!
                            .text,
                        questionOptions: teacherQuestionComponentList![index]
                            .isSingleorMultiple,
                        singleOption: teacherQuestionComponentList![index]
                            .singleOptionTextEditingController!
                            .text,
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: FutureBuilderComponent(
                        future: FirebaseAccess.firebaseFirestoreInstance
                            .collection(
                                FirebaseCollectionNames.teacherCollection)
                            .doc(teacherId ??
                                FirebaseAccess
                                    .firebaseAuthInstance.currentUser?.uid)
                            .collection(
                                FirebaseCollectionNames.teacherQuizCollection)
                            .where('subjectName',
                                isEqualTo: studentQuizSubmittedSubjectName)
                            .where(
                              'quizCreatedDateTime',
                              isEqualTo: teacherCreatedQuizDateTimeToCompare,
                            )
                            .get(),
                        builder: (context, snapshot) {
                          final itemCount =
                              snapshot.data?.docs.first.data()['questions'];
                          Future.delayed(
                            Duration.zero,
                            () {
                              context.studentViewModelRead.totalMarks =
                                  itemCount.length;
                            },
                          );
                          return ListView.separated(
                              itemCount: itemCount.length,
                              separatorBuilder: (context, index) => SizedBox(
                                    height: context.height * 0.04,
                                  ),
                              itemBuilder: (context, index) {
                                return StudentQuestionOptionsComponent(
                                  questionNo: (index + 1).toString(),
                                  questionStatement: itemCount[index]
                                      ['questionText'],
                                  option1: itemCount[index]['optionA'] ?? '',
                                  option2: itemCount[index]['optionB'] ?? '',
                                  option3: itemCount[index]['optionC'] ?? '',
                                  option4: itemCount[index]['optionD'] ?? '',
                                  correctOption:
                                      itemCount[index]['correctOption'] ?? '',
                                  totalMarks: itemCount.length,
                                  isMultiple: itemCount[index]['isMultiple'],
                                  youType: studentAnswersSubmittedList![index]
                                      ['answer'],
                                );
                              });
                        }),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
