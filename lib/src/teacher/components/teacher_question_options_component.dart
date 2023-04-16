import 'package:flutter/material.dart';
import '../../../shared/utils/extensions/shared_extensions.dart';
import '../view/teacher_create_quiz.dart';

class TeacherQuestionOptionsComponent extends StatelessWidget {
  const TeacherQuestionOptionsComponent({
    super.key,
    required this.questionNo,
    required this.questionStatement,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
    required this.correctOption,
    required this.singleOption,
    required this.questionOptions,
  });

  final String questionNo;
  final String questionStatement;
  final String option1;
  final String option2;
  final String option3;
  final String option4;
  final String correctOption;
  final String singleOption;
  final QuestionOptions? questionOptions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 6),
              blurRadius: 10,
              spreadRadius: 1,
              color: Color.fromRGBO(0, 0, 0, 0.15),
            )
          ]),
      child: questionOptions == QuestionOptions.multiple
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Question $questionNo',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color.fromRGBO(109, 106, 106, 1),
                      ),
                ),
                SizedBox(
                  height: context.height * 0.01,
                ),
                Text(
                  questionStatement,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 14,
                        color: const Color.fromRGBO(109, 106, 106, 1),
                      ),
                ),
                SizedBox(
                  height: context.height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TeacherMCQComponent(
                      option: option1,
                      optionName: 'a',
                    ),
                    TeacherMCQComponent(
                      option: option2,
                      optionName: 'b',
                    ),
                    TeacherMCQComponent(
                      option: option3,
                      optionName: 'c',
                    ),
                    TeacherMCQComponent(
                      option: option4,
                      optionName: 'd',
                    ),
                  ],
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Question $questionNo',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color.fromRGBO(109, 106, 106, 1),
                      ),
                ),
                SizedBox(
                  height: context.height * 0.01,
                ),
                Text(
                  questionStatement,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 14,
                        color: const Color.fromRGBO(109, 106, 106, 1),
                      ),
                ),
                SizedBox(
                  height: context.height * 0.01,
                ),
              ],
            ),
    );
  }
}

class TeacherMCQComponent extends StatelessWidget {
  const TeacherMCQComponent({
    super.key,
    required this.option,
    required this.optionName,
  });

  final String option;
  final String optionName;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        '$optionName) $option',
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 12,
              color: const Color.fromRGBO(109, 106, 106, 1),
            ),
      ),
    );
  }
}
