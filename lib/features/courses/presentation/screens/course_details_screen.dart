import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sparkbit/core/constants/app_colors.dart';
import 'package:sparkbit/core/widgets/app_loading_indicator.dart';
import 'package:sparkbit/core/widgets/error_view.dart';
import 'package:sparkbit/features/courses/data/models/course_model.dart';
import 'package:sparkbit/features/courses/data/models/lesson_model.dart';
import 'package:sparkbit/features/courses/presentation/providers/courses_provider.dart';
import 'package:sparkbit/core/network/models/paginated_data.dart';
import 'package:sparkbit/core/constants/app_routes.dart';
import 'package:sparkbit/core/utils/snackbar_utils.dart';
import 'package:sparkbit/core/widgets/app_button.dart';
import '../../../../core/widgets/responsive/responsive_center.dart';
import '../../../cart/presentation/widgets/cart_badge_icon.dart';
import '../../../cart/presentation/widgets/add_to_cart_button.dart';

class CourseDetailsScreen extends ConsumerWidget {
  final CourseModel course;

  const CourseDetailsScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch for updates on this specific course (e.g. progress changes)
    // If null (not found in lists yet), fallback to the passed 'course' object
    final updatedCourse = ref.watch(courseByIdProvider(course.id)) ?? course;

