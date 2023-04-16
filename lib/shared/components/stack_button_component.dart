import 'package:flutter/material.dart';
import '../utils/extensions/shared_extensions.dart';


class StackButtonComponent extends StatelessWidget {
  const StackButtonComponent({
    super.key,
    required this.onTap,
    required this.title,
    required this.imagePath1,
    required this.imagePath2,
  });

  final String imagePath1;
  final String imagePath2;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: context.height * 0.20,
        child: Stack(
          children: [
            Container(
              height: context.height * 0.2,
              margin: EdgeInsets.only(
                top: context.height * 0.065,
              ),
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
            ),
            Positioned(
              right: context.width * 0.062,
              child: Image.asset(
                imagePath1,
                height: 100,
                width: 100,
              ),
            ),
            Positioned(
              top: context.height * 0.095,
              left: context.width * 0.015,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    imagePath2,
                    height: 36,
                    width: 36,
                  ),
                  SizedBox(
                    height: context.height * 0.015,
                  ),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 29,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
