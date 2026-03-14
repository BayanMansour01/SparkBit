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
      fadeOutDuration: const Duration(milliseconds: 120),
      placeholderFadeInDuration: const Duration(milliseconds: 120),
      placeholder: (context, url) =>
          placeholder ??
          AppShimmer(
            child: Container(
              width: width,
              height: height,
              color: palette.surface,
            ),
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
