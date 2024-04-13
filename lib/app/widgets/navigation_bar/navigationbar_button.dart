import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '/core/style/style.dart';

class NavigationBarButton extends StatelessWidget {
  final bool isActive;
  final String svg;
  final Function()? onPressed;
  const NavigationBarButton({
    super.key,
    required this.isActive,
    required this.svg,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: 45,
      child: TextButton(
        style: ButtonStyle(
          splashFactory: NoSplash.splashFactory,
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
        onPressed: onPressed,
        child: AnimatedSlide(
          offset: isActive == true ? const Offset(0, -0.1) : const Offset(0, 0),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
          child: AnimatedScale(
            scale: isActive == true ? 1.2 : 1,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            child: SvgPicture.asset(
              svg,
              height: 20,
              colorFilter:
                  const ColorFilter.mode(Style.secondary, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}
