import 'package:flutter/material.dart';
import '/app/widgets/shimmer/main_shimmer_widget.dart';
import '/core/common/app_padding.dart';
import 'skeleton.dart';

class SongsListShimmer extends StatelessWidget {
  const SongsListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPadding(
      child: MainShimmerWidget(
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(
              10,
              (index) => const ListTile(
                title: Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Skeleton(
                    height: 12,
                    width: 200,
                  ),
                ),
                subtitle: Skeleton(
                  height: 6,
                  width: 50,
                ),
                trailing: Skeleton(
                  height: 8,
                  width: 16,
                ),
                leading: CircleSkeleton(
                  size: 35,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
