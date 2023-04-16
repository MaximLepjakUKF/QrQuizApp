import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../view/teacher_create_quiz.dart';

class TeacherViewModel with ChangeNotifier {
  XFile? _pickedImage;

  XFile? get pickedImage => _pickedImage;

  set pickedImage(XFile? value) {
    _pickedImage = value;
    notifyListeners();
  }

  List<TeacherQuestionComponent> _teacherQuestionComponentList = [
    TeacherQuestionComponent(
      questionTextEditingController: TextEditingController(),
      correctOptionTextEditingController: TextEditingController(),
      optionATextEditingController: TextEditingController(),
      optionBTextEditingController: TextEditingController(),
      optionCTextEditingController: TextEditingController(),
      optionDTextEditingController: TextEditingController(),
      isSingleorMultiple: QuestionOptions.single,
      singleOptionTextEditingController: TextEditingController(),
      
    ),
  ];

  List<TeacherQuestionComponent> get teacherQuestionComponentList =>
      _teacherQuestionComponentList;

  set teacherQuestionComponentList(List<TeacherQuestionComponent> value) {
    _teacherQuestionComponentList = value;
    notifyListeners();
  }

  update() {
    notifyListeners();
  }

  void updateQuestionType(int index, QuestionOptions questionType) {
    _teacherQuestionComponentList[index].isSingleorMultiple = questionType;
    notifyListeners();
  }

  removeFromTeacherQuestionComponentList() {
    _teacherQuestionComponentList.removeLast();
    notifyListeners();
  }

  List<TextEditingController> _questionTextEditingControllerList = [
    TextEditingController(),
  ];

  List<TextEditingController> get questionTextEditingControllerList =>
      _questionTextEditingControllerList;

  set questionTextEditingControllerList(List<TextEditingController> value) {
    _questionTextEditingControllerList = value;
    notifyListeners();
  }

  disposeValues(){
    List<TeacherQuestionComponent> teacherQuestionComponentListt = [];
    teacherQuestionComponentList = teacherQuestionComponentListt;    
  }
}
