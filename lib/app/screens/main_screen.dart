import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../core/common/common_ui.dart';
import '../routes/app_router.dart';
import '../widgets/navigation_bar/custom_navigationbar.dart';

@RoutePage()
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        HomeRoute(),
        SearchRoute(),
        FirebaseManageRoute(),
        PodcastRoute(),
        SettingsRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);

        return Scaffold(
          extendBody: true,
          body: child,
          bottomNavigationBar: CustomNavigationBar(
            onNavigationTap: (navigationType) {
              tabsRouter.setActiveIndex(navigationType.index);
            },
          ),
        );
      },
    );
  }
}
