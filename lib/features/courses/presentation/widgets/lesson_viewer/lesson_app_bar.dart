import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:sparkbit/core/constants/app_colors.dart';
import 'package:sparkbit/features/courses/data/models/lesson_model.dart';
import 'package:sparkbit/features/courses/presentation/providers/lesson_view_provider.dart';
import 'package:sparkbit/features/courses/presentation/providers/courses_provider.dart';
import 'package:sparkbit/features/courses/presentation/widgets/review_dialog.dart';
import 'package:sparkbit/features/home/presentation/providers/home_provider.dart';

class LessonAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final LessonModel lesson;

  const LessonAppBar({super.key, required this.lesson});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch state for updates
    final viewState = ref.watch(lessonViewProvider(lesson));
    final controller = ref.read(lessonViewProvider(lesson).notifier);

    return AppBar(
      title: Text(
        'Lesson Viewer',
        style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      bottom: null,
      leading: IconButton(
        icon: const Icon(Icons.close_rounded),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.star_rate_rounded, color: Colors.amber),
          tooltip: 'Rate Lesson',
          onPressed: () async {
            final result = await showDialog<int>(
              context: context,
              builder: (context) =>
                  ReviewDialog(lessonId: lesson.id.toString()),
            );
            if (result != null) {
              // 1. Optimistic update: update lesson rating locally
              ref
                  .read(lessonsProvider(lesson.courseId).notifier)
                  .updateLessonRating(lesson.id, result.toDouble());

              // 2. Refresh all relevant API data in background
              ref.read(lessonsProvider(lesson.courseId).notifier).refreshData();
              ref.read(coursesProvider.notifier).refreshData();
              ref.read(myCoursesProvider.notifier).refreshData();
              ref.invalidate(homeDataProvider);
              ref.invalidate(homePopularCoursesProvider);
            }
          },
        ),
        // File Only: Show Completion Button
        if (!lesson.hasVideo && !viewState.isMarkedComplete)
          TextButton.icon(
            onPressed: () => controller.markAsComplete(lesson),
            icon: const Icon(
              Icons.check_circle_outline,
              color: AppColors.primary,
            ),
            label: Text(
              "Mark Complete",
              style: GoogleFonts.outfit(color: AppColors.primary),
            ),
          ),

        // Show status if completed
        if (viewState.isMarkedComplete && !lesson.hasVideo)
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.check_circle, color: AppColors.primary),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 4);
}
