import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../shared/utils/extensions/shared_extensions.dart';

import '../../../shared/components/text_field_component.dart';

class StatementTextFieldComponent extends StatelessWidget {
  const StatementTextFieldComponent({
    super.key,
    required this.leadingTitle,
    required this.hintText,
    this.textEditingController,
    this.textInputFormatter,
    this.onChanged,
    this.textInputAction,
  });

  final String leadingTitle;
  final String hintText;
  final TextEditingController? textEditingController;
  final List<TextInputFormatter>? textInputFormatter;
  final dynamic Function(String)? onChanged;
  final TextInputAction? textInputAction;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          leadingTitle,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        SizedBox(
          width: context.width * 0.03,
        ),
        Expanded(
          child: InputTextFieldComponent(
            textEditingController: textEditingController,
            hintText: hintText,
            textInputFormatter: textInputFormatter,
            onChanged: onChanged,
            textInputType: TextInputType.text,
            textInputAction: textInputAction ?? TextInputAction.next,
          ),
        ),
      ],
    );
  }
}
