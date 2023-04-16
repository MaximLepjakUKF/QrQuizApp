import 'package:flutter/material.dart';
import '../utils/extensions/shared_extensions.dart';

class SubjectContainerComponent extends StatelessWidget {
  const SubjectContainerComponent({
    super.key,
    required this.subjectName,
    this.subjectImage,
    required this.onTap,
  });

  final String subjectName;
  final String? subjectImage;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: context.height * 0.159,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(33),
            gradient: const LinearGradient(
              colors: [
                Color.fromRGBO(49, 156, 255, 1),
                Color.fromRGBO(168, 213, 255, 1),
              ],
            ),
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
            padding: EdgeInsets.only(
              left: context.width * 0.03,
              right: context.width * 0.016,
              top: context.height * 0.024,
              bottom: context.height * 0.025,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  subjectName,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 25,
                      ),
                ),
                if (subjectImage != null)
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.pink.shade200,
                    backgroundImage: NetworkImage(
                      subjectImage!,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
