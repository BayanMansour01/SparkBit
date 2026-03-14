// ignore_for_file: unused_element
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sparkbit/core/constants/app_strings.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/models/user_profile.dart';
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
import '../../../../core/widgets/app_network_image.dart';
import '../../../cart/presentation/providers/cart_provider.dart';

bool _isSmallPhone(BuildContext context) =>
    MediaQuery.sizeOf(context).width < 360;
bool _isTablet(BuildContext context) => MediaQuery.sizeOf(context).width >= 768;

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
            ref.invalidate(homePopularCoursesProvider);
            ref.invalidate(homeCategoriesProvider);
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
                      () => context.go(AppRoutes.myCourses),
                    ),
                  ),
                  const SizedBox(height: AppSizes.space16),
                  Builder(
                    builder: (context) {
                      // Find course with highest progress (completion percentage)
                      // If multiple courses have same progress, pick the newest (highest ID)
                      final purchasedCourses = homeData.myCourses
                          .where((c) => c.isPurchased)
                          .toList();

                      if (purchasedCourses.isEmpty) {
                        // Fallback to first course if no purchased courses
                        return _ContinueLearningSection(
                          course: homeData.myCourses.first,
                        );
                      }

                      // Sort by completion percentage (descending), then by ID (descending)
                      purchasedCourses.sort((a, b) {
                        final progressComparison = b.completionPercentage
                            .compareTo(a.completionPercentage);
                        if (progressComparison != 0) {
                          return progressComparison; // Higher progress first
                        }
                        return b.id.compareTo(a.id); // Newer (higher ID) first
                      });

                      return _ContinueLearningSection(
                        course: purchasedCourses.first,
                      );
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
      loading: () => const MainScreenWrapper(
        useScroll: false,
        child: _HomeScreenSkeleton(),
      ),
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
    final isSmall = _isSmallPhone(context);
    final isTablet = _isTablet(context);
    final titleSize = isTablet
        ? AppSizes.font4xl + 4
        : (isSmall ? AppSizes.font3xl : AppSizes.font4xl);
    final subtitleSize = isSmall ? AppSizes.fontSm : AppSizes.fontLg;
    final actionSpacing = isSmall ? 8.0 : 12.0;

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
                    fontSize: titleSize,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSizes.space4),
                Text(
                  isGuest
                      ? 'Discover amazing courses today.'
                      : 'Ready to learn today?',
                  style: GoogleFonts.outfit(
                    fontSize: subtitleSize,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Row(
            children: [
              if (!isGuest) ...[
                const _NotificationBell(),
                SizedBox(width: actionSpacing),
              ],
              // Cart Icon with Badge
              _CartIconWithBadge(context: context),
              SizedBox(width: actionSpacing),
              AppProfileAvatar(
                radius: isSmall ? 20 : AppSizes.avatarRadius24,
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
              Expanded(
                child: Text(
                  'What do you want to learn?',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: AppSizes.fontBase,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.4),
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.space8),
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
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: AppSizes.font2xl,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(width: 12),
        TextButton(
          onPressed: onSeeAll,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            minimumSize: const Size(56, 44),
            tapTargetSize: MaterialTapTargetSize.padded,
            backgroundColor: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withOpacity(0.55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.18),
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'See All',
                style: GoogleFonts.outfit(
                  fontSize: AppSizes.fontBase,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 16,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HomeIconButtonShell extends StatelessWidget {
  final Widget child;

  const _HomeIconButtonShell({required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDark
            ? Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withOpacity(0.75)
            : Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _HomeScreenSkeleton extends StatelessWidget {
  const _HomeScreenSkeleton();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isSmall = width < 360;
        final isTablet = width >= 768;
        final popularCardWidth = isTablet
            ? 320.0
            : (isSmall ? (width - 72).clamp(220.0, 255.0) : 270.0);
        final popularCardHeight = isTablet ? 320.0 : (isSmall ? 276.0 : 295.0);

        return Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppSizes.paddingLg,
              AppSizes.space20,
              AppSizes.paddingLg,
              AppSizes.space32,
            ),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _box(
                          height: isSmall ? 26 : 30,
                          width: isSmall ? 150 : 190,
                        ),
                        const SizedBox(height: 8),
                        _box(height: 14, width: isSmall ? 110 : 150),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  _circle(isSmall ? 38 : 42),
                  const SizedBox(width: 10),
                  _circle(isSmall ? 38 : 42),
                ],
              ),

              const SizedBox(height: 18),
              _card(height: 56, width: double.infinity, radius: 16),

              const SizedBox(height: 28),
              _sectionHeader(),
              const SizedBox(height: 14),
              SizedBox(
                height: 60,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, index) {
                    final widths = isSmall
                        ? [88.0, 96.0, 82.0, 104.0]
                        : [110.0, 122.0, 98.0, 128.0];
                    return _card(
                      height: 60,
                      width: widths[index % widths.length],
                      radius: 999,
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),
              _sectionHeader(),
              const SizedBox(height: 14),
              SizedBox(
                height: popularCardHeight,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 2,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (_, __) => _popularCardSkeleton(
                    width: popularCardWidth,
                    height: popularCardHeight,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _sectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_box(height: 24, width: 170), _box(height: 16, width: 56)],
    );
  }

  static Widget _popularCardSkeleton({
    required double width,
    required double height,
  }) {
    final imageHeight = height * 0.46;

    return _card(
      height: height,
      width: width,
      radius: AppSizes.radiusXl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _box(
            height: imageHeight,
            width: double.infinity,
            radius: AppSizes.radiusXl,
            onlyTopCorners: true,
          ),
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _box(height: 10, width: 90),
                const SizedBox(height: 10),
                _box(height: 14, width: 210),
                const SizedBox(height: 8),
                _box(height: 14, width: 160),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _box(height: 12, width: 58),
                    const Spacer(),
                    _box(height: 20, width: 64, radius: 10),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _circle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }

  static Widget _card({
    required double height,
    required double width,
    required double radius,
    Widget? child,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    );
  }

  static Widget _box({
    required double height,
    required double width,
    double radius = 12,
    bool onlyTopCorners = false,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: onlyTopCorners
            ? const BorderRadius.vertical(
                top: Radius.circular(AppSizes.radiusXl),
              )
            : BorderRadius.circular(radius),
      ),
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
    final width = MediaQuery.sizeOf(context).width;
    final isSmall = width < 360;
    final pillHeight = isSmall ? 52.0 : 60.0;

    return SizedBox(
      height: pillHeight,
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isSmall = width < 360;
        final isTablet = width >= 768;
        final horizontalPadding = isTablet
            ? AppSizes.paddingLg + 8
            : AppSizes.paddingLg;
        final cardWidth = isTablet
            ? 320.0
            : (isSmall ? (width - 72).clamp(220.0, 255.0) : 270.0);
        final cardHeight = isTablet ? 320.0 : (isSmall ? 276.0 : 295.0);

        return SizedBox(
          height: cardHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 8,
            ),
            clipBehavior: Clip.none,
            itemCount: courses.length > 5 ? 5 : courses.length,
            separatorBuilder: (_, __) =>
                const SizedBox(width: AppSizes.space16),
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
                width: cardWidth,
                cardHeight: cardHeight,
                onTap: () =>
                    context.push(AppRoutes.courseDetails, extra: course),
              );
            },
          ),
        );
      },
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
    final width = MediaQuery.sizeOf(context).width;
    final isSmall = width < 360;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radius2xl),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(
            horizontal: isSmall ? 14 : AppSizes.space20,
            vertical: isSmall ? AppSizes.space10 : AppSizes.space12,
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: isSmall ? 13 : 14,
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
  final double width;
  final double cardHeight;
  final VoidCallback onTap;

  const _PopularCourseCard({
    required this.course,
    required this.heroTag,
    required this.color,
    required this.width,
    required this.cardHeight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final imageHeight = cardHeight * 0.46;

    return Container(
      width: width,
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
                    height: imageHeight,
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
                          ? AppNetworkImage(
                              imageUrl: course.coverImageUrl,
                              fit: BoxFit.cover,
                              errorWidget: _buildPlaceholder(),
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
                      fontSize: 15.5,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                      height: 1.3,
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
    final width = MediaQuery.sizeOf(context).width;
    final isSmall = width < 360;
    final isTablet = width >= 768;
    final thumbSize = isTablet ? 82.0 : (isSmall ? 64.0 : 74.0);
    final progressSize = isTablet ? 62.0 : (isSmall ? 50.0 : 56.0);
    final titleSize = isSmall ? 14.5 : 16.0;
    final bylineSize = isSmall ? 9.0 : 10.0;

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
                  width: thumbSize,
                  height: thumbSize,
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
                        ? AppNetworkImage(
                            imageUrl: course.coverImageUrl,
                            fit: BoxFit.cover,
                            errorWidget: Center(
                              child: Icon(
                                Icons.image_not_supported_rounded,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.2),
                                size: 24,
                              ),
                            ),
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
                          Expanded(
                            child: Text(
                              'BY ${course.instructor.name.toUpperCase()}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                fontSize: bylineSize,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          // Optional: Percentage text here or below
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        course.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: titleSize,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                          height: 1.3,
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
                  width: progressSize,
                  height: progressSize,
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

    debugPrint(
      '🔔 Notification bell - hasValue: ${unreadCountAsync.hasValue}, '
      'hasError: ${unreadCountAsync.hasError}, '
      'isLoading: ${unreadCountAsync.isLoading}, '
      'valueOrNull: ${unreadCountAsync.valueOrNull}',
    );

    return InkWell(
      onTap: () {
        context.push(AppRoutes.notifications).then((_) {
          // Refetch unread count when returning from notifications screen
          ref.invalidate(unreadNotificationsCountProvider);
        });
      },
      borderRadius: BorderRadius.circular(14),
      child: _HomeIconButtonShell(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              Icons.notifications_none_rounded,
              size: 22,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            // Show error indicator if there's an error (for debugging)
            if (unreadCountAsync.hasError)
              Positioned(
                top: -1,
                right: -1,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      width: 1.5,
                    ),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.error_outline,
                      color: Colors.white,
                      size: 8,
                    ),
                  ),
                ),
              ),
            // Show the actual badge if we have data
            if (unreadCountAsync.valueOrNull != null &&
                unreadCountAsync.value! > 0)
              Positioned(
                top: -1,
                right: -1,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      width: 1.5,
                    ),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: Center(
                    child: Text(
                      unreadCountAsync.value! > 9
                          ? '9+'
                          : unreadCountAsync.value.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
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
    final width = MediaQuery.sizeOf(context).width;
    final isSmall = width < 360;

    return SafeArea(
      child: ResponsiveCenter(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(
                isSmall ? AppSizes.paddingLg : AppSizes.paddingXl,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      constraints.maxHeight -
                      (isSmall
                          ? AppSizes.paddingLg * 2
                          : AppSizes.paddingXl * 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon
                    Container(
                      padding: EdgeInsets.all(isSmall ? 24 : 32),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.school_rounded,
                        size: isSmall ? 64 : 80,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: isSmall ? 24 : 32),

                    // Title
                    Text(
                      'Welcome to Yuna',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: isSmall ? 26 : 32,
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
                        fontSize: isSmall ? 14 : 16,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    SizedBox(height: isSmall ? 32 : 48),

                    // Sign In Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () =>
                            context.pushNamed(AppRoutes.signInName),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shadowColor: AppColors.primary.withOpacity(0.4),
                          padding: EdgeInsets.symmetric(
                            vertical: isSmall ? 14 : 18,
                          ),
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
                                fontSize: isSmall ? 15 : 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Features List
                    SizedBox(height: isSmall ? 24 : 32),
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
            );
          },
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

/// Cart Icon with Badge showing item count
class _CartIconWithBadge extends ConsumerWidget {
  final BuildContext context;

  const _CartIconWithBadge({required this.context});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItemCount = ref.watch(cartItemCountProvider);

    return InkWell(
      onTap: () {
        context.push(AppRoutes.cartPath);
      },
      borderRadius: BorderRadius.circular(14),
      child: _HomeIconButtonShell(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 22,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            // Show badge only if there are items in cart
            if (cartItemCount > 0)
              Positioned(
                top: -1,
                right: -1,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      width: 1.5,
                    ),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: Center(
                    child: Text(
                      cartItemCount > 99 ? '99+' : cartItemCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
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
