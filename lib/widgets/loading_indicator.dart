import 'package:flutter/material.dart';


// A simple loading indicator widget
class LoadingIndicator_septa extends StatelessWidget {
  const LoadingIndicator_septa({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}