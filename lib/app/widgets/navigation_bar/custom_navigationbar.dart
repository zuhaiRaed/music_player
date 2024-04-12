import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/application.dart';
import '../../routes/app_router.dart';
import '/core/style/assets.dart';
import '/core/style/style.dart';
import '../mini_player.dart';
import 'navigationbar_button.dart';

enum NavigationType { home, search,  podcast, settings }

typedef OnNavigationTap = Function(NavigationType);

class CustomNavigationBar extends HookWidget {
  final OnNavigationTap onNavigationTap;
  const CustomNavigationBar({super.key, required this.onNavigationTap});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState<NavigationType>(NavigationType.home);
    onTapClick(NavigationType type) {
      onNavigationTap(type);
      selectedIndex.value = type;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const MiniPlayer(),
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 31, sigmaY: 31),
            child: Container(
              height: kToolbarHeight + MediaQuery.of(context).padding.bottom,
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                color: Style.surfaceContainer.withOpacity(0.9),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x00000080),
                    spreadRadius: 25,
                    blurRadius: 25,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        NavigationBarButton(
                          isActive: selectedIndex.value == NavigationType.home,
                          svg: SvgAssets.home,
                          onPressed: () => onTapClick(NavigationType.home),
                        ),
                        NavigationBarButton(
                          isActive:
                              selectedIndex.value == NavigationType.search,
                          svg: SvgAssets.search,
                          onPressed: () => onTapClick(NavigationType.search),
                        ),
                        Container(
                          height: 45,
                          width: 45,
                          decoration: const BoxDecoration(
                            color: Style.primary,
                            shape: BoxShape.circle,
                          ),
                          child: TextButton(
                            onPressed: () {
                              application.appRouter.push(const FirebaseManageRoute());
                            },
                            child: SvgPicture.asset(
                              SvgAssets.headset,
                              height: 20,
                              colorFilter: const ColorFilter.mode(
                                Style.secondary,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        NavigationBarButton(
                          isActive:
                              selectedIndex.value == NavigationType.podcast,
                          svg: SvgAssets.podcast,
                          onPressed: () => onTapClick(NavigationType.podcast),
                        ),
                        NavigationBarButton(
                          isActive:
                              selectedIndex.value == NavigationType.settings,
                          svg: SvgAssets.settings,
                          onPressed: () => onTapClick(NavigationType.settings),
                        ),
                      ],
                    ),
                    // A sanke indicator
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// class SnakeIndicator extends StatelessWidget {
//   final int selectedIndex;
//   final int tabsCount;

//   SnakeIndicator({required this.selectedIndex, required this.tabsCount});

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final tabWidth = constraints.maxWidth / tabsCount;
//         final indicatorWidth = tabWidth - 40;
//         final left = tabWidth * selectedIndex + 20;

//         return AnimatedContainer(
//           duration: Duration(milliseconds: 300),
//           curve: Curves.easeInOut,
//           margin: EdgeInsets.only(left: left),
//           width: indicatorWidth,
//           height: 4,
//           decoration: BoxDecoration(
//             color: Colors.blue, // Adjust color as needed
//             borderRadius: BorderRadius.circular(10),
//           ),
//         );
//       },
//     );
//   }
// }

//  AnimatedPositioned(
//                       duration: const Duration(milliseconds: 300),
//                       curve: Curves.easeInOut,
//                       left: (size.width / 4) * selectedIndex.value.index + 50,
//                       bottom: 0,
//                       child: AnimatedContainer(
//                         height: 4,
//                         // change the width of the indicator based on the active tab
//                         width: 12,

//                         decoration: BoxDecoration(
//                           color: Style.primary,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         duration: const Duration(milliseconds: 300),
//                       ),
//                     ),
