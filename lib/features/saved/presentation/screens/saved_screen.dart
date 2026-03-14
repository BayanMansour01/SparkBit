import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_routes.dart';
import 'package:go_router/go_router.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

/// Saved courses screen with bookmarked content
class SavedScreen extends ConsumerWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          // Background Elements
          _buildBackgroundBlobs(context),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Opacity(opacity: value, child: child);
                    },
                    child: _buildSavedList(context, ref),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundBlobs(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -120,
          right: -60,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.1),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 50,
          left: -100,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(0.08),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Saved',
                style: GoogleFonts.outfit(
                  fontSize: AppSizes.font4xl,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppSizes.space4),
              Text(
                '12 courses saved',
                style: GoogleFonts.outfit(
                  fontSize: AppSizes.fontBase,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(AppSizes.space12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Icon(
              Icons.sort_rounded,
              color: Theme.of(context).colorScheme.onSurface,
              size: AppSizes.iconLg,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedList(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return profileAsync.when(
      data: (profile) {
        if (profile.id == -1) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                ),
                const SizedBox(height: AppSizes.space16),
                Text(
                  'Sign in to view saved courses',
                  style: GoogleFonts.outfit(
                    fontSize: AppSizes.fontLg,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSizes.space24),
                ElevatedButton(
                  onPressed: () => context.go(AppRoutes.signIn),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingXl,
                      vertical: AppSizes.paddingMd,
                    ),
                  ),
                  child: const Text('Sign In'),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AppSizes.paddingLg,
            0,
            AppSizes.paddingLg,
            AppSizes.space100,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: AppSizes.space16,
            crossAxisSpacing: AppSizes.space16,
            childAspectRatio: 0.7,
          ),
          itemCount: 12,
          itemBuilder: (context, index) {
            return _SavedCourseCard(
              title: _getCourseTitles()[index % _getCourseTitles().length],
              instructor: 'Expert Instructor',
              rating: '4.${8 - (index % 3)}',
              imageColor: _getCourseColor(index),
            );
          },
        );
      },
      loading: () => const _SavedGridSkeleton(),
      error: (_, __) => const SizedBox(),
    );
  }

  List<String> _getCourseTitles() {
    return [
      'Flutter Masterclass',
      'UI/UX Design Fundamentals',
      'Advanced JavaScript',
      'Python for Data Science',
      'Digital Marketing',
      'React Native',
    ];
  }

  Color _getCourseColor(int index) {
    final colors = [
      const Color(0xFF3776AB),
      Colors.purple,
      const Color(0xFFF0DB4F),
      Colors.teal,
      Colors.orange,
      const Color(0xFF61DAFB),
      Colors.pink,
      Colors.green,
    ];
    return colors[index % colors.length];
  }
}

class _SavedCourseCard extends StatelessWidget {
  final String title;
  final String instructor;
  final String rating;
  final Color imageColor;

  const _SavedCourseCard({
    required this.title,
    required this.instructor,
    required this.rating,
    required this.imageColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course Image/Thumbnail
          Stack(
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [imageColor, imageColor.withOpacity(0.7)],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppSizes.radiusXl),
                    topRight: Radius.circular(AppSizes.radiusXl),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.play_circle_filled_rounded,
                    color: Colors.white.withOpacity(0.9),
                    size: AppSizes.iconXl * 2,
                  ),
                ),
              ),
              Positioned(
                top: AppSizes.space8,
                right: AppSizes.space8,
                child: Container(
                  padding: const EdgeInsets.all(AppSizes.space6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.bookmark_rounded,
                    color: AppColors.primary,
                    size: AppSizes.iconMd,
                  ),
                ),
              ),
            ],
          ),

          // Course Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.space12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: AppSizes.fontMd,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppSizes.space6),
                  Text(
                    instructor,
                    style: GoogleFonts.outfit(
                      fontSize: AppSizes.fontXs,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: AppSizes.iconSm,
                        color: Color(0xFFFFC107),
                      ),
                      const SizedBox(width: AppSizes.space4),
                      Text(
                        rating,
                        style: GoogleFonts.outfit(
                          fontSize: AppSizes.fontXs,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SavedGridSkeleton extends StatelessWidget {
  const _SavedGridSkeleton();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSizes.paddingLg,
        0,
        AppSizes.paddingLg,
        AppSizes.space100,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSizes.space16,
        crossAxisSpacing: AppSizes.space16,
        childAspectRatio: 0.7,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppSizes.radiusXl),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppSizes.radiusXl),
                      topRight: Radius.circular(AppSizes.radiusXl),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.space12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: 90,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: 56,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
