import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../core/style/style.dart';

@RoutePage()
class PodcastScreen extends StatelessWidget {
  const PodcastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            'Podcast',
            style: Style.mainFont.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
