import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/shimmers/app_shimmer.dart';
import '../../../../core/widgets/main_screen_wrapper.dart';
import '../../data/models/course_model.dart';
import '../providers/courses_provider.dart';

class MyCoursesScreen extends ConsumerWidget {
  const MyCoursesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myCoursesAsync = ref.watch(myCoursesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MainScreenWrapper(
      onRefresh: () async {
        ref.invalidate(myCoursesProvider);
        await ref.read(myCoursesProvider.future);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSizes.paddingLg),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLg),
            child: Text(
              'My Learning',
              style: GoogleFonts.outfit(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.space24),
          myCoursesAsync.when(
            data: (paginatedData) {
              final courses = paginatedData.data;

              if (courses.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.paddingLg),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),
                        Container(
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.school_rounded,
                            size: 80,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Start Your Journey!',
                          style: GoogleFonts.outfit(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'You haven\'t enrolled in any courses yet. Explore our library and start learning today.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            color: isDark
                                ? Colors.grey[400]
                                : const Color(0xFF64748B),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () =>
                                context.pushNamed(AppRoutes.allCoursesName),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'Explore Courses',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                itemCount:
                    courses.length +
                    (ref.read(myCoursesProvider.notifier).hasMore ? 1 : 0),
                separatorBuilder: (_, __) => const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  if (index == courses.length) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: _MyLearningCardShimmer(),
                    );
                  }

                  // Pagination check
                  if (index == courses.length - 1 &&
                      ref.read(myCoursesProvider.notifier).hasMore) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ref.read(myCoursesProvider.notifier).loadNextPage();
                    });
                  }

                  final course = courses[index];
                  return _MyCourseCard(
                    course: course,
                    onTap: () =>
                        context.push(AppRoutes.courseDetails, extra: course),
                  );
                },
              );
            },
            loading: () => const _MyLearningListShimmer(itemCount: 6),
            error: (err, stack) => ErrorView(
              error: err,
              onRetry: () => ref.refresh(myCoursesProvider),
            ),
          ),
        ],
      ),
    );
  }
}

class _MyLearningListShimmer extends StatelessWidget {
  final int itemCount;

  const _MyLearningListShimmer({required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: 20),
      itemBuilder: (_, __) => const _MyLearningCardShimmer(),
    );
  }
}

class _MyLearningCardShimmer extends StatelessWidget {
  const _MyLearningCardShimmer();

  @override
  Widget build(BuildContext context) {
    final palette = AppShimmer.palette(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: AppShimmer(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: palette.placeholder,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: cardColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 110,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _line(
                        palette,
                        width: double.infinity,
                        height: 18,
                        radius: 8,
                      ),
                      const SizedBox(height: 6),
                      _line(palette, width: 170, height: 18, radius: 8),
                      const SizedBox(height: 8),
                      _line(palette, width: 130, height: 14, radius: 7),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _line(palette, width: 86, height: 12, radius: 6),
                          _line(palette, width: 30, height: 12, radius: 6),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _line(
                        palette,
                        width: double.infinity,
                        height: 8,
                        radius: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _line(
    AppShimmerPalette palette, {
    required double width,
    required double height,
    double radius = 8,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: palette.placeholder,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class _MyCourseCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback onTap;

  const _MyCourseCard({required this.course, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Enhanced Thumbnail
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Hero(
                        tag: 'course_image_${course.id}',
                        child: AppNetworkImage(
                          imageUrl: course.coverImageUrl,
                          width: 110,
                          height: 110,
                          fit: BoxFit.cover,
                          errorWidget: Container(
                            width: 110,
                            height: 110,
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.broken_image_rounded,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (course.completionPercentage >= 100)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                // Course Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF1E293B),
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        course.instructor.name,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: isDark
                              ? Colors.grey[400]
                              : const Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Progress Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                course.completionPercentage >= 100
                                    ? 'Completed'
                                    : 'Your Progress',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: course.completionPercentage >= 100
                                      ? Colors.green
                                      : AppColors.primary,
                                ),
                              ),
                              Text(
                                '${course.completionPercentage}%',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF1E293B),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: course.completionPercentage / 100,
                              backgroundColor: isDark
                                  ? Colors.grey[800]
                                  : const Color(0xFFF1F5F9),
                              color: course.completionPercentage >= 100
                                  ? Colors.green
                                  : AppColors.primary,
                              minHeight: 8,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
