import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../src/authentication/view_model/authentication_view_model.dart';
import '../../../src/student/view_model/student_view_model.dart';
import '../../../src/teacher/view_model/teacher_view_model.dart';

extension BuildContextEntension<T> on BuildContext {
  bool get isMobile => MediaQuery.of(this).size.width <= 500.0;

  bool get isTablet =>
      MediaQuery.of(this).size.width < 1024.0 &&
      MediaQuery.of(this).size.width >= 650.0;

  bool get isSmallTablet =>
      MediaQuery.of(this).size.width < 650.0 &&
      MediaQuery.of(this).size.width > 500.0;

  bool get isDesktop => MediaQuery.of(this).size.width >= 1024.0;

  bool get isSmall =>
      MediaQuery.of(this).size.width < 850.0 &&
      MediaQuery.of(this).size.width >= 560.0;

  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;

  Size get size => MediaQuery.of(this).size;

  AuthenticationViewModel get authenticationViewModelRead =>
      read<AuthenticationViewModel>();

  StudentViewModel get studentViewModelRead =>
      read<StudentViewModel>();   

  TeacherViewModel get teacherViewModelRead =>
      read<TeacherViewModel>();         
}

extension FormValidators on String {
  bool get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(this);
  }

  bool get isValidName {
    final nameRegExp =
        RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
    return nameRegExp.hasMatch(this);
  }

  bool get isValidPassword {
    final passwordRegExp = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\><*~]).{8,}/pre>');
    return passwordRegExp.hasMatch(this);
  }

  bool get isNotNull {
    return isNotEmpty;
  }

  bool get isValidPhone {
    final phoneRegExp = RegExp(r"^\+?0[0-9]{10}$");
    return phoneRegExp.hasMatch(this);
  }
}

extension FormTextInputFormatter on TextInputFormatter {
  static final _emailRegex = RegExp(r'^[0-9A-Za-z@.]+');
  static final _alphabetsRegex = RegExp(r'^[A-Za-z ]+');
  static final _numbersRegex = RegExp(r'^[0-9]+');

  static TextInputFormatter get email {
    return FilteringTextInputFormatter.allow(_emailRegex);
  }

  static TextInputFormatter get onlyAlphabets {
    return FilteringTextInputFormatter.allow(_alphabetsRegex);
  }

  static TextInputFormatter get onlyNumbers {
    return FilteringTextInputFormatter.allow(_numbersRegex);
  }  

}
