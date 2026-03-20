import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'shimmers/app_shimmer.dart';

class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? errorWidget;
  final Widget? placeholder;
  final Duration fadeInDuration;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.errorWidget,
    this.placeholder,
    this.fadeInDuration = const Duration(milliseconds: 280),
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppShimmer.palette(context);

    Widget child = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: fadeInDuration,
      fadeOutDuration: const Duration(milliseconds: 260),
      placeholderFadeInDuration: const Duration(milliseconds: 120),
      placeholder: (context, url) =>
          placeholder ??
          _AnimatedImagePlaceholder(
            width: width,
            height: height,
            palette: palette,
          ),
      errorWidget: (context, url, error) =>
          errorWidget ??
          Container(
            width: width,
            height: height,
            color: palette.surface,
            alignment: Alignment.center,
            child: Icon(
              Icons.image_not_supported_rounded,
              size: 24,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
          ),
    );

    if (borderRadius != null) {
      child = ClipRRect(borderRadius: borderRadius!, child: child);
    }

    return child;
  }
}

class _AnimatedImagePlaceholder extends StatefulWidget {
  final double? width;
  final double? height;
  final AppShimmerPalette palette;

  const _AnimatedImagePlaceholder({
    required this.width,
    required this.height,
    required this.palette,
  });

  @override
  State<_AnimatedImagePlaceholder> createState() =>
      _AnimatedImagePlaceholderState();
}

class _AnimatedImagePlaceholderState extends State<_AnimatedImagePlaceholder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;
  late final Animation<double> _blurAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    )..repeat(reverse: true);
    _opacityAnimation = Tween<double>(
      begin: 0.55,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _blurAnimation = Tween<double>(
      begin: 10,
      end: 4,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _opacityAnimation.value,
            child: ImageFiltered(
              imageFilter: ui.ImageFilter.blur(
                sigmaX: _blurAnimation.value,
                sigmaY: _blurAnimation.value,
              ),
              child: child,
            ),
          );
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.palette.surface,
                widget.palette.base.withOpacity(0.9),
                widget.palette.highlight,
              ],
            ),
          ),
          child: SizedBox(width: widget.width, height: widget.height),
        ),
      ),
    );
  }
}
