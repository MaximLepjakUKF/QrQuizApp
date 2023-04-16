import 'package:flutter/material.dart';

class ViewNotFoundComponent extends StatelessWidget {
  final String viewName;
  

  const ViewNotFoundComponent({
    Key? key,
    required this.viewName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parsedRoute = viewName.substring(1);
    return  Card(
      color: Colors.red,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "${parsedRoute.toUpperCase()} View Not Found",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
