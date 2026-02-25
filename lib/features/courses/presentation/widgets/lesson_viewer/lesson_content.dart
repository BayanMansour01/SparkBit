import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparkbit/core/constants/app_colors.dart';
import 'package:sparkbit/core/constants/app_sizes.dart';
import 'package:sparkbit/core/di/service_locator.dart';
import 'package:sparkbit/core/services/file_download_service.dart';
import 'package:sparkbit/core/utils/snackbar_utils.dart';
import 'package:sparkbit/core/widgets/responsive/responsive_center.dart';
import 'package:sparkbit/features/courses/presentation/providers/lesson_view_provider.dart';
import 'package:sparkbit/features/courses/data/models/lesson_model.dart';
import 'package:dio/dio.dart';

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
                      color: AppColors.primary.withValues(alpha: 0.1),
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
                        color: Colors.green.withValues(alpha: 0.1),
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
                        color: Colors.amber.withValues(alpha: 0.1),
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
                  // Theme(
                  //   data: Theme.of(context).copyWith(
                  //     cardColor: Theme.of(context).colorScheme.surface,
                  //   ),
                  //   child: PopupMenuButton<String>(
                  //     icon: const Icon(Icons.more_vert_rounded),
                  //     onSelected: (value) {
                  //       if (value == 'incomplete') {
                  //         controller.markAsIncomplete(lesson);
                  //         AppSnackBar.showInfo(
                  //           context,
                  //           'Lesson marked as incomplete',
                  //         );
                  //       }
                  //     },
                  //     itemBuilder: (BuildContext context) =>
                  //         <PopupMenuEntry<String>>[
                  //           const PopupMenuItem<String>(
                  //             value: 'incomplete',
                  //             child: Row(
                  //               children: [
                  //                 Icon(Icons.undo_rounded, size: 20),
                  //                 SizedBox(width: 8),
                  //                 Text('Mark as Incomplete'),
                  //               ],
                  //             ),
                  //           ),
                  //         ],
                  //   ),
                  // ),
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

              // Fake description removed as per user request to show only real data
              if (lesson.attachmentPath != null) ...[
                _buildSectionHeader('Resources'),
                const SizedBox(height: AppSizes.space16),
                _ResourceDownloadTile(
                  lesson: lesson,
                  url: lesson.attachmentPath!,
                ),
              ],
              const SizedBox(height: AppSizes.paddingXl),
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
    return const SizedBox.shrink(); // Replaced by _ResourceDownloadTile
  }
}

/// Stateful widget that handles actual file download with progress
class _ResourceDownloadTile extends ConsumerStatefulWidget {
  final LessonModel lesson;
  final String url;

  const _ResourceDownloadTile({required this.lesson, required this.url});

  @override
  ConsumerState<_ResourceDownloadTile> createState() =>
      _ResourceDownloadTileState();
}

class _ResourceDownloadTileState extends ConsumerState<_ResourceDownloadTile> {
  bool _isDownloading = false;
  double _progress = 0.0;
  bool _isDownloaded = false;
  String? _localPath;
  String? _error;

  late final FileDownloadService _downloadService;

  @override
  void initState() {
    super.initState();
    _downloadService = FileDownloadService(getIt<Dio>());
  }

  Future<void> _startDownload() async {
    if (_isDownloading) return;

    setState(() {
      _isDownloading = true;
      _progress = 0.0;
      _error = null;
    });

    try {
      final path = await _downloadService.downloadFile(
        widget.url,
        onProgress: (received, total) {
          if (mounted && total > 0) {
            setState(() {
              _progress = received / total;
            });
          }
        },
      );

      if (!mounted) return;

      setState(() {
        _isDownloading = false;
        _isDownloaded = true;
        _localPath = path;
      });

      final controller = ref.read(lessonViewProvider(widget.lesson).notifier);

      if (!widget.lesson.hasVideo) {
        controller.markAsComplete(widget.lesson);
        AppSnackBar.showSuccess(
          context,
          'Resource downloaded & Lesson marked as complete',
        );
      } else {
        AppSnackBar.showSuccess(context, 'Resource downloaded successfully');
      }

      // Auto-open the file
      await _downloadService.openFile(path);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isDownloading = false;
        _error = e.toString();
      });
      AppSnackBar.showError(context, 'Download failed, please try again');
    }
  }

  Future<void> _openDownloadedFile() async {
    if (_localPath != null) {
      final opened = await _downloadService.openFile(_localPath!);
      if (!opened && mounted) {
        AppSnackBar.showInfo(context, 'Could not open file');
      }
    }
  }

  IconData _getFileIcon(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'doc':
      case 'docx':
        return Icons.description_rounded;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow_rounded;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart_rounded;
      case 'zip':
      case 'rar':
        return Icons.folder_zip_rounded;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image_rounded;
      case 'mp4':
      case 'mov':
      case 'avi':
        return Icons.video_file_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  Color _getFileColor(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return Colors.redAccent;
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'ppt':
      case 'pptx':
        return Colors.orange;
      case 'xls':
      case 'xlsx':
        return Colors.green;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fileName = _downloadService.getFileName(widget.url);
    final controller = ref.read(lessonViewProvider(widget.lesson).notifier);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.space16),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppSizes.radiusXl),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(_getFileIcon(fileName), color: _getFileColor(fileName)),
                  const SizedBox(width: AppSizes.space16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fileName.isNotEmpty ? fileName : 'Attachment',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          _isDownloading
                              ? 'Downloading... ${(_progress * 100).toInt()}%'
                              : _isDownloaded
                              ? 'Tap to open'
                              : 'Tap to download',
                          style: GoogleFonts.outfit(
                            fontSize: AppSizes.fontXs,
                            color: _isDownloading
                                ? AppColors.primary
                                : _isDownloaded
                                ? Colors.green
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_isDownloading)
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        value: _progress > 0 ? _progress : null,
                        strokeWidth: 2.5,
                        color: AppColors.primary,
                      ),
                    )
                  else if (_isDownloaded)
                    IconButton(
                      icon: const Icon(
                        Icons.open_in_new_rounded,
                        color: Colors.green,
                      ),
                      onPressed: _openDownloadedFile,
                    )
                  else
                    IconButton(
                      icon: const Icon(
                        Icons.download_rounded,
                        color: AppColors.primary,
                      ),
                      onPressed: _startDownload,
                    ),
                ],
              ),
              // Progress bar
              if (_isDownloading) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _progress > 0 ? _progress : null,
                    minHeight: 4,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    color: AppColors.primary,
                  ),
                ),
              ],
              // Error message
              if (_error != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Download failed. Tap to retry.',
                        style: GoogleFonts.outfit(
                          fontSize: AppSizes.fontXs,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        if (!widget.lesson.hasVideo && widget.lesson.isCompleted != true) ...[
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                controller.markAsComplete(widget.lesson);
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
