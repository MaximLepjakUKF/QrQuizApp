import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../shared/components/text_field_component.dart';
import '../../../shared/components/willpop_component.dart';
import '../../../shared/utils/extensions/shared_extensions.dart';
import '../utils/helpers/student_helpers.dart';

import '../../../shared/components/appbar_component.dart';

String getEndTime(String startTime, int duration) {
  DateTime startDate = DateFormat('hh:mm:ss a').parse(startTime);
  DateTime endDate = startDate.add(Duration(minutes: duration));
  return DateFormat('hh:mm:ss a').format(endDate);
}

class StudentAttemptQuizView extends StatefulWidget {
  const StudentAttemptQuizView({
    super.key,
    required this.subjectName,
    required this.teacherId,
    required this.teacherCreatedQuizDateTime,
    required this.teacherQuizTimeLimit,
  });

  final String subjectName;
  final dynamic teacherId;
  final String teacherCreatedQuizDateTime;
  final int teacherQuizTimeLimit;

  @override
  State<StudentAttemptQuizView> createState() => _StudentAttemptQuizViewState();
}

class _StudentAttemptQuizViewState extends State<StudentAttemptQuizView> {
  String _timeString = '';
  String _endTime = '';
  String currentTimeString = DateFormat('hh:mm:ss a').format(DateTime.now());
  @override
  void initState() {
    super.initState();
    _getStartTime();
    _endTime = getEndTime(currentTimeString, widget.teacherQuizTimeLimit);
  }

  void _getStartTime() {
    setState(() {
      _timeString = 'Quiz Started At - $currentTimeString';
    });
  }

  String _getTimeDifference() {
    DateFormat dateFormat = DateFormat("hh:mm:ss a");
    DateTime endTimeDt = dateFormat.parse(_endTime);
    DateTime currentTimeDt =
        dateFormat.parse(DateFormat('hh:mm:ss a').format(DateTime.now()));
    Duration difference = endTimeDt.difference(currentTimeDt);
    if (difference.inMinutes == 0) {
      final seconds = difference.inSeconds;
      if (seconds == 0) {
        Future.delayed(
          Duration.zero,
          () {
            StudentHelpers.submitQuiz(
              context: context,
              autoSubmitQuiz: true,
              answerTextEditingControllerList:
                  context.studentViewModelRead.answerTextEditingControllerList,
              subjectName: widget.subjectName,
              teacherId: widget.teacherId,
              teacherCreatedQuizDateTime: widget.teacherCreatedQuizDateTime,
            );
          },
        );
        return "Quiz Time Ended";
      } else {
        return '$seconds Seconds Left';
      }
    } else {
      return '${difference.inMinutes} Minute(s) Left';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopComponent(
      child: Scaffold(
        appBar: AppBarComponent(
          title: widget.subjectName,
          automaticallyImplyLeading: true,
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: context.height,
            width: context.width,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    _timeString,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  SizedBox(
                    height: context.height * 0.02,
                  ),
                  Text(
                    'Quiz Will End At - $_endTime',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  SizedBox(
                    height: context.height * 0.02,
                  ),
                  StreamBuilder(
                      stream: Stream.periodic(const Duration(seconds: 1)),
                      builder: (context, snapshot) {
                        return Text(
                          _getTimeDifference(),
                          style: const TextStyle(fontSize: 20),
                        );
                      }),
                  SizedBox(
                    height: context.height * 0.02,
                  ),
                  Expanded(
                    child: Container(
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
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: context.studentViewModelRead
                            .studentAnswerComponentList.length,
                        separatorBuilder: (context, index) => SizedBox(
                          height: context.height * 0.02,
                        ),
                        itemBuilder: (context, index) => StudentAnswerComponent(
                          index: index,
                          answerTextEditingController: context
                              .studentViewModelRead
                              .answerTextEditingControllerList[index],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          shape: const StadiumBorder(),
          onPressed: () {
            StudentHelpers.submitQuiz(
              context: context,
              answerTextEditingControllerList:
                  context.studentViewModelRead.answerTextEditingControllerList,
              subjectName: widget.subjectName,
              teacherId: widget.teacherId,
              teacherCreatedQuizDateTime: widget.teacherCreatedQuizDateTime,
            );
          },
          child: const Icon(
            Icons.done_all,
            size: 36,
          ),
        ),
      ),
    );
  }
}

class StudentAnswerComponent extends StatelessWidget {
  const StudentAnswerComponent({
    super.key,
    this.answerTextEditingController,
    this.index,
  });

  final TextEditingController? answerTextEditingController;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'A.${index! + 1} -',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        SizedBox(
          width: context.width * 0.03,
        ),
        Expanded(
          child: InputTextFieldComponent(
            textEditingController: answerTextEditingController,
            textInputAction: TextInputAction.next,
            textInputType: TextInputType.name,
            textInputFormatter: const [
            ],
            onChanged: (value) {
            },
            hintText: 'Enter Choice Only',
          ),
        ),
      ],
    );
  }
}
