import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../resources/values_manager.dart';
import 'app_update_listener.dart';
import '../../features/profile/presentation/providers/profile_provider.dart';

class MainWrapper extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const MainWrapper({super.key, required this.navigationShell});

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider).valueOrNull;
    final isGuest = profile?.id == -1;

    return AppUpdateListener(
      child: Scaffold(
        extendBody: true, // Allow body to extend behind the navbar
        body: navigationShell,
        bottomNavigationBar: _CustomBottomNavBar(
          currentIndex: navigationShell.currentIndex,
          onTap: (index) => _onTap(context, index),
          isGuest: isGuest,
        ),
      ),
    );
  }
}

class _CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isGuest;

  const _CustomBottomNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.isGuest,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if we are in landscape or use a safe area bottom padding
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppPadding.p20,
        0,
        AppPadding.p20,
        bottomPadding +
            AppPadding.p20, // Add bottom padding for "floating" look
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.r40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius:
                  25, // No specialized constant for shadowBlur25 in AppRadius, kept raw or added to AppSize? I added AppSize.s25 in values_manager
              offset: const Offset(0, 10), // AppSize.s10
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.r40),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppPadding.p24,
                vertical: AppPadding.p6,
              ),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surfaceContainer.withOpacity(0.95),
                borderRadius: BorderRadius.circular(AppRadius.r40),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _NavBarItem(
                    icon: Icons.home_rounded,
                    isActive: currentIndex == 0,
                    label: 'Home',
                    onTap: () => onTap(0),
                  ),
                  _NavBarItem(
                    icon: isGuest
                        ? Icons.explore_rounded
                        : Icons.school_rounded,
                    isActive: currentIndex == 1,
                    label: isGuest ? 'Browse' : 'My Courses',
                    onTap: () => onTap(1),
                  ),
                  // _NavBarItem(
                  //   icon: Icons.bookmark_rounded,
                  //   isActive: currentIndex == 2,
                  //   label: 'Saved',
                  //   onTap: () => onTap(2),
                  // ),
                  _NavBarItem(
                    icon: Icons.person_rounded,
                    isActive: currentIndex == 2, // Shifted index
                    label: 'Profile',
                    onTap: () => onTap(2), // Shifted index
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final String label;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.isActive,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? AppPadding.p20 : AppPadding.p12,
          vertical: AppPadding.p12,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).colorScheme.primary.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.r24),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              size: AppSize.s20,
            ),
            if (isActive) ...[
              const SizedBox(width: AppSize.s8),
              Text(
                label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13, // fontSm
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
