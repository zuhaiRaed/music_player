import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '/core/style/assets.dart';
import '/core/style/style.dart';
import '../mini_player.dart';
import 'navigationbar_button.dart';

enum NavigationType { home, search, centerButton, podcast, settings }

typedef OnNavigationTap = Function(NavigationType);

class CustomNavigationBar extends StatefulWidget {
  final OnNavigationTap onNavigationTap;

  const CustomNavigationBar({super.key, required this.onNavigationTap});

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar>
    with SingleTickerProviderStateMixin {
  NavigationType selectedTab = NavigationType.home;
  int selectedIndex = 0;
  late AnimationController controller;
  Animation<double>? positionAnimation;
  Animation<double>? widthAnimation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateAnimations(selectedIndex);
    });
  }

  void _updateAnimations(int newIndex) {
    final screenWidth = MediaQuery.of(context).size.width;
    final numberOfIconIcons =
        NavigationType.values.length; // Total icons including the middle one
    final paddingBetweenIcons = (screenWidth - (numberOfIconIcons * 45)) /
        (numberOfIconIcons + 1); // Calculate the padding between icons
    const iconWidth = 45.0;

    // Calculate the center of the icon's position
    double getIconCenter(int index) {
      return paddingBetweenIcons * (index + 1) +
          iconWidth * index +
          iconWidth / 2;
    }

    final start = getIconCenter(selectedIndex);
    final end = getIconCenter(newIndex);
    final isMovingRight = newIndex > selectedIndex;
    const double baseWidth = 15.0;
    const double compressedWidth = 5.0; //  for "compress" effect
    const double expandedWidth = 60; // Expanded width for "release" effect

    widthAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: baseWidth, end: compressedWidth),
        weight: compressedWidth,
      ),
      TweenSequenceItem(
        tween:
            Tween<double>(begin: baseWidth, end: compressedWidth), // Compress
        weight: compressedWidth,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: compressedWidth,
          end: expandedWidth,
        ), // Expand to maximum
        weight: expandedWidth,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: expandedWidth,
          end: baseWidth,
        ), // Return to normal
        weight: baseWidth,
      ),
    ]).animate(controller);

    positionAnimation = Tween<double>(
      begin: start - baseWidth / 2, // Centering the animation on the icon
      end: end - baseWidth / 2,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: isMovingRight ? Curves.easeInToLinear : Curves.easeIn,
      ),
    );

    controller.reset();
    controller.forward();
    setState(() {
      selectedIndex = newIndex;
    });
  }

  onTapClick(NavigationType type) {
    widget.onNavigationTap(type);
    setState(() {
      selectedTab = type;
    });
    if (type.index != selectedIndex) {
      _updateAnimations(type.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const MiniPlayer(),
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 31, sigmaY: 31),
            child: Container(
              // height: kToolbarHeight + MediaQuery.of(context).padding.bottom,
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
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          NavigationBarButton(
                            isActive: selectedTab == NavigationType.home,
                            svg: SvgAssets.home,
                            onPressed: () => onTapClick(NavigationType.home),
                          ),
                          NavigationBarButton(
                            isActive: selectedTab == NavigationType.search,
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
                                onTapClick(NavigationType.centerButton);
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
                            isActive: selectedTab == NavigationType.podcast,
                            svg: SvgAssets.podcast,
                            onPressed: () => onTapClick(NavigationType.podcast),
                          ),
                          NavigationBarButton(
                            isActive: selectedTab == NavigationType.settings,
                            svg: SvgAssets.settings,
                            onPressed: () =>
                                onTapClick(NavigationType.settings),
                          ),
                        ],
                      ),
                      AnimatedBuilder(
                        animation: controller,
                        builder: (_, __) => SizedBox(
                          height: 5,
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 0,
                                left: positionAnimation?.value ??
                                    0 - (widthAnimation?.value ?? 20) / 2,
                                child: Container(
                                  width: widthAnimation?.value ?? 20,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: selectedTab ==
                                            NavigationType.centerButton
                                        ? Colors.transparent
                                        : Style.primary,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
