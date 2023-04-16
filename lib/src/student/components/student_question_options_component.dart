
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

import '../../../shared/utils/extensions/shared_extensions.dart';

class StudentQuestionOptionsComponent extends StatelessWidget {
  const StudentQuestionOptionsComponent({
    super.key,
    required this.questionNo,
    required this.questionStatement,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
    required this.correctOption,
    required this.youType,
    required this.totalMarks,
    required this.isMultiple,
  });

  final String questionNo;
  final String questionStatement;
  final String option1;
  final String option2;
  final String option3;
  final String option4;
  final String correctOption;
  final String youType;
  final int totalMarks;
  final bool isMultiple;

  @override
  Widget build(BuildContext context) {
    return badges.Badge(
      badgeContent: youType == ''
          ? const Text(
              'Answer Missing',
              style: TextStyle(
                fontSize: 10,
                color: Colors.white,
              ),
            )
          : null,
      badgeStyle: badges.BadgeStyle(
        badgeColor: youType == '' ? Colors.red : Colors.white,
        shape: badges.BadgeShape.instagram,
        padding: const EdgeInsets.all(
          8,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        width: double.infinity,
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
        child: isMultiple == true
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
                    children: [
                      StudentMCQComponent(
                        youType: youType,
                        correctOption: correctOption,
                        option: option1,
                        optionName: 'a',
                      ),
                      StudentMCQComponent(
                        youType: youType,
                        correctOption: correctOption,
                        option: option2,
                        optionName: 'b',
                      ),
                      StudentMCQComponent(
                        youType: youType,
                        correctOption: correctOption,
                        option: option3,
                        optionName: 'c',
                      ),
                      StudentMCQComponent(
                        youType: youType,
                        correctOption: correctOption,
                        option: option4,
                        optionName: 'd',
                      ),
                    ],
                  )
                ],
              )
            : Column(
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
                  StudentSingleComponent(
                    youType: youType,
                    correctOption: correctOption,
                  ),
                ],
              ),
      ),
    );
  }
}

class StudentSingleComponent extends StatelessWidget {
  const StudentSingleComponent({
    super.key,
    required this.youType,
    required this.correctOption,
  });

  final String youType;
  final String correctOption;

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration.zero,
      () {
        if (youType.toLowerCase().trim() ==
            correctOption.toLowerCase().trim()) {
          context.studentViewModelRead.obtainedMarks =
              context.studentViewModelRead.obtainedMarks + 1;
        }
      },
    );
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color:
            youType.toLowerCase().trim() == correctOption.toLowerCase().trim()
                ? const Color.fromRGBO(86, 228, 50, 1)
                : youType.trim().isEmpty
                    ? Colors.white
                    : const Color.fromRGBO(255, 21, 21, 1),
      ),
      child: Text(
        youType,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 12,
              color: youType.toLowerCase().trim() ==
                      correctOption.toLowerCase().trim()
                  ? const Color.fromRGBO(248, 248, 247, 1)
                  : const Color.fromRGBO(245, 241, 241, 1),
            ),
      ),
    );
  }
}

class StudentMCQComponent extends StatelessWidget {
  const StudentMCQComponent({
    super.key,
    required this.youType,
    required this.correctOption,
    required this.option,
    required this.optionName,
  });

  final String youType;
  final String correctOption;
  final String option;
  final String optionName;

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration.zero,
      () {
        if (youType.toLowerCase().trim() == optionName.toLowerCase().trim()) {
          if (correctOption.toLowerCase().trim() ==
              optionName.toLowerCase().trim()) {
            context.studentViewModelRead.obtainedMarks =
                context.studentViewModelRead.obtainedMarks + 1;
          }
        }
      },
    );
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: youType.toLowerCase().trim() == optionName.toLowerCase().trim()
            ? correctOption.toLowerCase().trim() ==
                    optionName.toLowerCase().trim()
                ? const Color.fromRGBO(86, 228, 50, 1)
                : const Color.fromRGBO(255, 21, 21, 1)
            : null,
      ),
      child: Text(
        '$optionName) $option',
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 12,
              color: youType.toLowerCase().trim() ==
                      optionName.toLowerCase().trim()
                  ? correctOption.toLowerCase().trim() ==
                          optionName.toLowerCase().trim()
                      ? const Color.fromRGBO(248, 248, 247, 1)
                      : const Color.fromRGBO(245, 241, 241, 1)
                  : null,
            ),
      ),
    );
  }
}
