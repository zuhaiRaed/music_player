import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class Style {
  static const Color primary = Color(0xffF75191); //primary
  static const Color secondary = Colors.white; // onprimary
  static const Color surfaceContainer = Color(0xff303033);
  static const Color surface = Color(0xff212A32); // background
  static const Color error = Colors.red;

  static late TextTheme mainFont;
  static late TextTheme secondaryFont;
  static late ThemeData mainTheme;

  static void _setTextTheme(BuildContext context) {
    mainFont = GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).apply(
      bodyColor: secondary,
      displayColor: secondary,
    );
    secondaryFont =
        GoogleFonts.latoTextTheme(Theme.of(context).textTheme).apply(
      bodyColor: secondary,
      displayColor: secondary,
    );
  }

  static ThemeData appTheme(BuildContext context) {
    _setTextTheme(context);

    /// Controll the app bar theme from here
    final AppBarTheme appBarTheme = AppBarTheme(
      elevation: 0.0,
      centerTitle: true,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ),
      actionsIconTheme: const IconThemeData(color: secondary),
      toolbarTextStyle: mainFont.titleLarge,
      titleTextStyle: mainFont.titleMedium?.copyWith(
        color: secondary,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      color: surface,
      iconTheme: const IconThemeData(color: secondary),
      surfaceTintColor: primary,
    );

    /// Controll the main theme from here
    return mainTheme = ThemeData(
      useMaterial3: false,
      appBarTheme: appBarTheme,
      brightness: Brightness.dark,
      primaryColor: primary,
      textTheme: mainFont,
      scaffoldBackgroundColor: surface,
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: primary.withOpacity(0.5),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceContainer,
        selectedItemColor: secondary,
        unselectedItemColor: secondary,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedIconTheme: IconThemeData(size: 30),
      ),
      colorScheme: ThemeData()
          .colorScheme
          .copyWith(
            primary: primary,
            onPrimary: secondary,
            secondary: secondary,
            background: surface,
            surface: surface,
            onSurface: secondary,
            surfaceVariant: surfaceContainer,
            brightness: Brightness.dark,
          )
          .copyWith(background: surface),
    );
  }
}
