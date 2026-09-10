import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AppColors {
  static const Color primaryBlue = Color(0xFF3F7AA3);
  static const Color darkBlue = Color(0xFF3A6984);
  static const Color turquoise = Color(0xFF5BB7C5);
  static const Color cyan = Color(0xFF48B5C1);
  static const Color brightCyan = Color(0xFF1DD1E5);
  static const Color lightCyan = Color(0xFFB2E3EC);
  static const Color softCyan = Color(0xFF8FD3DD);
  static const Color loginButton = Color(0xFF3F7AA3);
  static const Color bgHome = Color(0xFFF4F6F8);
  static const Color textDark = Color(0xFF1F2933);
  static const Color textMuted = Color(0xFF7B8A99);
  static const Color inputBg = Color(0xFFF7FAFC);
  static const Color inputBorder = Color(0xFFE3E9EF);
  static const Color arrowBg = Color(0xFFEFF3F6);
  static const Color divider = Color(0xFFECEFF2);

  static const List<Color> loginBg = [Color(0xFFF7FAFC), Color(0xFFEFF4F8)];
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 28;
  static const double xxxl = 40;
}

class AppRadius {
  static const double sm = 10;
  static const double md = 14;
  static const double lg = 20;
  static const double xl = 26;
  static const double pill = 100;
}

class AppShadow {
  static List<BoxShadow> soft = [
    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 18, offset: const Offset(0, 6)),
  ];
  static List<BoxShadow> pressed = [
    BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
  ];
  static List<BoxShadow> elevated = [
    BoxShadow(color: Colors.black.withOpacity(0.14), blurRadius: 28, offset: const Offset(0, 12)),
  ];
}

class AppText {
  static const TextStyle h1 = TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textDark, letterSpacing: -0.3);
  static const TextStyle h2 = TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textDark, letterSpacing: -0.2);
  static const TextStyle body = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textDark, height: 1.5);
  static const TextStyle bodyMuted = TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.textMuted, height: 1.5);
  static const TextStyle label = TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textMuted, letterSpacing: 0.2);
  static const TextStyle button = TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.1);
}

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      scaffoldBackgroundColor: Colors.white,
      splashFactory: InkRipple.splashFactory,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryBlue,
        primary: AppColors.primaryBlue,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
