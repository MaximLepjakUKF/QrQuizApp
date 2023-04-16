import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../shared/components/selectable_dropdown_component.dart';
import '../../../shared/components/text_field_component.dart';
import '../../../shared/services/navigation_service.dart';
import '../../../shared/utils/constants/app_images.dart';
import '../../../shared/utils/extensions/shared_extensions.dart';
import 'login_view.dart';

import '../utils/helpers/authentication_helpers.dart';
import '../view_model/authentication_view_model.dart';

final List<String> authDropDown = ['Student', 'Teacher'];

class SignupView extends StatelessWidget {
  SignupView({super.key});

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
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
                    'Create Account',
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
              SelectableDropDownComponent(
                selectedValue: (value) {
                  dropdownTextEditingController.text = value;
                },
                items: authDropDown
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
                hintText: 'Student',
              ),
              SizedBox(
                height: context.height * 0.042,
              ),
              ElevatedButton(
                onPressed: () {
                  AuthenticationHelpers.createUser(
                    context: context,
                    emailTextEditingController: emailTextEditingController,
                    paswordTextEditingController: passwordTextEditingController,
                    dropdownTextEditingController:
                        dropdownTextEditingController,
                  );
                },
                child: const Text(
                  'Signup',
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
                  context.authenticationViewModelRead.obsecurePassword = true;
                  NavigationService().pushReplacement(LoginView());
                },
                child: Text(
                  'Login',
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
    );
  }
}
