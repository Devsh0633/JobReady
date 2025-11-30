import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

/// Section header component for organizing content
class AppSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const AppSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: AppSpacing.spacing16,
            vertical: AppSpacing.spacing12,
          ),
      margin: margin ??
          const EdgeInsets.only(
            top: AppSpacing.spacing16,
            bottom: AppSpacing.spacing8,
          ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.h3,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.spacing4),
                  Text(
                    subtitle!,
                    style: AppTypography.body2,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.spacing12),
            trailing!,
          ],
        ],
      ),
    );
  }
}

/// Compact section header with background
class AppSectionHeaderCompact extends StatelessWidget {
  final String title;
  final Color? backgroundColor;
  final Color? textColor;

  const AppSectionHeaderCompact({
    super.key,
    required this.title,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spacing12,
        vertical: AppSpacing.spacing8,
      ),
      margin: const EdgeInsets.only(
        top: AppSpacing.spacing16,
        bottom: AppSpacing.spacing8,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.grey100,
        borderRadius: AppSpacing.borderRadiusSmall,
      ),
      child: Text(
        title,
        style: AppTypography.body1.copyWith(
          fontWeight: FontWeight.w600,
          color: textColor ?? AppColors.textPrimary,
        ),
      ),
    );
  }
}
