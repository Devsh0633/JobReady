import 'package:flutter/material.dart';

/// App spacing constants
class AppSpacing {
  AppSpacing._();

  static const double spacing2 = 2.0;
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing40 = 40.0;
  static const double spacing48 = 48.0;
  static const double spacing64 = 64.0;

  // Common edge insets
  static const edgeInsetsAll8 = EdgeInsets.all(spacing8);
  static const edgeInsetsAll12 = EdgeInsets.all(spacing12);
  static const edgeInsetsAll16 = EdgeInsets.all(spacing16);
  static const edgeInsetsAll24 = EdgeInsets.all(spacing24);

  static const edgeInsetsHorizontal16 = EdgeInsets.symmetric(horizontal: spacing16);
  static const edgeInsetsHorizontal24 = EdgeInsets.symmetric(horizontal: spacing24);
  static const edgeInsetsVertical8 = EdgeInsets.symmetric(vertical: spacing8);
  static const edgeInsetsVertical12 = EdgeInsets.symmetric(vertical: spacing12);
  static const edgeInsetsVertical16 = EdgeInsets.symmetric(vertical: spacing16);

  // Border radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;

  static const borderRadiusSmall = BorderRadius.all(Radius.circular(radiusSmall));
  static const borderRadiusMedium = BorderRadius.all(Radius.circular(radiusMedium));
  static const borderRadiusLarge = BorderRadius.all(Radius.circular(radiusLarge));
  static const borderRadiusXLarge = BorderRadius.all(Radius.circular(radiusXLarge));
}
