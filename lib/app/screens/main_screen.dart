import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../routes/app_router.dart';
import '../widgets/custom_navigationbar.dart';

@RoutePage()
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final navigationTabs = [
    //   NavigationBarModel(
    //     svgIcon: SvgAssets.home,
    //     label: 'All Songs',
    //   ),
    //   NavigationBarModel(
    //     svgIcon: SvgAssets.search,
    //     label: 'Search',
    //   ),
    //   NavigationBarModel(
    //     svgIcon: SvgAssets.podcast,
    //     label: 'Podcast',
    //   ),
    //   NavigationBarModel(
    //     svgIcon: SvgAssets.settings,
    //     label: 'Settings',
    //   ),
    // ];

    return AutoTabsRouter(
      routes: const [
        HomeRoute(),
        SearchRoute(),
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
