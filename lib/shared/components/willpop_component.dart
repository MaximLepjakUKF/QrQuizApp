import 'package:flutter/material.dart';

class WillPopComponent extends StatelessWidget {
  const WillPopComponent({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: child,
      onWillPop: () async => false,
    );
  }
}
