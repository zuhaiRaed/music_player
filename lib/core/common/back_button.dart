import 'package:flutter/material.dart';
import '/core/application.dart';

class MyBackButtonIcon extends StatelessWidget {
  const MyBackButtonIcon({super.key});

  /// Returns the appropriate "back" icon for the given `platform`.
  static IconData _getIconData(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return Icons.arrow_back;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return Icons.arrow_back_ios_new;
    }
  }

  @override
  Widget build(BuildContext context) => Icon(
        _getIconData(Theme.of(context).platform),
        textDirection:
            application.isLanguageLTR() ? TextDirection.ltr : TextDirection.rtl,
      );
}

class MyBackButton extends StatelessWidget {
  const MyBackButton({super.key, this.color, this.onPressed});
  final Color? color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    return IconButton(
      icon: const MyBackButtonIcon(),
      color: color,
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        } else {
          Navigator.maybePop(context);
        }
      },
    );
  }
}

/// A material design close button.

class MyCloseButton extends StatelessWidget {
  const MyCloseButton({super.key, this.color, this.onPressed});
  final Color? color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    return IconButton(
      icon: const Icon(Icons.close),
      color: color,
      tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        } else {
          Navigator.maybePop(context);
        }
      },
    );
  }
}
