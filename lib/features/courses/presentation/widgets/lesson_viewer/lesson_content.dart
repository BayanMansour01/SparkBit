import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yuna/core/constants/app_colors.dart';
import 'package:yuna/core/constants/app_sizes.dart';
import 'package:yuna/core/utils/snackbar_utils.dart';
import 'package:yuna/core/widgets/responsive/responsive_center.dart';
import 'package:yuna/features/courses/presentation/providers/lesson_view_provider.dart';
import 'package:yuna/features/courses/data/models/lesson_model.dart';

class LessonContent extends ConsumerWidget {
  final LessonModel lesson;

  const LessonContent({super.key, required this.lesson});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(lessonViewProvider(lesson).notifier);

    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        child: ResponsiveCenter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    ),
                    child: Text(
                      'Lesson ${lesson.order}',
                      style: GoogleFonts.outfit(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: AppSizes.fontXs,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Completion Status Badge
                  if (lesson.isCompleted == true)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            color: Colors.green,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Completed',
                            style: GoogleFonts.outfit(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: AppSizes.fontXs,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),
                  // Rating Display
                  if (lesson.avgRating != null && lesson.avgRating! > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            lesson.avgRating!.toStringAsFixed(1),
                            style: GoogleFonts.outfit(
                              color: Colors.amber.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: AppSizes.fontXs,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(width: 8),
                  // Menu Button
                  Theme(
                    data: Theme.of(context).copyWith(
                      cardColor: Theme.of(context).colorScheme.surface,
                    ),
                    child: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert_rounded),
                      onSelected: (value) {
                        if (value == 'incomplete') {
                          controller.markAsIncomplete(lesson);
                          AppSnackBar.showInfo(
                            context,
                            'Lesson marked as incomplete',
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'incomplete',
                              child: Row(
                                children: [
                                  Icon(Icons.undo_rounded, size: 20),
                                  SizedBox(width: 8),
                                  Text('Mark as Incomplete'),
                                ],
                              ),
                            ),
                          ],
                    ),
                  ),
                ],
              ),

              // Progress Bar
              const SizedBox(height: AppSizes.space12),
              Text(
                lesson.title,
                style: GoogleFonts.outfit(
                  fontSize: AppSizes.font2xl,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSizes.space24),
              _buildSectionHeader('Description'),
              const SizedBox(height: AppSizes.space12),
              Text(
                'This lesson covers the fundamental concepts of the topic. Ensure you have the materials ready for the practical part.',
                style: GoogleFonts.outfit(
                  fontSize: AppSizes.fontBase,
                  height: 1.6,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: AppSizes.space32),
              if (lesson.attachmentPath != null) ...[
                _buildSectionHeader('Resources'),
                const SizedBox(height: AppSizes.space16),
                _buildResourceTile(
                  context,
                  ref, // Pass ref here
                  lesson.attachmentPath!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: AppSizes.fontLg,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildResourceTile(BuildContext context, WidgetRef ref, String url) {
    // Accept ref here
    final String fileName = url.split('/').last.split('?').first;
    final controller = ref.read(lessonViewProvider(lesson).notifier);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.space16),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
            borderRadius: BorderRadius.circular(AppSizes.radiusXl),
          ),
          child: Row(
            children: [
              const Icon(Icons.picture_as_pdf_rounded, color: Colors.redAccent),
              const SizedBox(width: AppSizes.space16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName.isNotEmpty ? fileName : 'Attachment',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Download Resource',
                      style: GoogleFonts.outfit(
                        fontSize: AppSizes.fontXs,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.download_rounded,
                  color: AppColors.primary,
                ),
                onPressed: () {
                  if (!lesson.hasVideo) {
                    // Only mark as complete on download if it's NOT a video lesson
                    controller.markAsComplete(lesson);
                    AppSnackBar.showSuccess(
                      context,
                      'Resource downloaded & Lesson marked as complete',
                    );
                  } else {
                    // Just show a normal message if it's a video lesson
                    AppSnackBar.showInfo(context, 'Downloading resource...');
                  }
                },
              ),
            ],
          ),
        ),
        if (!lesson.hasVideo && lesson.isCompleted != true) ...[
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                controller.markAsComplete(lesson);
                AppSnackBar.showSuccess(context, 'Lesson marked as complete');
              },
              icon: const Icon(Icons.check_circle_outline_rounded),
              label: const Text('Complete Lesson'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
