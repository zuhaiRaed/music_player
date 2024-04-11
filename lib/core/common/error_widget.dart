import 'package:flutter/material.dart';

import '../style/style.dart';
import '../../../core/application.dart';

class MyErrorWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? message;
  const MyErrorWidget({super.key, required this.onPressed, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Icon(
            Icons.error_outline,
            size: 100,
            color: Style.error,
          ),
          const SizedBox(height: 16),
          Text(
            message == null
                ? application.translate('somethingWentWrong')
                : message!,
            style: Style.mainFont.bodyMedium?.copyWith(
              color: Style.secondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          if (onPressed != null)
            TextButton(
              onPressed: onPressed,
              child: Text(application.translate('tryAgain')),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
