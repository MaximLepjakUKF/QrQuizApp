import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../shared/utils/extensions/shared_extensions.dart';
import '../utils/helpers/teacher_helpers.dart';
import '../view_model/teacher_view_model.dart';

import '../../../shared/components/appbar_component.dart';
import 'package:badges/badges.dart' as badges;

import '../../../shared/components/text_field_component.dart';

class TeacherCreateSubject extends StatelessWidget {
  TeacherCreateSubject({super.key});

  final TextEditingController subjectTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool iskeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      appBar: const AppBarComponent(
        title: 'Create Subject',
      ),
      body: ChangeNotifierProvider(
          create: (context) => TeacherViewModel(),
          builder: (context, child) {
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
                    Consumer<TeacherViewModel>(
                        builder: (context, value, child) {
                      return Center(
                        child: badges.Badge(
                          onTap: () async {
                            value.pickedImage =
                                await TeacherHelper.teacherImagePicker(
                              context: context,
                            );
                          },
                          badgeContent:
                              const Icon(Icons.upload, color: Colors.white, size: 20),
                          position: badges.BadgePosition.bottomEnd(
                            bottom: 5,
                            end: -2,
                          ),
                          badgeAnimation: const badges.BadgeAnimation.fade(),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.pink.shade200,
                            backgroundImage: value.pickedImage != null
                                ? FileImage(
                                    File(value.pickedImage!.path),
                                  )
                                : null,
                          ),
                        ),
                      );
                    }),
                    SizedBox(
                      height: context.height * 0.069,
                    ),
                    Text(
                      'Subject Name',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: const Color.fromRGBO(109, 106, 106, 1),
                            fontSize: 16,
                          ),
                    ),
                    SizedBox(
                      height: context.height * 0.01,
                    ),
                    InputTextFieldComponent(
                      textEditingController: subjectTextEditingController,
                      hintText: 'Enter Subject Name',
                      hintStyle: GoogleFonts.outfit(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: const Color.fromRGBO(175, 175, 175, 1),
                      ),
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.text,
                      textInputFormatter: [
                        FormTextInputFormatter.onlyAlphabets,
                      ],
                    ),
                    const Spacer(),
                    if (!iskeyboardOpen)
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            TeacherHelper.createSubject(
                              context: context,
                              pickedImage:
                                  context.teacherViewModelRead.pickedImage,
                              subjectName: subjectTextEditingController,
                            );
                          },
                          child: Text(
                            'Submit',
                            style: GoogleFonts.aBeeZee(
                              fontWeight: FontWeight.w400,
                              fontSize: 25,
                              color: const Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ),
                        ),
                      ),
                    SizedBox(
                      height: context.height * 0.037,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
