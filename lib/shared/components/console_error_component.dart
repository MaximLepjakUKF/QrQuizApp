import 'package:flutter/material.dart';

import '../utils/constants/app_images.dart';


class ConsoleErrorComponent extends StatelessWidget {
  const ConsoleErrorComponent({super.key, this.flutterErrorDetails});

  final FlutterErrorDetails? flutterErrorDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppImages.errorImagePath,
            fit: BoxFit.fill,
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.14,
            left: MediaQuery.of(context).size.width * 0.065,
            child: flutterErrorDetails !=null ?  Text(flutterErrorDetails!.exception.toString().toUpperCase()) : const Text('')
            
          )
        ],
      ),
    );
  }
}
