import 'package:flutter/material.dart';

import '../view/student_attempt_quiz_view.dart';

class StudentViewModel with ChangeNotifier {
  bool? _flashStatus = false;
  String _qrStatus = 'Scan Qr Code';

  bool? get flashStatus => _flashStatus;

  set flashStatus(bool? value) {
    _flashStatus = value;
    notifyListeners();
  }

  String get qrStatus => _qrStatus;

  set qrStatus(String value) {
    _qrStatus = value;
    notifyListeners();
  }

  List<StudentAnswerComponent> _studentAnswerComponentList = [];

  List<StudentAnswerComponent> get studentAnswerComponentList =>
      _studentAnswerComponentList;

  set studentAnswerComponentList(List<StudentAnswerComponent> value) {
    _studentAnswerComponentList = value;
    notifyListeners();
  }

  List<TextEditingController> _answerTextEditingControllerList = [];

  List<TextEditingController> get answerTextEditingControllerList =>
      _answerTextEditingControllerList;

  set answerTextEditingControllerList(List<TextEditingController> value) {
    _answerTextEditingControllerList = value;
    notifyListeners();
  }

  void disposeValues() {
    List<StudentAnswerComponent> studentAnswerComponentListt = [];
    List<TextEditingController> answerTextEditingControllerListt = [];
    answerTextEditingControllerList = answerTextEditingControllerListt;
    studentAnswerComponentList = studentAnswerComponentListt;
  }


  int _totalMarks = 0;

  int get totalMarks => _totalMarks;

  set totalMarks(int value) {
    _totalMarks = value;
    notifyListeners();
  }

  int _obtainedMarks= 0;

  int get obtainedMarks => _obtainedMarks;

  set obtainedMarks(int value) {
    _obtainedMarks = value;
    notifyListeners();
  }

}
