// ignore_for_file: unused_local_variable

import 'dart:developer';
import 'dart:io';

import 'package:barcode/barcode.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'package:pdf/widgets.dart' as pdf_widget;
import 'package:permission_handler/permission_handler.dart';
import 'package:qrquiz/shared/services/navigation_service.dart';
import 'package:qrquiz/shared/utils/database/firebase.dart';
import 'package:qrquiz/shared/utils/extensions/shared_extensions.dart';
import 'package:qrquiz/shared/utils/helpers/shared_helpers.dart';
import 'package:qrquiz/src/teacher/view/teacher_create_quiz.dart';

import '../../../../shared/components/quiz_questions_component.dart';

class TeacherHelper {
  static Future<XFile?> teacherImagePicker({
    required BuildContext context,
  }) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  static void createSubject({
    required BuildContext context,
    required XFile? pickedImage,
    required TextEditingController subjectName,
  }) async {
    if (pickedImage == null) {
      SharedHelpers.textFieldsPopup(text: 'Upload Image');
      return;
    }

    if (subjectName.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Subject Name');
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    SharedHelpers.loadingPopUp(context: context, text: 'Creating Subject');

    SharedHelpers.firebaseFirestoreStorage(
      context: context,
      method: () async {
        Reference storageReference = FirebaseAccess.firebaseStorageInstance
            .ref()
            .child(
                '${FirebaseCollectionNames.teacherCollection}/${DateTime.now().toString()}');
        UploadTask uploadTask =
            storageReference.putFile(File(pickedImage.path));
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
        String imageUrl = await taskSnapshot.ref.getDownloadURL();

        Future.delayed(
          const Duration(seconds: 1),
          () {
            FirebaseEndPoints.teacherCollection
                .doc(FirebaseAccess.firebaseAuthInstance.currentUser?.uid)
                .collection(FirebaseCollectionNames.teacherSubjectCollection)
                .where('subjectName',
                    isEqualTo: subjectName.text.toLowerCase().trim())
                .get()
                .then((querySnapshot) {
              if (querySnapshot.docs.isEmpty) {
                FirebaseEndPoints.teacherCollection
                    .doc(FirebaseAccess.firebaseAuthInstance.currentUser?.uid)
                    .collection(
                        FirebaseCollectionNames.teacherSubjectCollection)
                    .add({
                  'subjectName': subjectName.text.toLowerCase().trim(),
                  'subjectImage': imageUrl,
                });
                context.teacherViewModelRead.pickedImage = null;
                subjectName.clear();
                NavigationService().pop();
                SharedHelpers.successPopUp(
                  context: context,
                  text: 'Subject Created',
                  onTap: () => NavigationService().pop(),
                );
              } else {
                NavigationService().pop();
                SharedHelpers.errorPopUp(
                    context: context, text: 'Subject already exists');
                return;
              }
            });
          },
        );
      },
    );
  }

  static String buildBarcode(
    Barcode bc,
    String data, {
    String? filename,
    double? width,
    double? height,
    double? fontHeight,
  }) {
    
    final svg = bc.toSvg(
      data,
      width: width ?? 200,
      height: height ?? 80,
      fontHeight: fontHeight,
    );
    return svg;
    
  }

  static void createQuiz({
    required BuildContext context,
    required List<TeacherQuestionComponent> teacherQuestionComponentList,
    required TextEditingController subjectTextEditingController,
    required TextEditingController quizTimeTextEditingController,
  }) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (subjectTextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Choose Subject');
      return;
    }

    if (quizTimeTextEditingController.text.isEmpty) {
      SharedHelpers.textFieldsPopup(text: 'Enter Quiz Time');
      return;
    }

    for (int i = 0; i < teacherQuestionComponentList.length; i++) {
      if (teacherQuestionComponentList[i].isSingleorMultiple ==
          QuestionOptions.multiple) {
        if (teacherQuestionComponentList[i]
            .questionTextEditingController!
            .text
            .isEmpty) {
          SharedHelpers.textFieldsPopup(
              text: 'Question#${i + 1} Statement is missing');
          return;
        }
        if (teacherQuestionComponentList[i]
            .optionATextEditingController!
            .text
            .isEmpty) {
          SharedHelpers.textFieldsPopup(
              text: 'Question#${i + 1} Choice A is missing');
          return;
        }
        if (teacherQuestionComponentList[i]
            .optionBTextEditingController!
            .text
            .isEmpty) {
          SharedHelpers.textFieldsPopup(
              text: 'Question#${i + 1} Choice B is missing');
          return;
        }
        if (teacherQuestionComponentList[i]
            .optionCTextEditingController!
            .text
            .isEmpty) {
          SharedHelpers.textFieldsPopup(
              text: 'Question#${i + 1} Choice C is missing');
          return;
        }
        if (teacherQuestionComponentList[i]
            .optionDTextEditingController!
            .text
            .isEmpty) {
          SharedHelpers.textFieldsPopup(
              text: 'Question#${i + 1} Choice D is missing');
          return;
        }
        if (teacherQuestionComponentList[i]
            .correctOptionTextEditingController!
            .text
            .isEmpty) {
          SharedHelpers.textFieldsPopup(
              text: 'Question#${i + 1} Correct Option is missing');

          return;
        }
      } else {
        if (teacherQuestionComponentList[i]
            .singleOptionTextEditingController!
            .text
            .isEmpty) {
          SharedHelpers.textFieldsPopup(
              text: 'Question#${i + 1} Choice is missing');
          return;
        }
      }
    }
    SharedHelpers.confirmPopUp(
      context: context,
      text: 'Do you want to create the quiz',
      onYes: () {
        final dateTime = DateTime.now().toString();
        final svg = buildBarcode(
          Barcode.qrCode(),
          '${FirebaseAccess.firebaseAuthInstance.currentUser!.uid}/${subjectTextEditingController.text}/${teacherQuestionComponentList.length}/$dateTime/${quizTimeTextEditingController.text.toString()}/createdByTeacher',
          height: 200,
        );
        NavigationService().pop();
        SharedHelpers.loadingPopUp(context: context, text: 'Creating Quiz');
        SharedHelpers.firebaseFirestoreStorage(
          context: context,
          method: () {
            FirebaseEndPoints.teacherQuizCollection.add({
              'dateTime': DateTime.now(),
              'quizCreatedDateTime': dateTime,
              'qrCode': svg,
              'subjectName': subjectTextEditingController.text,
              'quizTime': quizTimeTextEditingController.text,
              'questions': teacherQuestionComponentList.map((question) {
                Map<String, dynamic> questionMapMultiple = {
                  'questionText': question.questionTextEditingController!.text,
                  'optionA': question.optionATextEditingController!.text,
                  'optionB': question.optionBTextEditingController!.text,
                  'optionC': question.optionCTextEditingController!.text,
                  'optionD': question.optionDTextEditingController!.text,
                  'correctOption':
                      question.correctOptionTextEditingController!.text,
                  'isMultiple': true,
                };
                Map<String, dynamic> questionMapSingle = {
                  'questionText': question.questionTextEditingController!.text,
                  'correctOption':
                      question.singleOptionTextEditingController!.text,
                  'isMultiple': false,
                };
                if (question.isSingleorMultiple == QuestionOptions.single) {
                  return questionMapSingle;
                } else {
                  return questionMapMultiple;
                }
              }).toList(),
            });
            Future.delayed(
              const Duration(seconds: 1),
              () {
                NavigationService().pushReplacement(
                  QuizQuestionsComponent(
                    appbarTitle: 'Question Paper',
                    isQuizCreation: true,
                    svg: svg,
                    teacherQuestionComponentList: teacherQuestionComponentList,
                    subjectTextEditingController: subjectTextEditingController,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  static void downloadQuiz({
    required BuildContext context,
    required List<TeacherQuestionComponent> teacherQuestionComponentList,
    required String qrCode,
    required TextEditingController subjectTextEditingController,
  }) async {

    final pdf = pdf_widget.Document();

    pdf.addPage(
      pdf_widget.MultiPage(
        crossAxisAlignment: pdf_widget.CrossAxisAlignment.start,
        build: (context) {
          return [
            pdf_widget.Align(
              alignment: pdf_widget.Alignment.topRight,
              child: pdf_widget.Container(
                width: 100,
                height: 100,
                child: pdf_widget.SvgImage(
                  svg: qrCode,
                ),
              ),
            ),
            pdf_widget.Center(
              child: pdf_widget.Text(
                '${subjectTextEditingController.text} Quiz',
                style: const pdf_widget.TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            pdf_widget.ListView.builder(
              itemCount: teacherQuestionComponentList.length,
              itemBuilder: (context, index) {
                return pdf_widget.Column(
                    crossAxisAlignment: pdf_widget.CrossAxisAlignment.start,
                    children: [
                      teacherQuestionComponentList[index].isSingleorMultiple ==
                              QuestionOptions.multiple
                          ? pdf_widget.Column(
                              crossAxisAlignment:
                                  pdf_widget.CrossAxisAlignment.start,
                              children: [
                                pdf_widget.Text(
                                  'Question  ${index + 1}',
                                  style: const pdf_widget.TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                pdf_widget.SizedBox(
                                  height: 5,
                                ),
                                pdf_widget.Text(
                                  teacherQuestionComponentList[index]
                                      .questionTextEditingController!
                                      .text,
                                  style: const pdf_widget.TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                pdf_widget.SizedBox(
                                  height: 5,
                                ),
                                pdf_widget.Row(
                                    mainAxisAlignment: pdf_widget
                                        .MainAxisAlignment.spaceBetween,
                                    children: [
                                      pdf_widget.Text(
                                        'a) ${teacherQuestionComponentList[index].optionATextEditingController!.text}',
                                        style: const pdf_widget.TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      pdf_widget.Text(
                                        'b) ${teacherQuestionComponentList[index].optionBTextEditingController!.text}',
                                        style: const pdf_widget.TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      pdf_widget.Text(
                                        'c) ${teacherQuestionComponentList[index].optionCTextEditingController!.text}',
                                        style: const pdf_widget.TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      pdf_widget.Text(
                                        'd) ${teacherQuestionComponentList[index].optionDTextEditingController!.text}',
                                        style: const pdf_widget.TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ]),
                                pdf_widget.SizedBox(
                                  height: 12,
                                ),
                              ],
                            )
                          : pdf_widget.Column(
                              crossAxisAlignment:
                                  pdf_widget.CrossAxisAlignment.start,
                              children: [
                                pdf_widget.Text(
                                  'Question  ${index + 1}',
                                  style: const pdf_widget.TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                pdf_widget.SizedBox(
                                  height: 5,
                                ),
                                pdf_widget.Text(
                                  teacherQuestionComponentList[index]
                                      .questionTextEditingController!
                                      .text,
                                  style: const pdf_widget.TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                pdf_widget.SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                    ]);
              },
            ),
          ];
        },
      ),
    );
    saveDocument(
        name: '${subjectTextEditingController.text} - Quiz.pdf', pdf: pdf);
  }

  static Future<void> saveDocument({
    required String name,
    required pdf_widget.Document pdf,
  }) async {
    final bytes = await pdf.save();
    bool permissionGranted = await requestStoragePermission();
    if (permissionGranted) {
      String newFilePath = await getNewFileName(name);
      File file = File(newFilePath);
      log(file.path);
      await file.create(recursive: true);
      await file.writeAsBytes(bytes);
      SharedHelpers.textFieldsPopup(text: 'Quiz Downloaded');
      await openFile(file);
    } else {
      SharedHelpers.textFieldsPopup(text: 'Please enable storage permission');
      return;
    }
  }

  static Future<String> getNewFileName(String name) async {
    Directory? dir = await getExternalStorageDirectory();
    String path = '${dir!.parent.parent.parent.parent.path}/Download/$name';
    File file = File(path);
    int count = 1;
    String newFilePath;
    String extension = file.path.split('.').last;
    String baseName = file.path.split('.').first;
    do {
      newFilePath = '${baseName}_$count.$extension';
      count++;
    } while (await File(newFilePath).exists());
    return newFilePath;
  }

  static Future openFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }

  static Future<bool> requestStoragePermission() async {
    AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
    int? sdkVersion = androidInfo.version.sdkInt;
    final PermissionStatus status;
    if (sdkVersion! >= 30) {
      status = await Permission.manageExternalStorage.request();
    } else {
      status = await Permission.storage.request();
    }
    if (status == PermissionStatus.granted) {
      return true;
    } else if (status == PermissionStatus.denied) {
      bool isOpened = await openAppSettings();
      return false;
    } else if (status == PermissionStatus.permanentlyDenied) {
      bool isOpened = await openAppSettings();
      return false;
    } else {
      return false;
    }
  }

  static void teacherQuizTextFieldOnChangedFormValue({
    required BuildContext context,
    required dynamic value,
    required TextEditingController textEditingController,
  }) {
    if (value != 'a' && value != 'b' && value != 'c' && value != 'd') {
      textEditingController.clear();
      SharedHelpers.textFieldsPopup(text: 'You can enter A,B,C,D');
    }
  }
}