    final lessonsAsync = ref.watch(lessonsProvider(updatedCourse.id));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: ResponsiveCenter(
          padding: EdgeInsets.zero,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 400,
                  pinned: true,
                  elevation: 0,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.surface.withOpacity(0.5),
                      child: IconButton(
                        icon: Icon(
                          Iconsax.arrow_left,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: 20,
                        ),
                        onPressed: () => context.pop(),
                      ),
                    ),
                  ),
                  actions: [CartBadgeIcon(), const SizedBox(width: 8)],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          updatedCourse.coverImageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.primary.withOpacity(0.1),
                            child: const Icon(
                              Iconsax.image,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        // Gradient Overlay
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Theme.of(
                                  context,
                                ).colorScheme.surface.withOpacity(0.8),
                                Theme.of(context).colorScheme.surface,
                              ],
                              stops: const [0.6, 0.9, 1.0],
                            ),
                          ),
                        ),
                        // Content on Image
                        Positioned(
                          bottom: 20,
                          left: 20,
                          right: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  updatedCourse.isFree
                                      ? 'Free Course'
                                      : 'Premium',
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                updatedCourse.title,
                                style: GoogleFonts.outfit(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundImage: NetworkImage(
                                      updatedCourse.instructor.imageUrl,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    updatedCourse.instructor.name,
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Icon(
                                    Iconsax.star1,
                                    size: 16,
                                    color: Colors.amber,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    updatedCourse.avgRating.toString(),
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
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
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      indicatorColor: AppColors.primary,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelColor: AppColors.primary,
                      unselectedLabelColor: Colors.grey,
                      labelStyle: GoogleFonts.outfit(
                        fontWeight: FontWeight.w600,
                      ),
                      tabs: const [
                        Tab(text: "Overview"),
                        Tab(text: "Lessons"),
                      ],
                    ),
                    backgroundColor: Theme.of(context).colorScheme.surface,
                  ),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
              children: [
                _OverviewTab(course: updatedCourse),
                _LessonsTab(
                  courseId: updatedCourse.id,
                  lessonsAsync: lessonsAsync,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _BottomEnrollBar(course: updatedCourse),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  final CourseModel course;

  const _OverviewTab({required this.course});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: 'Description'),
          const SizedBox(height: 10),
          Linkify(
            onOpen: (link) async {
              final uri = Uri.parse(link.url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            text: course.description,
            style: GoogleFonts.outfit(
              fontSize: 16,
              height: 1.6,
              color: Colors.grey[600],
            ),
            linkStyle: GoogleFonts.outfit(
              fontSize: 16,
              height: 1.6,
              color: AppColors.primary,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w600,
            ),
            options: const LinkifyOptions(humanize: false, removeWww: false),
          ),
          const SizedBox(height: 30),
          _SectionTitle(title: 'Course Stats'),
          const SizedBox(height: 16),
          Row(
            children: [
              _InfoChip(
                icon: Iconsax.book,
                label: '${course.lessonsCount} Lessons',
              ),
            ],
          ),
          const SizedBox(height: 30),
          _SectionTitle(title: 'Instructor'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(course.instructor.imageUrl),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.instructor.name,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Role/Title removed as not in API
                    ],
                  ),
                ),
                // Message button removed as not connected
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _LessonsTab extends ConsumerWidget {
  final int courseId;
  final AsyncValue<PaginatedData<LessonModel>> lessonsAsync;

  const _LessonsTab({required this.courseId, required this.lessonsAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return lessonsAsync.when(
      data: (data) {
        if (data.data.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(lessonsProvider(courseId));
              await ref.read(lessonsProvider(courseId).future);
            },
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: const [
                SizedBox(height: 200),
                Center(child: Text("No lessons yet.")),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(lessonsProvider(courseId));
            await ref.read(lessonsProvider(courseId).future);
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: data.data.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final lesson = data.data[index];
              return _LessonTile(lesson: lesson);
            },
          ),
        );
      },
      loading: () => const Center(child: AppLoadingIndicator()),
      error: (e, s) => ErrorView(
        error: e,
        onRetry: () => ref.refresh(lessonsProvider(courseId)),
      ),
    );
  }
}

class _LessonTile extends StatefulWidget {
  final LessonModel lesson;

  const _LessonTile({required this.lesson});

  @override
  State<_LessonTile> createState() => _LessonTileState();
}

class _LessonTileState extends State<_LessonTile> {
  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    final isLocked = !lesson.canAccess;
    final isCompleted = lesson.isCompleted ?? false;
    final progress = lesson.progress ?? 0.0;
    final hasProgress = !isLocked && progress > 0;

    return InkWell(
      onTap: () {
        log(
          "Tapped lesson ${lesson.id} - Locked: $isLocked, Completed: $isCompleted, Progress: $progress% , Can Access: ${lesson.canAccess}  ,Video URL: ${lesson.videoUrl}, Type: ${lesson.videoUrl != null ? "Video" : "Reading"}",
        );
        if (!isLocked) {
          context.push(AppRoutes.lessonViewer, extra: lesson);
        } else {
          AppSnackBar.showInfo(context, "Enroll to access this lesson");
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCompleted
                ? AppColors.primary.withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leading Icon/Avatar
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isLocked
                      ? Colors.grey[200]
                      : isCompleted
                      ? AppColors.primary
                      : AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isLocked
                      ? Iconsax.lock
                      : isCompleted
                      ? Iconsax.tick_circle5
                      : Iconsax.play,
                  color: isLocked
                      ? Colors.grey
                      : isCompleted
                      ? Colors.white
                      : AppColors.primary,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Lesson Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Row — with completed badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _ExpandableLessonTitle(
                          title: lesson.title,
                          isLocked: isLocked,
                        ),
                      ),
                      // Completed Badge
                      if (isCompleted)
                        Padding(
                          padding: const EdgeInsets.only(left: 8, top: 2),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Iconsax.tick_circle5,
                                  size: 12,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "Done",
                                  style: GoogleFonts.outfit(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Type and Progress Info
                  Row(
                    children: [
                      Text(
                        lesson.canAccess
                            ? (lesson.videoUrl != null)
                                  ? "Video Lesson"
                                  : "File"
                            : "Locked",
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      // Progress Percentage
                      if (hasProgress && !isCompleted) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "${progress.toStringAsFixed(0)}%",
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  // Progress Bar
                  if (hasProgress || isCompleted) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: isCompleted ? 1.0 : (progress / 100),
                        backgroundColor: Colors.grey.withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isCompleted
                              ? AppColors.primary
                              : AppColors.primary.withOpacity(0.7),
                        ),
                        minHeight: 4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Displays lesson title with up to 2 lines. If the text overflows,
/// a "Show more / Show less" toggle appears for professional long-title handling.
class _ExpandableLessonTitle extends StatefulWidget {
  final String title;
  final bool isLocked;

  const _ExpandableLessonTitle({required this.title, required this.isLocked});

  @override
  State<_ExpandableLessonTitle> createState() => _ExpandableLessonTitleState();
}

class _ExpandableLessonTitleState extends State<_ExpandableLessonTitle> {
  bool _isExpanded = false;
  bool _isOverflowing = false;

  static const int _maxLines = 2;

  TextStyle _titleStyle(BuildContext context) => GoogleFonts.outfit(
    fontWeight: FontWeight.w600,
    fontSize: 15.5,
    height: 1.35,
    color: widget.isLocked
        ? Colors.grey
        : Theme.of(context).colorScheme.onSurface,
  );

  void _checkOverflow(BuildContext context, BoxConstraints constraints) {
    final painter = TextPainter(
      text: TextSpan(text: widget.title, style: _titleStyle(context)),
      maxLines: _maxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: constraints.maxWidth);

    final overflows = painter.didExceedMaxLines;
    if (overflows != _isOverflowing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _isOverflowing = overflows);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _checkOverflow(context, constraints);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: Text(
                widget.title,
                maxLines: _isExpanded ? null : _maxLines,
                overflow: _isExpanded
                    ? TextOverflow.visible
                    : TextOverflow.ellipsis,
                style: _titleStyle(context),
              ),
            ),
            if (_isOverflowing || _isExpanded)
              GestureDetector(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _isExpanded ? 'Show less' : 'Show more',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        size: 14,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _BottomEnrollBar extends ConsumerWidget {
  final CourseModel course;

  const _BottomEnrollBar({required this.course});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If course is purchased, show "Continue Learning" button
    if (course.isPurchased) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: AppButton(
            text: 'Continue Learning',
            onPressed: () {
              DefaultTabController.of(context).animateTo(1);
            },
          ),
        ),
      );
    }

    // If course is free, show "Start Learning" button
    if (course.isFree) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: AppButton(
            text: 'Start Learning',
            onPressed: () {
              DefaultTabController.of(context).animateTo(1);
            },
          ),
        ),
      );
    }

    // If course is not purchased, show "Add to Cart" button
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Price',
                  style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  AppStrings.formatPrice(course.price),
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AddToCartButton(course: course, showFullButton: true),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  final Color backgroundColor;

  _SliverAppBarDelegate(this._tabBar, {required this.backgroundColor});

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: backgroundColor, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
