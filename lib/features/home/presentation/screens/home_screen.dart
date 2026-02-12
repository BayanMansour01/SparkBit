// ignore_for_file: unused_element
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yuna/core/constants/app_strings.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/models/user_profile.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/error_view.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../courses/data/models/category_model.dart';
import '../../../courses/data/models/course_model.dart';
import '../../../courses/presentation/providers/courses_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../providers/home_provider.dart';
import '../../../../core/widgets/responsive/responsive_center.dart';
import '../../../notifications/presentation/providers/notifications_provider.dart';
import '../../../../core/widgets/app_profile_avatar.dart';
import '../../../../core/widgets/main_screen_wrapper.dart';

/// Home screen with premium UI and animations
/// Refactored to Stateless ConsumerWidget
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch aggregated data provider
    final homeDataAsync = ref.watch(homeDataProvider);

    return homeDataAsync.when(
      data: (homeData) {
        return MainScreenWrapper(
          appBar: _buildAppBar(context, homeData.userProfile),
          onRefresh: () async {
            ref.invalidate(homeDataProvider);
            ref.invalidate(userProfileProvider);
            ref.invalidate(coursesProvider);
            ref.invalidate(categoriesProvider);
            ref.invalidate(myCoursesProvider);
            await ref.read(homeDataProvider.future);
          },
          child: _FadeSlideContent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSizes.space16),
                _buildSearchBar(context),

                // Continue Learning Section (only for logged-in users with courses)
                if (homeData.userProfile.id != -1 &&
                    homeData.myCourses.isNotEmpty) ...[
                  const SizedBox(height: AppSizes.space32),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingLg,
                    ),
                    child: _buildSectionHeader(
                      context,
                      'Continue Learning',
                      () => context.push(AppRoutes.myCourses),
                    ),
                  ),
                  const SizedBox(height: AppSizes.space16),
                  Builder(
                    builder: (context) {
                      // Find first purchased course
                      final purchasedCourse = homeData.myCourses.firstWhere(
                        (c) => c.isPurchased,
                        orElse: () => homeData.myCourses.first,
                      );

                      return _ContinueLearningSection(course: purchasedCourse);
                    },
                  ),
                ],
                const SizedBox(height: AppSizes.space32),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingLg,
                  ),
                  child: _buildSectionHeader(
                    context,
                    'Explore Categories',
                    () => context.pushNamed(AppRoutes.categoriesName),
                  ),
                ),
                const SizedBox(height: AppSizes.space16),
                _CategoryListSection(categories: homeData.categories),

                const SizedBox(height: AppSizes.space32),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingLg,
                  ),
                  child: _buildSectionHeader(
                    context,
                    'Popular Courses',
                    () => context.pushNamed('allCourses'),
                  ),
                ),
                const SizedBox(height: AppSizes.space16),
                _PopularCoursesList(courses: homeData.popularCourses),

                const SizedBox(height: AppSizes.space32),
              ],
            ),
          ),
        );
      },
      loading: () =>
          const MainScreenWrapper(child: Center(child: AppLoadingIndicator())),
      error: (err, stack) => MainScreenWrapper(
        child: ErrorView(
          error: err,
          onRetry: () {
            ref.invalidate(userProfileProvider);
            ref.invalidate(homeDataProvider);
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, UserProfile profile) {
    final isGuest = profile.id == -1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.paddingLg,
        AppSizes.space20,
        AppSizes.paddingLg,
        AppSizes.space10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isGuest ? 'Welcome!' : 'Hi, ${profile.name.split(' ').first}',
                  style: GoogleFonts.outfit(
                    fontSize: AppSizes.font4xl,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppSizes.space4),
                Text(
                  isGuest
                      ? 'Discover amazing courses today.'
                      : 'Ready to learn today?',
                  style: GoogleFonts.outfit(
                    fontSize: AppSizes.fontLg,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              if (!isGuest) ...[
                const _NotificationBell(),
                const SizedBox(width: 12),
              ],
              AppProfileAvatar(
                radius: AppSizes.avatarRadius24,
                isGuest: isGuest,
                imageUrl: profile.avatar,
                onTap: () {
                  if (isGuest) {
                    context.push(AppRoutes.signIn);
                  } else {
                    context.go(AppRoutes.profile);
                  }
                },
                showBorder: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLg),
      child: GestureDetector(
        onTap: () => context.push(AppRoutes.courses),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingLg,
            vertical: AppSizes.space16,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withOpacity(0.5)
                : Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.radiusXl),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                size: AppSizes.iconMd,
              ),
              const SizedBox(width: AppSizes.space12),
              Text(
                'What do you want to learn?',
                style: GoogleFonts.outfit(
                  fontSize: AppSizes.fontBase,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.4),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.tune_rounded,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                size: AppSizes.iconSm,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    VoidCallback onSeeAll,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: AppSizes.font2xl,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        TextButton(
          onPressed: onSeeAll,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'See All',
            style: GoogleFonts.outfit(
              fontSize: AppSizes.fontBase,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Helper for initial fade and slide
class _FadeSlideContent extends StatelessWidget {
  final Widget child;
  const _FadeSlideContent({required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      builder: (context, opacity, _) {
        return Opacity(
          opacity: opacity,
          child: TweenAnimationBuilder<Offset>(
            tween: Tween(begin: const Offset(0, 50), end: Offset.zero),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, offset, child) {
              return Transform.translate(offset: offset, child: child);
            },
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

/// Separate Stateful Widget for Categories List to handle ScrollController
class _CategoryListSection extends StatefulWidget {
  final List<CategoryModel> categories;
  const _CategoryListSection({required this.categories});

  @override
  State<_CategoryListSection> createState() => _CategoryListSectionState();
}

class _CategoryListSectionState extends State<_CategoryListSection> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // Scroll Hint Logic
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted && _scrollController.hasClients) {
          _scrollController
              .animateTo(
                50,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOutQuart,
              )
              .then((_) {
                if (mounted && _scrollController.hasClients) {
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOutQuart,
                  );
                }
              });
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categories.isEmpty) return const SizedBox();

    return SizedBox(
      height: 60, // Slightly increased to accommodate shadow
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLg),
        clipBehavior: Clip.none, // Allow shadows to paint outside bounds
        itemCount: widget.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSizes.space12),
        itemBuilder: (context, index) {
          final cat = widget.categories[index];
          return _CategoryPill(
            icon: Icons.category_rounded,
            label: cat.name,
            isSelected: false,
            onTap: () =>
                context.pushNamed(AppRoutes.subCategoriesName, extra: cat),
          );
        },
      ),
    );
  }
}

class _PopularCoursesList extends StatelessWidget {
  final List<CourseModel> courses;
  const _PopularCoursesList({required this.courses});

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return SizedBox(
        height: AppSizes.cardHeight200,
        child: Center(
          child: Text(
            'No courses found',
            style: GoogleFonts.outfit(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ),
      );
    }
    return SizedBox(
      height: 280,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingLg,
          vertical: 8,
        ), // Added vertical padding for shadow
        clipBehavior: Clip.none, // Allow shadows to paint outside bounds
        itemCount: courses.length > 5 ? 5 : courses.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSizes.space16),
        itemBuilder: (context, index) {
          final course = courses[index];
          final colors = [
            const Color(0xFF6366F1),
            const Color(0xFFEC4899),
            const Color(0xFF8B5CF6),
            const Color(0xFF10B981),
            const Color(0xFFF59E0B),
          ];
          final color = colors[index % colors.length];

          return _PopularCourseCard(
            course: course,
            color: color,
            heroTag: 'popular_course_${course.id}_$index',
            onTap: () => context.push(AppRoutes.courseDetails, extra: course),
          );
        },
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const _CategoryPill({
    required this.icon,
    required this.label,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radius2xl),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.space20,
            vertical: AppSizes.space12,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
            borderRadius: BorderRadius.circular(AppSizes.radius2xl),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : Theme.of(context).colorScheme.outline.withOpacity(0.15),
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                  spreadRadius: 2,
                )
              else
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.primary.withOpacity(0.8),
              ),
              const SizedBox(width: AppSizes.space8),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PopularCourseCard extends StatelessWidget {
  final CourseModel course;
  final String heroTag;
  final Color color;
  final VoidCallback onTap;

  const _PopularCourseCard({
    required this.course,
    required this.heroTag,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: isDark
            ? Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withOpacity(0.3)
            : Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.outline.withOpacity(isDark ? 0.1 : 0.05),
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Stack(
              children: [
                Hero(
                  tag: heroTag,
                  child: Container(
                    height: 135,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppSizes.radiusXl),
                      ),
                      color: AppColors.primary.withOpacity(0.05),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppSizes.radiusXl),
                      ),
                      child: course.coverImageUrl.isNotEmpty
                          ? Image.network(
                              course.coverImageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _buildPlaceholder(),
                            )
                          : _buildPlaceholder(),
                    ),
                  ),
                ),
                // Rating Badge - Enhanced Glassmorphic
                Positioned(
                  top: 10,
                  right: 10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.35),
                              Colors.black.withOpacity(0.25),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFFFC107),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              course.avgRating.toStringAsFixed(1),
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(AppSizes.paddingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Instructor Name
                  Text(
                    course.instructor.name,
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Title
                  Text(
                    course.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 15, // Consistent with ContinueLearning
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Footer: Author/Lessons & Price/Progress
                  if (course.isPurchased)
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: course.completionPercentage / 100,
                              backgroundColor: Theme.of(
                                context,
                              ).disabledColor.withOpacity(0.1),
                              color: AppColors.primary,
                              minHeight: 4,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${course.completionPercentage}%',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.play_circle_outline_rounded,
                              size: 14,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${course.lessonsCount} Lessons',
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          course.price == '0' ||
                                  course.price == '0.00' ||
                                  course.isFree
                              ? 'Free'
                              : AppStrings.formatPrice(course.price),
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
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
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, color.withOpacity(0.8)],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.image_not_supported_rounded,
          color: Colors.white.withOpacity(0.5),
          size: 40,
        ),
      ),
    );
  }
}

class _ContinueLearningSection extends StatelessWidget {
  final CourseModel course;

  const _ContinueLearningSection({required this.course});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLg),
      decoration: BoxDecoration(
        color: isDark
            ? Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withOpacity(0.3)
            : Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        border: Border.all(
          color: isDark
              ? AppColors.primary.withOpacity(0.15)
              : AppColors.primary.withOpacity(0.1),
          width: 1.2,
        ),
        boxShadow: [
          // Subtle golden glow shadow
          BoxShadow(
            color: AppColors.primary.withOpacity(isDark ? 0.08 : 0.12),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
          // Subtle dark shadow for depth
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push(AppRoutes.courseDetails, extra: course),
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingMd),
            child: Row(
              children: [
                // Course Thumbnail
                Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withOpacity(0.05),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    child: course.coverImageUrl.isNotEmpty
                        ? Image.network(
                            course.coverImageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(
                                  Icons.image_not_supported_rounded,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.2),
                                  size: 24,
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Icon(
                              Icons.play_circle_fill_rounded,
                              color: AppColors.primary.withOpacity(0.5),
                              size: 32,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: AppSizes.space16),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'BY ${course.instructor.name.toUpperCase()}',
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                              color: AppColors.primary,
                            ),
                          ),
                          // Optional: Percentage text here or below
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        course.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Progress Section - Replaced with info text
                      Row(
                        children: [
                          Icon(
                            Icons.play_circle_outline_rounded,
                            size: 14,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.5),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${course.lessonsCount} Lessons',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Circular Progress Indicator
                SizedBox(
                  width: 56,
                  height: 56,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: course.completionPercentage / 100,
                        backgroundColor: const Color(
                          0xFFFFC107,
                        ).withOpacity(0.15),
                        color: const Color(0xFFFFC107),
                        strokeWidth: 5,
                      ),
                      Center(
                        child: Text(
                          '${course.completionPercentage}%',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
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

class _NotificationBell extends ConsumerStatefulWidget {
  const _NotificationBell();

  @override
  ConsumerState<_NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends ConsumerState<_NotificationBell> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final unreadCountAsync = ref.watch(unreadNotificationsCountProvider);

    return InkWell(
      onTap: () {
        context.push(AppRoutes.notifications).then((_) {
          // Refetch unread count when returning from notifications screen
          ref.invalidate(unreadNotificationsCountProvider);
        });
      },
      borderRadius: BorderRadius.circular(50),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              Icons.notifications_none_rounded,
              size: 28,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            if (unreadCountAsync.valueOrNull != null &&
                unreadCountAsync.value! > 0)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      width: 1.5,
                    ),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Center(
                    child: Text(
                      unreadCountAsync.value! > 9
                          ? '9+'
                          : unreadCountAsync.value.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Welcome screen shown to guest users
class _GuestWelcomeScreen extends StatelessWidget {
  const _GuestWelcomeScreen();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ResponsiveCenter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingXl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    size: 80,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 32),

                // Title
                Text(
                  'Welcome to Yuna',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),

                // Subtitle
                Text(
                  'Sign in to access your personalized learning experience',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 48),

                // Sign In Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.pushNamed(AppRoutes.signInName),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: AppColors.primary.withOpacity(0.4),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.login_rounded, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          'Sign In',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Features List
                const SizedBox(height: 32),
                Text(
                  'What you\'ll get:',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 16),
                const _FeatureItem(
                  icon: Icons.school,
                  text: 'Access to courses',
                ),
                const SizedBox(height: 12),
                const _FeatureItem(
                  icon: Icons.track_changes,
                  text: 'Track your progress',
                ),
                const SizedBox(height: 12),
                const _FeatureItem(
                  icon: Icons.stars,
                  text: 'Earn certificates',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: GoogleFonts.outfit(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}
