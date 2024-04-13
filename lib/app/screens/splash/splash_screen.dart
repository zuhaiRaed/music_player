import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';
import 'package:music_player/core/common/common_ui.dart';
import '../../../core/utils/utils.dart';
import '../../routes/app_router.dart';
import '/core/style/assets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '/core/application.dart';

@RoutePage()
class SplashScreen extends HookConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final expanded = useState(false);
    CommonUi.checkInternet(context);

    dynamic animationDelay() async {
      final isOnline = await Utils.isOnline();
      await Future.delayed(const Duration(seconds: 1));
      if (context.mounted) expanded.value = true;
      await Future.delayed(const Duration(seconds: 1));
      if (isOnline) {
        await application.appRouter.replace(const MainRoute());
      }
    }

    animationDelay();
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: LottieBuilder.asset(
                height: 200,
                AnimeAssets.logo,
                repeat: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
