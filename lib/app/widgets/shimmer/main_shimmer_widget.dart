import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/style/style.dart';

class MainShimmerWidget extends StatelessWidget {
  final Widget child;
  const MainShimmerWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Style.surface,
      child: child,
    );
  }
}
