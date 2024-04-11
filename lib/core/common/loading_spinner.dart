import 'package:flutter/material.dart';

import '../style/style.dart';

class LoadingSpinner extends StatelessWidget {
  final Color? color;
  final double? width;
  final double? height;

  const LoadingSpinner({super.key, this.color, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width ?? 35,
        height: height ?? 35,
        child: CircularProgressIndicator.adaptive(
          valueColor: AlwaysStoppedAnimation<Color>(color ?? Style.primary),
        ),
      ),
    );
  }
}
