import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import 'responsive/responsive_center.dart';

/// A premium wrapper for all main screens in the navigation bar.
/// Standardizes the background blobs, layout, and responsiveness.
class MainScreenWrapper extends StatelessWidget {
  final Widget child;
  final Widget? appBar;
  final bool showBackground;
  final EdgeInsetsGeometry? padding;
  final bool useScroll;
  final RefreshCallback? onRefresh;

  const MainScreenWrapper({
    super.key,
    required this.child,
    this.appBar,
    this.showBackground = true,
    this.padding,
    this.useScroll = true,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    Widget scrollView;

    if (useScroll) {
      final List<Widget> slivers = [
        // AppBar as Sliver
        if (appBar != null) SliverToBoxAdapter(child: appBar!),

        // Main Content as Sliver
        SliverPadding(
          padding: padding ?? EdgeInsets.zero,
          sliver: SliverToBoxAdapter(child: child),
        ),

        // Bottom Spacing
        const SliverPadding(
          padding: EdgeInsets.only(bottom: AppSizes.space100),
        ),
      ];

      scrollView = CustomScrollView(
        physics: onRefresh != null
            ? const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              )
            : const BouncingScrollPhysics(),
        slivers: slivers,
      );

      if (onRefresh != null) {
        scrollView = RefreshIndicator(onRefresh: onRefresh!, child: scrollView);
      }
    } else {
      // No scroll mode - use Column with Center
      Widget content = child;
      if (padding != null) {
        content = Padding(padding: padding!, child: content);
      }

      scrollView = Column(
        children: [
          if (appBar != null) appBar!,
          Expanded(child: Center(child: content)),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          if (showBackground) const _AppBackgroundBlobs(),
          SafeArea(bottom: false, child: ResponsiveCenter(child: scrollView)),
        ],
      ),
    );
  }
}

class _AppBackgroundBlobs extends StatelessWidget {
  const _AppBackgroundBlobs();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top Left Blob
        Positioned(
          top: -100,
          left: -50,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.12),
              ),
            ),
          ),
        ),
        // Bottom Right Blob
        Positioned(
          bottom: 100,
          right: -100,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent.withOpacity(0.08),
              ),
            ),
          ),
        ),
        // Optional middle blob for more richness
        Positioned(
          top: MediaQuery.of(context).size.height * 0.4,
          right: -50,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purpleAccent.withOpacity(0.05),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
