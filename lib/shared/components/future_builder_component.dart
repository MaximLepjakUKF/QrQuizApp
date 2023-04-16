import 'dart:io';

import 'package:flutter/material.dart';

class FutureBuilderComponent<T> extends StatelessWidget {
  final Future<T> future;
  final AsyncWidgetBuilder<T> builder;

  const FutureBuilderComponent({
    Key? key,
    required this.future,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          if (snapshot.error is SocketException) {
            return const Text('No internet connection.');
          } else {
            return Text('An error occurred: ${snapshot.error}');
          }
        } else if (snapshot.hasData) {
          return builder(context, snapshot);
        } else {
          return const Text('No data available.');
        }
      },
    );
  }
}
