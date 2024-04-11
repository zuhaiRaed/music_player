import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../core/style/style.dart';

@RoutePage()
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Settings',
          style:
              Style.mainFont.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
