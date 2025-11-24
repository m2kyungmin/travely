import 'package:flutter/material.dart';
import 'constants.dart';

class AppTheme {
  // 메인 컬러
  static const Color primaryColor = Color(AppConstants.primaryColorValue); // #4A90D9
  static const Color secondaryColor = Color(AppConstants.secondaryColorValue); // #FF6B6B
  static const Color backgroundColor = Color(AppConstants.backgroundColorValue); // #F8FAFC
  
  // 추가 컬러
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color successColor = Color(0xFF10B981);
  
  // 그라데이션
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryColor, Color(0xFF357ABD)],
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryColor, Color(0xFFE55555)],
  );

  // 텍스트 스타일
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.2,
    letterSpacing: -0.5,
    fontFamily: 'Noto Sans KR',
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.3,
    letterSpacing: -0.3,
    fontFamily: 'Noto Sans KR',
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
    fontFamily: 'Noto Sans KR',
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: textPrimary,
    height: 1.5,
    fontFamily: 'Noto Sans KR',
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textPrimary,
    height: 1.5,
    fontFamily: 'Noto Sans KR',
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textSecondary,
    height: 1.5,
    fontFamily: 'Noto Sans KR',
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textTertiary,
    height: 1.4,
    fontFamily: 'Noto Sans KR',
  );

  static const TextStyle buttonLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: white,
    letterSpacing: 0.5,
    fontFamily: 'Noto Sans KR',
  );

  static const TextStyle buttonMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: white,
    letterSpacing: 0.3,
    fontFamily: 'Noto Sans KR',
  );

  // 테마 데이터
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        background: backgroundColor,
        surface: white,
        error: errorColor,
        onPrimary: white,
        onSecondary: white,
        onBackground: textPrimary,
        onSurface: textPrimary,
        onError: white,
      ),
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: 'Noto Sans KR',
      
      // AppBar 테마
      appBarTheme: const AppBarTheme(
        backgroundColor: white,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),
      
      // 버튼 테마
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: buttonLarge,
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: buttonMedium.copyWith(color: primaryColor),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: buttonMedium.copyWith(color: primaryColor),
        ),
      ),
      
      // 카드 테마
      cardTheme: CardThemeData(
        color: white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      
      // 입력 필드 테마
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      
      // 진행 표시줄 테마
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryColor,
      ),
      
      // 아이콘 테마
      iconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),
    );
  }

  // 그림자
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get buttonShadow => [
        BoxShadow(
          color: primaryColor.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];

  // BorderRadius
  static const BorderRadius borderRadiusSmall = BorderRadius.all(Radius.circular(8));
  static const BorderRadius borderRadiusMedium = BorderRadius.all(Radius.circular(12));
  static const BorderRadius borderRadiusLarge = BorderRadius.all(Radius.circular(16));
  static const BorderRadius borderRadiusXLarge = BorderRadius.all(Radius.circular(20));
}

