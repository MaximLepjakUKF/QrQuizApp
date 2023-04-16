import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../shared/components/text_field_component.dart';
import '../../../shared/components/willpop_component.dart';
import '../../../shared/services/navigation_service.dart';
import '../../../shared/utils/constants/app_images.dart';
import '../../../shared/utils/extensions/shared_extensions.dart';
import '../utils/helpers/authentication_helpers.dart';
import 'signup_view.dart';
import '../view_model/authentication_view_model.dart';

import '../../../shared/components/close_keyboard_component.dart';

final List<String> authDropDown = ['Student', 'Teacher'];

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();
  final TextEditingController dropdownTextEditingController =
      TextEditingController()..text = 'Student';
  final TextEditingController recoveryEmailTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopComponent(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: CloseKeyBoardComponent(
          child: SizedBox(
            width: context.width,
            height: context.height,
            child: Padding(
              padding: EdgeInsets.only(
                left: context.width * 0.04,
                right: context.width * 0.04,
                top: context.height * 0.063,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Login Account',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: const Color.fromRGBO(0, 0, 0, 1),
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      SizedBox(
                        width: context.width * 0.006,
                      ),
                      SvgPicture.asset(
                        AppImages.userSVG,
                        fit: BoxFit.scaleDown,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: context.height * 0.108,
                  ),
                  SvgPicture.asset(
                    AppImages.appLogoSVG,
                    fit: BoxFit.scaleDown,
                  ),
                  SizedBox(
                    height: context.height * 0.052,
                  ),
                  InputTextFieldComponent(
                    textEditingController: emailTextEditingController,
                    hintText: 'Email',
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                    ),
                    textInputAction: TextInputAction.next,
                    textInputType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: context.height * 0.021,
                  ),
                  Consumer<AuthenticationViewModel>(
                      builder: (context, value, child) {
                    return InputTextFieldComponent(
                      textEditingController: passwordTextEditingController,
                      hintText: 'Password',
                      prefixIcon: const Icon(
                        Icons.lock,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          value.obsecurePassword = !value.obsecurePassword;
                        },
                        child: Icon(
                          value.obsecurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                      obsecureText: value.obsecurePassword,
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.text,
                    );
                  }),
                  SizedBox(
                    height: context.height * 0.021,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => WillPopComponent(
                            child: AlertDialog(
                              backgroundColor: Colors.white,
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Recover Password',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                  ),
                                  CloseButton(
                                    onPressed: () => NavigationService().pop(),
                                    color:
                                        const Color.fromRGBO(109, 106, 106, 1),
                                  )
                                ],
                              ),
                              content: InputTextFieldComponent(
                                textEditingController:
                                    recoveryEmailTextEditingController,
                                textInputFormatter: [
                                  FormTextInputFormatter.email,
                                ],
                                hintText: 'Email',
                                prefixIcon: const Icon(
                                  Icons.email_outlined,
                                ),
                                textInputAction: TextInputAction.done,
                                textInputType: TextInputType.emailAddress,
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () {
                                    AuthenticationHelpers.forgetPassword(
                                      context: context,
                                      emailTextEditingController:
                                          recoveryEmailTextEditingController,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Forgot Password ?',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: const Color.fromRGBO(0, 0, 0, 1),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: context.height * 0.021,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      AuthenticationHelpers.loginUser(
                        context: context,
                        emailTextEditingController: emailTextEditingController,
                        paswordTextEditingController:
                            passwordTextEditingController,
                        dropdownTextEditingController:
                            dropdownTextEditingController,
                      );
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: context.height * 0.01,
                  ),
                  TextButton(
                    onPressed: () {
                      context.authenticationViewModelRead.obsecurePassword =
                          true;
                      NavigationService().push(SignupView());
                    },
                    child: Text(
                      'Create Account',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: const Color.fromRGBO(0, 0, 0, 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
