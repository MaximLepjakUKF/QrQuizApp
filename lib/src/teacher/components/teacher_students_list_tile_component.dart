import 'package:flutter/material.dart';
import '../../../shared/utils/extensions/shared_extensions.dart';

class TeacherStudentsListTileComponent extends StatelessWidget {
  const TeacherStudentsListTileComponent({
    super.key,
    required this.studentName,
    required this.onTap,
  });

  final String studentName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: context.height * 0.062,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 6),
                blurRadius: 10,
                spreadRadius: 1,
                color: Color.fromRGBO(0, 0, 0, 0.15),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Text(
                  studentName,
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
