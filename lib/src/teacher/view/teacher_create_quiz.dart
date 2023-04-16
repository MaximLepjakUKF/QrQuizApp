import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../shared/utils/database/firebase.dart';

import '../../../shared/components/appbar_component.dart';
import '../../../shared/components/future_builder_component.dart';
import '../../../shared/components/selectable_dropdown_component.dart';
import '../../../shared/components/text_field_component.dart';
import '../../../shared/utils/extensions/shared_extensions.dart';
import '../components/statement_text_field_component.dart';
import '../utils/helpers/teacher_helpers.dart';
import '../view_model/teacher_view_model.dart';

class TeacherCreateQuiz extends StatefulWidget {
  const TeacherCreateQuiz({super.key});

  @override
  State<TeacherCreateQuiz> createState() => _TeacherCreateQuizState();
}

class _TeacherCreateQuizState extends State<TeacherCreateQuiz> {
  final ScrollController _scrollController = ScrollController();

  final TextEditingController subjectTextEditingController =
      TextEditingController();
  final TextEditingController quizTimeTextEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    subjects = subjectss();
  }

  late Future<QuerySnapshot<Map<String, dynamic>>> subjects;

  Future<QuerySnapshot<Map<String, dynamic>>> subjectss() {
    return FirebaseEndPoints.teacherSubjectCollection.get();
  }

  @override
  Widget build(BuildContext context) {
    bool iskeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      appBar: const AppBarComponent(
        title: 'Create Quiz',
      ),
      body: ChangeNotifierProvider(
          create: (context) => TeacherViewModel(),
          builder: (context, _) {
            return SizedBox(
              height: context.height,
              width: context.width,
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
                      'Subject',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    SizedBox(
                      height: context.height * 0.01,
                    ),
                    FutureBuilderComponent<QuerySnapshot<Map<String, dynamic>>>(
                      future: subjects,
                      builder: (context, snapshot) {
                        List<String> subjectDropDown = snapshot.data!.docs
                            .map((doc) => doc.get('subjectName') as String)
                            .toList();
                        return SelectableDropDownComponent(
                          showLeadingIcon: false,
                          selectedValue: (value) {
                            subjectTextEditingController.text = value;
                          },
                          items: subjectDropDown
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          hintText: subjectDropDown.first,
                        );
                      },
                    ),
                    SizedBox(
                      height: context.height * 0.025,
                    ),
                    Text(
                      'Quiz Time (minutes)',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    SizedBox(
                      height: context.height * 0.01,
                    ),
                    InputTextFieldComponent(
                      textEditingController: quizTimeTextEditingController,
                      hintText: '30',
                      textInputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (p0) {},
                      textInputType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(
                      height: context.height * 0.025,
                    ),
                    Consumer<TeacherViewModel>(builder: (context, value, _) {
                      return Expanded(
                        child: ListView.separated(
                          controller: _scrollController,
                          itemCount: value.teacherQuestionComponentList.length,
                          shrinkWrap: true,
                          separatorBuilder: (context, index) => SizedBox(
                            height: context.height * 0.02,
                          ),
                          itemBuilder: (context, index) {
                            return TeacherQuestionComponent(
                              index: index,
                              questionTextEditingController: value
                                  .teacherQuestionComponentList[index]
                                  .questionTextEditingController,
                              optionATextEditingController: value
                                  .teacherQuestionComponentList[index]
                                  .optionATextEditingController,
                              optionBTextEditingController: value
                                  .teacherQuestionComponentList[index]
                                  .optionBTextEditingController,
                              optionCTextEditingController: value
                                  .teacherQuestionComponentList[index]
                                  .optionCTextEditingController,
                              optionDTextEditingController: value
                                  .teacherQuestionComponentList[index]
                                  .optionDTextEditingController,
                              correctOptionTextEditingController: value
                                  .teacherQuestionComponentList[index]
                                  .correctOptionTextEditingController,
                              isSingleorMultiple: value
                                  .teacherQuestionComponentList[index]
                                  .isSingleorMultiple,
                              singleOptionTextEditingController: value
                                  .teacherQuestionComponentList[index]
                                  .singleOptionTextEditingController,
                            );
                          },
                        ),
                      );
                    }),
                    if (!iskeyboardOpen)
                      SizedBox(
                        height: context.height * 0.01,
                      ),
                    if (!iskeyboardOpen)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              TeacherHelper.createQuiz(
                                context: context,
                                teacherQuestionComponentList: context
                                    .teacherViewModelRead
                                    .teacherQuestionComponentList,
                                subjectTextEditingController:
                                    subjectTextEditingController,
                                quizTimeTextEditingController:
                                    quizTimeTextEditingController,
                              );
                            },
                            style: ButtonStyle(
                              minimumSize: MaterialStatePropertyAll(
                                Size(
                                  context.width * 0.5,
                                  context.height * 0.06,
                                ),
                              ),
                            ),
                            child: Text(
                              'Submit',
                              style: GoogleFonts.aBeeZee(
                                fontWeight: FontWeight.w400,
                                fontSize: 25,
                                color: const Color.fromRGBO(255, 255, 255, 1),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (context.teacherViewModelRead
                                      .teacherQuestionComponentList.length >
                                  1) {
                                context.teacherViewModelRead
                                    .removeFromTeacherQuestionComponentList();
                                _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: const Duration(milliseconds: 1000),
                                  curve: Curves.ease,
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.remove,
                            ),
                            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                Color.fromARGB(255, 241, 42, 28),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              context.teacherViewModelRead
                                  .teacherQuestionComponentList
                                  .add(
                                TeacherQuestionComponent(
                                  questionTextEditingController:
                                      TextEditingController(),
                                  correctOptionTextEditingController:
                                      TextEditingController(),
                                  optionATextEditingController:
                                      TextEditingController(),
                                  optionBTextEditingController:
                                      TextEditingController(),
                                  optionCTextEditingController:
                                      TextEditingController(),
                                  optionDTextEditingController:
                                      TextEditingController(),
                                  singleOptionTextEditingController:
                                      TextEditingController(),
                                  isSingleorMultiple: QuestionOptions.single,
                                ),
                              );

                              context.teacherViewModelRead.update();

                              _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 1000),
                                curve: Curves.ease,
                              );
                            },
                            icon: const Icon(
                              Icons.add,
                            ),
                            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                Color.fromARGB(255, 80, 10, 5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: context.height * 0.01,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

enum QuestionOptions { single, multiple }

// ignore: must_be_immutable
class TeacherQuestionComponent extends StatelessWidget {
  TeacherQuestionComponent({
    super.key,
    this.questionTextEditingController,
    this.index,
    this.correctOptionTextEditingController,
    this.optionATextEditingController,
    this.optionBTextEditingController,
    this.optionCTextEditingController,
    this.optionDTextEditingController,
    this.isSingleorMultiple = QuestionOptions.single,
    this.singleOptionTextEditingController,
  });

  final TextEditingController? questionTextEditingController;
  final int? index;
  final TextEditingController? singleOptionTextEditingController;
  final TextEditingController? optionATextEditingController;
  final TextEditingController? optionBTextEditingController;
  final TextEditingController? optionCTextEditingController;
  final TextEditingController? optionDTextEditingController;
  final TextEditingController? correctOptionTextEditingController;
  QuestionOptions? isSingleorMultiple;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          15,
        ),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 6),
            blurRadius: 10,
            spreadRadius: 1,
            color: Color.fromRGBO(0, 0, 0, 0.15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatementTextFieldComponent(
            leadingTitle: 'Q. ${index! + 1} - ',
            hintText: 'Question',
            textEditingController: questionTextEditingController,
            textInputAction: TextInputAction.done,
          ),
          SizedBox(
            height: context.height * 0.01,
          ),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: RadioListTile(
                  title: Text(
                    'Single Choice',
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          fontSize: 12,
                        ),
                  ),
                  value: QuestionOptions.single,
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  contentPadding: EdgeInsets.zero,
                  groupValue: isSingleorMultiple,
                  onChanged: (value) {
                  
                    context.teacherViewModelRead
                        .updateQuestionType(index!, value as QuestionOptions);
                  },
                ),
              ),
              const Spacer(),
              Expanded(
                flex: 5,
                child: RadioListTile(
                  title: Text(
                    'Multiple Choice',
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          fontSize: 12,
                        ),
                  ),
                  value: QuestionOptions.multiple,
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  contentPadding: EdgeInsets.zero,
                  groupValue: isSingleorMultiple,
                  onChanged: (value) {
                  
                    context.teacherViewModelRead
                        .updateQuestionType(index!, value as QuestionOptions);
                  },
                ),
              ),
            ],
          ),
          Text(
            'Option(s)',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          SizedBox(
            height: context.height * 0.01,
          ),
          isSingleorMultiple == QuestionOptions.multiple
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatementTextFieldComponent(
                      textEditingController: optionATextEditingController,
                      leadingTitle: 'A.',
                      hintText: 'Choice',
                    ),
                    SizedBox(
                      height: context.height * 0.01,
                    ),
                    StatementTextFieldComponent(
                      textEditingController: optionBTextEditingController,
                      leadingTitle: 'B.',
                      hintText: 'Choice',
                    ),
                    SizedBox(
                      height: context.height * 0.01,
                    ),
                    StatementTextFieldComponent(
                      textEditingController: optionCTextEditingController,
                      leadingTitle: 'C.',
                      hintText: 'Choice',
                    ),
                    SizedBox(
                      height: context.height * 0.01,
                    ),
                    StatementTextFieldComponent(
                      textEditingController: optionDTextEditingController,
                      leadingTitle: 'D.',
                      hintText: 'Choice',
                    ),
                    SizedBox(
                      height: context.height * 0.01,
                    ),
                    Text(
                      'Correct Choice',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    SizedBox(
                      height: context.height * 0.01,
                    ),
                    InputTextFieldComponent(
                      textEditingController: correctOptionTextEditingController,
                      hintText: 'a',
                      textInputFormatter: [
                        LengthLimitingTextInputFormatter(1),
                        FormTextInputFormatter.onlyAlphabets,
                      ],
                      onChanged: (value) {
                        TeacherHelper.teacherQuizTextFieldOnChangedFormValue(
                            context: context,
                            value: value,
                            textEditingController:
                                correctOptionTextEditingController!);
                      },
                      textInputAction: TextInputAction.done,
                    ),
                  ],
                )
              : StatementTextFieldComponent(
                  textEditingController: singleOptionTextEditingController,
                  leadingTitle: '.',
                  hintText: 'Choice',
                ),
          SizedBox(
            height: context.height * 0.01,
          ),
        ],
      ),
    );
  }
}
