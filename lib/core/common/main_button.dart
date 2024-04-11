import 'package:flutter/material.dart';
import '../style/style.dart';
import 'loading_spinner.dart';

class MainButton extends StatelessWidget {
  final String text;
  final bool isBordered;
  final bool isLoading;
  final VoidCallback onPressed;
  final Widget? icon;
  final double radius;
  final Color? color;
  final TextStyle? textStyle;
  final double? width;
  final double? height;
  final bool isDisabled;
  final bool iconRight;

  const MainButton({
    super.key,
    this.isBordered = false,
    required this.text,
    required this.onPressed,
    this.radius = 40,
    this.color,
    this.icon,
    this.textStyle,
    this.width = 165,
    this.height = 39,
    this.isDisabled = false,
    this.isLoading = false,
    this.iconRight = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoading();
    }

    if (icon != null) {
      return _buildIconButton(context);
    }

    return _buildButton(context);
  }

  Widget _buildLoading() {
    return SizedBox(
      height: height,
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: LoadingSpinner(),
        ),
      ),
    );
  }

  Widget _buildIconButton(BuildContext context) {
    final buttonStyle = _buttonStyle(context);
    final textStyle = _textStyle(context);
    final textb = text.toUpperCase();

    return iconRight
        ? TextButton.icon(
            onPressed: isDisabled ? null : onPressed,
            icon: Text(textb, style: textStyle),
            label: icon!,
            style: buttonStyle,
          )
        : TextButton.icon(
            onPressed: isDisabled ? null : onPressed,
            icon: icon!,
            label: Text(textb, style: textStyle),
            style: buttonStyle,
            // Note: Swapping label and icon if iconRight is false is handled by modifying the order here.
          );
  }

  Widget _buildButton(BuildContext context) {
    final buttonStyle = _buttonStyle(context);
    final textStyle = _textStyle(context);
    final textb = text.toUpperCase();

    return TextButton(
      onPressed: isDisabled ? null : onPressed,
      style: buttonStyle,
      child: Text(textb, style: textStyle),
    );
  }

  ButtonStyle _buttonStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextButton.styleFrom(
      backgroundColor: isBordered
          ? Colors.transparent
          : isDisabled
              ? Colors.grey.withOpacity(0.4)
              : color ?? colorScheme.primary,
      minimumSize: Size(width!, height!),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      side: isBordered ? BorderSide(color: color ?? colorScheme.primary) : null,
    );
  }

  TextStyle? _textStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return textStyle ??
        Style.mainFont.labelLarge?.copyWith(
          color: isBordered ? color ?? colorScheme.primary : Colors.white,
        );
  }
}
