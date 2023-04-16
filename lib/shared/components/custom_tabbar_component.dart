import 'package:flutter/material.dart';

class CustomTabbarComponent extends StatelessWidget {
  const CustomTabbarComponent(
      {super.key, required this.menuItems, required this.index});

  final List<String> menuItems;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              menuItems[index],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
            AnimatedContainer(
              duration: const Duration(seconds: 1),
              margin: const EdgeInsets.only(top: 1 / 4),
              height: 2,
              width: 30,
              color: Theme.of(context).primaryColorDark,
            )
          ],
        ),
      ),
    );
  }
}
