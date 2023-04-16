import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../../shared/services/navigation_service.dart';
import '../../../shared/utils/database/firebase.dart';
import '../../../shared/utils/extensions/shared_extensions.dart';
import '../../../shared/utils/helpers/shared_helpers.dart';
import 'student_attempt_quiz_view.dart';
import 'student_dashboard_view.dart';
import '../view_model/student_view_model.dart';

// ignore: must_be_immutable
class StudentQrCodeScannerView extends StatelessWidget {
  StudentQrCodeScannerView({super.key});

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    var scanArea =
        (context.width < 400 || context.height < 400) ? 200.0 : 300.0;
    return WillPopScope(
      onWillPop: () async {
        controller?.stopCamera();
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            QRView(
              key: qrKey,
              onQRViewCreated: (controller) {
                _onQRViewCreated(controller, context);
              },
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: scanArea,
              ),
              onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
            ),
            Positioned(
              top: context.height * 0.08,
              left: context.width * 0.3,
              right: context.width * 0.3,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Consumer<StudentViewModel>(
                        builder: (context, value, child) {
                      return IconButton(
                        onPressed: () async {
                          await controller?.toggleFlash();
                          value.flashStatus =
                              await controller?.getFlashStatus();
                        },
                        icon: Icon(
                          value.flashStatus == false
                              ? Icons.flash_on_outlined
                              : Icons.flash_off_outlined,
                          color: Colors.white,
                        ),
                      );
                    }),
                    IconButton(
                      onPressed: () async {
                        await controller?.flipCamera();
                      },
                      icon: const Icon(
                        Icons.cameraswitch,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: context.height * 0.2,
              left: context.width * 0.2,
              right: context.width * 0.2,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Consumer<StudentViewModel>(
                    builder: (context, value, child) {
                  return Text(
                    value.qrStatus,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.white,
                        ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller, BuildContext context) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      final checkQrCode = scanData.code.toString();
      if (!checkQrCode.contains('createdByTeacher')) {
        context.studentViewModelRead.qrStatus = 'Scan Valid Qr Code';
        return;
      } else {
        controller.stopCamera();
        final extractedData = scanData.code?.split('/');
        final teacherId = extractedData?[0];
        final subjectName = extractedData?[1];
        final answersLength = extractedData?[2];
        final teacherCreatedQuizDateTime = extractedData?[3];
        final teacherQuizTimeLimit = extractedData?[4];
        CollectionReference collectionReference = FirebaseAccess
            .firebaseFirestoreInstance
            .collection(FirebaseCollectionNames.studentCollection)
            .doc(FirebaseAccess.firebaseAuthInstance.currentUser?.uid)
            .collection(FirebaseCollectionNames.studentQuizCollection);
        QuerySnapshot querySnapshot = await collectionReference
            .where('teacherId', isEqualTo: teacherId)
            .where('teacherCreatedQuizDateTime',
                isEqualTo: teacherCreatedQuizDateTime)
            .where('subjectName', isEqualTo: subjectName)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          Future.delayed(
            Duration.zero,
            () {
              NavigationService().pop();
              SharedHelpers.successPopUp(
                context: context,
                text: 'You have already submitted $subjectName quiz',
                onTap: () {
                  NavigationService()
                      .pushAndRemoveUntil(const StudentDashboardView());
                },
              );
              return;
            },
          );
        } else {
          controller.stopCamera();
          Future.delayed(
            const Duration(seconds: 2),
            () {
              context.studentViewModelRead.qrStatus = 'Valid Qr Code Detected';
              for (var i = 1; i <= int.parse(answersLength.toString()); i++) {
                context.studentViewModelRead.studentAnswerComponentList
                    .add(const StudentAnswerComponent());
                context.studentViewModelRead.answerTextEditingControllerList
                    .add(TextEditingController());
              }
              Future.delayed(
                Duration.zero,
                () {
                  context.studentViewModelRead.qrStatus = 'Scan Qr Code';
                  NavigationService().push(
                    StudentAttemptQuizView(
                      subjectName: subjectName.toString(),
                      teacherId: teacherId,
                      teacherCreatedQuizDateTime:
                          teacherCreatedQuizDateTime.toString(),
                      teacherQuizTimeLimit:
                          int.parse(teacherQuizTimeLimit.toString()),
                    ),
                  );
                },
              );
            },
          );
        }
      }

    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }
}
