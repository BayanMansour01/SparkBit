import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppShimmerPalette {
  final Color base;
  final Color highlight;
  final Color surface;
  final Color border;
  final Color placeholder;

  const AppShimmerPalette({
    required this.base,
    required this.highlight,
    required this.surface,
    required this.border,
    required this.placeholder,
  });
}

class AppShimmer extends StatelessWidget {
  final Widget child;

  const AppShimmer({super.key, required this.child});

  static AppShimmerPalette palette(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return AppShimmerPalette(
        base: const Color(0xFF2B3446),
        highlight: const Color(0xFF3B475F),
        surface: const Color(0xFF1F2937),
        border: const Color(0xFF334155),
        placeholder: const Color(0xFF4B5563),
      );
    }

    return AppShimmerPalette(
      base: const Color(0xFFE5E7EB),
      highlight: const Color(0xFFF3F4F6),
      surface: const Color(0xFFF8FAFC),
      border: const Color(0xFFE2E8F0),
      placeholder: const Color(0xFFFFFFFF),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = palette(context);
    return Shimmer.fromColors(
      baseColor: p.base,
      highlightColor: p.highlight,
      period: const Duration(milliseconds: 1400),
      child: child,
    );
  }
}
