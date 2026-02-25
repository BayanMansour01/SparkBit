import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

enum AppButtonVariant { primary, secondary, outline, ghost, error }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final AppButtonVariant variant;
  final double? width;
  final double height;
  final double? fontSize;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.width,
    this.height = 56,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      height: height,
      decoration: _getBoxDecoration(isDark),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.space16),
            child: Center(
              child: isLoading
                  ? _buildLoadingIndicator()
                  : _buildContent(isDark),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _getBoxDecoration(bool isDark) {
    switch (variant) {
      case AppButtonVariant.primary:
        return BoxDecoration(
          gradient: LinearGradient(
            colors: onPressed == null
                ? [Colors.grey.shade400, Colors.grey.shade500]
                : [AppColors.primary, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          boxShadow: onPressed == null
              ? []
              : [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
        );
      case AppButtonVariant.secondary:
        return BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
        );
      case AppButtonVariant.outline:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: AppColors.primary, width: 1.5),
        );
      case AppButtonVariant.ghost:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        );
      case AppButtonVariant.error:
        return BoxDecoration(
          color: AppColors.error.withOpacity(isDark ? 0.2 : 0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: AppColors.error.withOpacity(0.5)),
        );
    }
  }

  Widget _buildContent(bool isDark) {
    final color = _getTextColor(isDark);
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, color: color, size: AppSizes.iconMd),
          const SizedBox(width: AppSizes.space8),
        ],
        Flexible(
          child: Text(
            text,
            style: GoogleFonts.outfit(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: fontSize ?? AppSizes.fontLg,
              letterSpacing: 0.5,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Color _getTextColor(bool isDark) {
    if (onPressed == null) return Colors.white;
    switch (variant) {
      case AppButtonVariant.primary:
        return Colors.white;
      case AppButtonVariant.secondary:
        return isDark ? AppColors.darkText : AppColors.lightText;
      case AppButtonVariant.outline:
        return AppColors.primary;
      case AppButtonVariant.ghost:
        return isDark ? AppColors.darkText : AppColors.lightText;
      case AppButtonVariant.error:
        return AppColors.error;
    }
  }

  Widget _buildLoadingIndicator() {
    return const SizedBox(
      height: 24,
      width: 24,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }
}
