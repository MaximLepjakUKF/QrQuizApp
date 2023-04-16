import 'package:flutter/material.dart';

import '../../../shared/components/appbar_component.dart';
import '../../../shared/components/willpop_component.dart';
import '../../../shared/services/navigation_service.dart';
import '../../../shared/utils/constants/app_images.dart';
import '../../../shared/utils/extensions/shared_extensions.dart';
import 'student_qr_code_scanner_view.dart';

import '../../../shared/components/stack_button_component.dart';
import 'student_subjects_view.dart';

final List<String> authDropDown = ['Student', 'Teacher'];

class StudentDashboardView extends StatelessWidget {
  const StudentDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopComponent(
      child: Scaffold(
        appBar: const AppBarComponent(
          title: 'Student Dashboard',
          isDashboard: true,
        ),
        body: SizedBox(
          width: context.width,
          height: context.height,
          child: Padding(
            padding: EdgeInsets.only(
              left: context.width * 0.04,
              right: context.width * 0.04,
              top: context.height * 0.027,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Let’s Play",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: const Color.fromRGBO(92, 176, 254, 1),
                      ),
                ),
                SizedBox(
                  height: context.height * 0.014,
                ),
                StackButtonComponent(
                  onTap: () async {
                    NavigationService().push(StudentQrCodeScannerView());
                  },
                  imagePath1: AppImages.bulb1PNG,
                  imagePath2: AppImages.bulb2PNG,
                  title: 'Attempt Quiz',
                ),
                SizedBox(
                  height: context.height * 0.02,
                ),
                StackButtonComponent(
                  onTap: () {
                    NavigationService().push(const StudentSubjectsView());
                  },
                  imagePath1: AppImages.result1PNG,
                  imagePath2: AppImages.result2PNG,
                  title: 'View Quiz Results',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
