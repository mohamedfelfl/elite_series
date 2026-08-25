import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Elite Series';
  static const String dbName = 'sms_encrypted.db';
  static const String defaultRole = 'user';
  static const String adminRole = 'admin';
  static const String userRole = 'user';
  
  // Supported locales
  static const String en = 'en';
  static const String ar = 'ar';
  
  // Date formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';

  // Assets
  static const String logoAssetPath = 'assets/images/logo.png';

  // Student Code & Schedule Constants
  static const String studentCodePrefix = 'EL';
  static const String pngExtension = 'png';
  static const String daySaturday = 'saturday';
  static const String daySunday = 'sunday';
  static const String dayMonday = 'monday';
  static const String dayTuesday = 'tuesday';
  static const String dayWednesday = 'wednesday';
  static const String dayThursday = 'thursday';
  static const String dayFriday = 'friday';
}

class AppCardColors {
  static const cardBlue = Color(0xFF3353A4);
  static const cardTeal = Color(0xFF007A65);
  static const cardCyan = Color(0xFF0A5C6F);
  static const cardStripeBlue = Color(0xFF1856DB);
  static const cardStripeCyan = Color(0xFF00BFA5);
  static const cardPeachAccent = Color(0xFFFDE8DB);
  static const cardMintAccent = Color(0xFFD6F5EE);
  static const cardDivider = Color(0xFFD6E2F0);
  static const cardWhite = Color(0xFFFFFFFF);
  static const textDark = Color(0xFF1E293B);
  static const textCode = Color(0xFF0F172A);
  static const textLabel = Color(0xFF475569);
  static const footerText = Color(0xFF2E4B9E);

  // Legacy aliases for backwards compatibility
  static const navy = Color(0xFF0B192C);
  static const brandBlue = Color(0xFF1856DB);
  static const gold = Color(0xFFFF7A00);
  static const lightBg = Color(0xFFF4F8FC);
  static const cyanDivider = Color(0xFF00BFA5);
  static const textMuted = Color(0xFF64748B);
  static const successGreen = Color(0xFF10B981);
  static const iconAmber = Color(0xFFFFB020);
}
