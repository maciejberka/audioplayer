import 'package:flutter/material.dart';

class APScaffold extends StatelessWidget {
  final Widget body;
  final String title;

  final BuildContext context;
  final String? routeName;

  const APScaffold({
    super.key,
    required this.body,
    required this.context,
    this.routeName,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: body,
        ),
      ),
    );
  }
}
