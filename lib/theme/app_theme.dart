import 'package:flutter/material.dart';

class AppTheme {
  static const textFontFamily = 'Times';

  static ThemeData darkTheme() {
    return ThemeData(
        cardTheme: CardTheme(
            color: Colors.black,
            surfaceTintColor: Colors.black,
            shadowColor: Colors.transparent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 0),
        fontFamily: textFontFamily,
        progressIndicatorTheme:
            const ProgressIndicatorThemeData(color: Colors.red),
        colorScheme: const ColorScheme.dark(
            primary: Colors.red,
            background: Colors.black,
            primaryContainer: Colors.transparent),
        textTheme: const TextTheme(
            titleSmall: TextStyle(
                fontFamily: 'Times', fontSize: 12, fontWeight: FontWeight.w700),
            bodyLarge: TextStyle(
                fontFamily: 'Soviet-large',
                fontWeight: FontWeight.w700,
                fontSize: 22,
                color: Colors.red),
            headlineLarge: TextStyle(
                color: Colors.white, fontSize: 20, fontFamily: 'Soviet-large'),
            titleLarge: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              fontFamily: 'Times',
            ),
            titleMedium: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: 'Times'),
            bodyMedium: TextStyle(
                color: Colors.white, fontSize: 18, fontFamily: 'Times'),
            labelMedium: TextStyle(
              color: Colors.white38,
              fontSize: 14,
              fontFamily: 'Times',
              fontStyle: FontStyle.italic,
            ),
            labelSmall: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700),
            bodySmall: TextStyle(
                color: Colors.white, fontSize: 16, fontFamily: 'Times')),
        appBarTheme: AppBarTheme(
            surfaceTintColor: Colors.black.withOpacity(0.9),
            backgroundColor: Colors.black.withOpacity(0.9),
            titleTextStyle: const TextStyle(color: Colors.white)),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: Colors.red)),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(foregroundColor: Colors.red),
        ));
  }

  static ThemeData lightTheme() {
    return ThemeData(
        fontFamily: textFontFamily,
        cardTheme: CardTheme(
            color: Colors.white,
            surfaceTintColor: Colors.white,
            shadowColor: Colors.transparent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 0),
        progressIndicatorTheme:
            const ProgressIndicatorThemeData(color: Colors.red),
        colorScheme: const ColorScheme.light(
            primary: Colors.red,
            background: Colors.white,
            primaryContainer: Colors.transparent),
        textTheme: const TextTheme(
            titleSmall: TextStyle(
                fontFamily: 'Times', fontSize: 12, fontWeight: FontWeight.w700),
            bodyLarge: TextStyle(
                fontFamily: 'Soviet-large',
                fontWeight: FontWeight.w700,
                fontSize: 22,
                color: Colors.red),
            headlineLarge: TextStyle(
                color: Colors.white, fontSize: 20, fontFamily: 'Soviet-large'),
            titleLarge: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              fontFamily: 'Times',
            ),
            titleMedium: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: 'Times'),
            bodyMedium: TextStyle(
                color: Colors.black, fontSize: 18, fontFamily: 'Times'),
            labelMedium: TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontFamily: 'Times',
              fontStyle: FontStyle.italic,
            ),
            labelSmall: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700),
            bodySmall: TextStyle(
                color: Colors.black, fontSize: 16, fontFamily: 'Times')),
        appBarTheme: AppBarTheme(
            surfaceTintColor: const Color(0xFFcc0000).withOpacity(0.9),
            backgroundColor: const Color(0xFFcc0000).withOpacity(0.9),
            titleTextStyle: const TextStyle(color: Colors.white)),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: Colors.red)),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(foregroundColor: Colors.yellow),
        ));
  }
}
