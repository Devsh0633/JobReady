import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';

/// Reusable card component with consistent styling
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? color;
  final double? elevation;
  final Border? border;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.color,
    this.elevation,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Padding(
      padding: padding ?? AppSpacing.edgeInsetsAll16,
      child: child,
    );

    return Card(
      color: color ?? AppColors.surface,
      elevation: elevation ?? 2,
      margin: margin ??
          const EdgeInsets.symmetric(
            horizontal: AppSpacing.spacing16,
            vertical: AppSpacing.spacing8,
          ),
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusMedium,
        side: border != null
            ? border!.top
            : BorderSide.none,
      ),
      child: onTap != null
          ? InkWell(
              onTap: onTap,
              borderRadius: AppSpacing.borderRadiusMedium,
              child: cardContent,
            )
          : cardContent,
    );
  }
}

/// Compact card variant with less padding
class AppCardCompact extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? color;

  const AppCardCompact({
    super.key,
    required this.child,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: AppSpacing.edgeInsetsAll12,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spacing8,
        vertical: AppSpacing.spacing4,
      ),
      onTap: onTap,
      color: color,
      child: child,
    );
  }
}
