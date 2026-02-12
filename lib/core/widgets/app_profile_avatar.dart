import 'package:flutter/material.dart';

class AppProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final bool isGuest;
  final VoidCallback? onTap;
  final bool showBorder;
  final Color? borderColor;

  const AppProfileAvatar({
    super.key,
    this.imageUrl,
    this.radius = 24,
    this.isGuest = false,
    this.onTap,
    this.showBorder = false,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget content;

    if (isGuest) {
      // Premium look for guest icon
      content = Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surfaceContainerHighest,
              theme.colorScheme.surfaceContainer,
            ],
          ),
        ),
        child: Icon(
          Icons.person_pin_rounded,
          size: radius * 1.1,
          color: theme.colorScheme.primary.withValues(alpha: 0.7),
        ),
      );
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      content = CircleAvatar(
        radius: radius,
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        backgroundImage: NetworkImage(imageUrl!),
        onBackgroundImageError:
            (_, __) {}, // Handled by child if needed or just blank
      );
    } else {
      // Fallback for logged in user without avatar
      content = Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.colorScheme.surfaceContainerHighest,
        ),
        child: Icon(
          Icons.person_rounded,
          size: radius * 1.2,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
        ),
      );
    }

    Widget result = content;

    if (showBorder) {
      result = Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color:
                borderColor ?? theme.colorScheme.primary.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: content,
      );
    }

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: result,
      );
    }

    return result;
  }
}
