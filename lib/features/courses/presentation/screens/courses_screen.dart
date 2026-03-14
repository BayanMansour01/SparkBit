import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sparkbit/core/constants/app_strings.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/shimmers/course_list_shimmer.dart';
import 'package:go_router/go_router.dart';
import 'package:sparkbit/core/constants/app_routes.dart';
import 'package:sparkbit/features/courses/data/models/course_model.dart';
import 'package:sparkbit/features/courses/presentation/providers/courses_provider.dart';
import '../../../../core/widgets/main_screen_wrapper.dart';
import '../../../../core/widgets/app_network_image.dart';

/// Courses screen with filtering and search
class CoursesScreen extends ConsumerWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Reset subCategory when category changes
    ref.listen<int?>(selectedCategoryIdProvider, (previous, next) {
      if (previous != next) {
        ref.read(selectedSubCategoryIdProvider.notifier).state = null;
      }
    });

    return MainScreenWrapper(
      appBar: Column(
        children: [
          _buildAppBar(context),
          _buildSearchBar(context, ref),
          _buildCategoryTabs(context, ref),
          _buildSubCategoryList(context, ref),
        ],
      ),
      useScroll: false, // We use a list inside expanded
      child: Column(
        children: [
          Expanded(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(opacity: value, child: child);
              },
              child: _buildCoursesList(context, ref),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingLg,
        vertical: AppSizes.space10,
      ),
      child: Row(
        children: [
          // Back Button
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            iconSize: 20,
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(AppRoutes.home);
              }
            },
            color: Theme.of(context).colorScheme.onSurface,
          ),
          const SizedBox(width: AppSizes.space8),

          Text(
            'Explore Courses',
            style: GoogleFonts.outfit(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLg),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.space16,
          vertical: AppSizes.space4,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search_rounded,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              size: AppSizes.iconLg,
            ),
            const SizedBox(width: AppSizes.space12),
            Expanded(
              child: TextField(
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).state = value;
                },
                decoration: InputDecoration(
                  hintText: 'Search courses...',
                  hintStyle: GoogleFonts.outfit(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.5),
                  ),
                  border: InputBorder.none,
                ),
                style: GoogleFonts.outfit(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTabs(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategoryId = ref.watch(selectedCategoryIdProvider);
    final isSmall = MediaQuery.sizeOf(context).width < 360;
    final tabHeight = isSmall ? 40.0 : 45.0;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSizes.space20),
      height: tabHeight,
      child: categoriesAsync.when(
        data: (paginatedData) {
          final categories = paginatedData.data;
          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels >=
                      notification.metrics.maxScrollExtent &&
                  !ref.read(categoriesProvider.notifier).isLoadingMore) {
                ref.read(categoriesProvider.notifier).loadNextPage();
              }
              return false;
            },
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingLg,
              ),
              itemCount: categories.length + 1,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppSizes.space12),
              itemBuilder: (context, index) {
                if (index == 0) {
                  final isSelected = selectedCategoryId == null;
                  return _buildTabItem(context, 'All', isSelected, () {
                    ref.read(selectedCategoryIdProvider.notifier).state = null;
                  });
                }
                final category = categories[index - 1];
                final isSelected = selectedCategoryId == category.id;
                return _buildTabItem(context, category.name, isSelected, () {
                  ref.read(selectedCategoryIdProvider.notifier).state =
                      category.id;
                });
              },
            ),
          );
        },
        loading: () => const _ChipRowSkeleton(height: 45, itemCount: 4),
        error: (err, stack) => ErrorView(
          error: err,
          onRetry: () => ref.refresh(categoriesProvider),
        ),
      ),
    );
  }

  Widget _buildSubCategoryList(BuildContext context, WidgetRef ref) {
    final selectedCategoryId = ref.watch(selectedCategoryIdProvider);
    if (selectedCategoryId == null) return const SizedBox.shrink();

    final subCategoriesAsync = ref.watch(subCategoriesProvider);
    final selectedSubCategoryId = ref.watch(selectedSubCategoryIdProvider);
    final isSmall = MediaQuery.sizeOf(context).width < 360;

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      child: Container(
        height: isSmall ? 44 : 50,
        margin: const EdgeInsets.only(bottom: AppSizes.paddingLg),
        child: subCategoriesAsync.when(
          data: (paginatedData) {
            final subCategories = paginatedData.data;
            if (subCategories.isEmpty) return const SizedBox.shrink();

            return ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingLg,
              ),
              itemCount: subCategories.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppSizes.space8),
              itemBuilder: (context, index) {
                final subCategory = subCategories[index];
                final isSelected = selectedSubCategoryId == subCategory.id;

                return ChoiceChip(
                  label: Text(
                    subCategory.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: isSmall ? AppSizes.fontXs : AppSizes.fontSm,
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurface,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    ref.read(selectedSubCategoryIdProvider.notifier).state =
                        selected ? subCategory.id : null;
                  },
                  selectedColor: AppColors.primary,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: isSmall
                      ? const VisualDensity(horizontal: -2, vertical: -2)
                      : VisualDensity.standard,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  ),
                );
              },
            );
          },
          loading: () => const _ChipRowSkeleton(height: 42, itemCount: 5),
          error: (err, stack) => const SizedBox.shrink(),
        ),
      ),
    );
  }

  Widget _buildTabItem(
    BuildContext context,
    String title,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final isSmall = MediaQuery.sizeOf(context).width < 360;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(
          horizontal: isSmall ? 14 : AppSizes.space20,
          vertical: isSmall ? AppSizes.space10 : AppSizes.space12,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSizes.radius2xl),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            fontSize: isSmall ? AppSizes.fontSm : AppSizes.fontBase,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildCoursesList(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(coursesProvider);

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels >=
                notification.metrics.maxScrollExtent &&
            !ref.read(coursesProvider.notifier).isLoadingMore) {
          ref.read(coursesProvider.notifier).loadNextPage();
        }
        return false;
      },
      child: coursesAsync.when(
        data: (paginatedData) {
          final courses = paginatedData.data;

          if (courses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off_rounded,
                    size: 60,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.3),
                  ),
                  const SizedBox(height: AppSizes.space16),
                  Text(
                    'No courses found',
                    style: GoogleFonts.outfit(
                      fontSize: AppSizes.fontLg,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.fromLTRB(
              AppSizes.paddingLg,
              0,
              AppSizes.paddingLg,
              AppSizes.space100,
            ),
            itemCount:
                courses.length +
                (ref.read(coursesProvider.notifier).hasMore ? 1 : 0),
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppSizes.space16),
            itemBuilder: (context, index) {
              if (index == courses.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: AppLoadingIndicator(size: 24),
                  ),
                );
              }
              final course = courses[index];
              return _CourseCard(
                course: course,
                index: index,
                onTap: () =>
                    context.push(AppRoutes.courseDetails, extra: course),
              );
            },
          );
        },
        loading: () => const CourseListShimmer(),
        error: (err, stack) => ErrorView(
          error: err,
          onRetry: () => ref.invalidate(coursesProvider),
        ),
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final CourseModel course;
  final int index;
  final VoidCallback onTap;

  const _CourseCard({
    required this.course,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFF3776AB),
      const Color(0xFFF0DB4F),
      Colors.purple,
      Colors.teal,
      Colors.orange,
      Colors.pink,
      const Color(0xFF61DAFB),
      Colors.green,
    ];
    final imageColor = colors[index % colors.length];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.space16),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
            borderRadius: BorderRadius.circular(AppSizes.radiusXl),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
            ),
          ),
          child: Row(
            children: [
              // Course Thumbnail
              Hero(
                tag: 'course_image_${course.id}_courses_screen_$index',
                child: Container(
                  width: 78,
                  height: 78,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [imageColor, imageColor.withOpacity(0.7)],
                    ),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: course.coverImageUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusMd,
                          ),
                          child: AppNetworkImage(
                            imageUrl: course.coverImageUrl,
                            fit: BoxFit.cover,
                            errorWidget: const Icon(
                              Icons.broken_image_rounded,
                              color: Colors.white,
                              size: AppSizes.iconLg,
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.play_circle_outline_rounded,
                          color: Colors.white,
                          size: AppSizes.iconXl * 1.5,
                        ),
                ),
              ),
              const SizedBox(width: AppSizes.space12),

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
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: AppSizes.space6),
                    Text(
                      course.instructor.name,
                      style: GoogleFonts.outfit(
                        fontSize: AppSizes.fontSm,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: AppSizes.space6),
                    // Rating & Lessons row
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: AppSizes.iconSm,
                          color: Color(0xFFFFC107),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          course.avgRating.toString(),
                          style: GoogleFonts.outfit(
                            fontSize: AppSizes.fontXs,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.play_circle_outline_rounded,
                          size: AppSizes.iconSm,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${course.lessonsCount} Lessons',
                          style: GoogleFonts.outfit(
                            fontSize: AppSizes.fontXs,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.space6),
                    // Price / Progress row — separate line for more title space
                    if (course.isPurchased)
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: LinearProgressIndicator(
                                value: course.completionPercentage / 100,
                                backgroundColor: AppColors.primary.withOpacity(
                                  0.15,
                                ),
                                color: AppColors.primary,
                                minHeight: 5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${course.completionPercentage}%',
                            style: GoogleFonts.outfit(
                              fontSize: AppSizes.fontXs,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      )
                    else
                      Text(
                        course.isFree
                            ? 'Free'
                            : AppStrings.formatPrice(course.price),
                        style: GoogleFonts.outfit(
                          fontSize: AppSizes.fontBase,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChipRowSkeleton extends StatelessWidget {
  final double height;
  final int itemCount;

  const _ChipRowSkeleton({required this.height, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLg),
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(width: AppSizes.space8),
        itemBuilder: (context, index) {
          final widths = [72.0, 92.0, 110.0, 88.0, 96.0];
          return Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              width: widths[index % widths.length],
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.radius2xl),
              ),
            ),
          );
        },
      ),
    );
  }
}
