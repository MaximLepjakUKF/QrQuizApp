import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/navigation_service.dart';
import '../utils/constants/app_images.dart';
import '../utils/extensions/shared_extensions.dart';
import '../utils/helpers/shared_helpers.dart';
import '../../src/student/view/student_dashboard_view.dart';

class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  const AppBarComponent({
    super.key,
    this.centerWidget,
    this.elevation,
    this.leading,
    this.leadingWidth,
    this.actions,
    this.isDashboard = false,
    required this.title,
    this.automaticallyImplyLeading = false,
    this.onPressed,
  });

  final Widget? centerWidget;
  final double? elevation;
  final Widget? leading;
  final double? leadingWidth;
  final List<Widget>? actions;
  final bool? isDashboard;
  final String title;
  final bool automaticallyImplyLeading;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Padding(
          padding: EdgeInsets.only(
            left: isDashboard == true ? context.width * 0.04 : 0,
            right: isDashboard == true ? context.width * 0.04 : 0,
            bottom: context.height * 0.018,
          ),
          child: isDashboard == true
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      AppImages.accessoriesSVG,
                      fit: BoxFit.scaleDown,
                    ),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 26,
                          ),
                    ),
                    IconButton(
                      onPressed: () {
                        SharedHelpers.logout(
                          context: context,
                        );
                      },
                      icon: const Icon(
                        Icons.login_outlined,
                        size: 28,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (automaticallyImplyLeading == false)
                      IconButton(
                        onPressed: onPressed ??
                            () {
                              NavigationService().pop();
                            },
                        icon: const Icon(
                          Icons.arrow_back_ios_sharp,
                          size: 20,
                        ),
                      )
                    else
                      IconButton(
                        onPressed: () {
                          context.studentViewModelRead.disposeValues();
                          NavigationService()
                              .pushAndRemoveUntil(const StudentDashboardView());
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_sharp,
                          size: 20,
                        ),
                      ),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(),
                  ],
                ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
