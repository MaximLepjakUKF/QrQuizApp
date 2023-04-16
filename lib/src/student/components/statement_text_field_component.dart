import 'package:flutter/material.dart';

import '../../../shared/components/text_field_component.dart';
import '../../../shared/utils/extensions/shared_extensions.dart';

class StatementTextFieldComponent extends StatelessWidget {
  const StatementTextFieldComponent({
    super.key,
    required this.leadingTitle,
    required this.hintText,
  });

  final String leadingTitle;
  final String hintText;

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
            hintText: hintText,
          ),
        ),
      ],
    );
  }
}
