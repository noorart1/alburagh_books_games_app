import 'package:flutter/material.dart';

/// Temporary placeholder for screens not yet built in this pass.
/// Replaced screen-by-screen as the rewrite proceeds.
class ComingSoonScaffold extends StatelessWidget {
  const ComingSoonScaffold({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          'قريباً',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
