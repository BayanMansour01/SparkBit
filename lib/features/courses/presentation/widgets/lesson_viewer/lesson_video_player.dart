import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sparkbit/core/constants/app_colors.dart';
import 'package:sparkbit/core/widgets/youtube_player_widget.dart';
import 'package:sparkbit/features/courses/data/models/lesson_model.dart';
import 'package:sparkbit/features/courses/presentation/providers/lesson_view_provider.dart';

class LessonVideoPlayer extends ConsumerWidget {
  final LessonModel lesson;

  const LessonVideoPlayer({super.key, required this.lesson});

  bool _isYouTubeUrl(String? url) {
    if (url == null) return false;
    return url.contains('youtube.com') || url.contains('youtu.be');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(lessonViewProvider(lesson).notifier);
    final hasVideo = lesson.hasVideo;
    final isYouTube = _isYouTubeUrl(lesson.videoUrl);

    if (!hasVideo) {
      return Center(
        child: Icon(
          Icons.ondemand_video_rounded,
          size: 64,
          color: Colors.grey[300],
        ),
      );
    }

    if (!isYouTube) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Text(
            "Video format not supported",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // STABLE TREE: YouTubePlayerWidget is ALWAYS at Stack[0]
    // Parent (lesson_viewer_screen) controls the sizing via SizedBox
    // This ensures the WebView is never destroyed on orientation change
    return Stack(
      fit: StackFit.expand,
      children: [
        // Video player - always at index 0, never moves in tree
        YouTubePlayerWidget(
          onProgress: (pos, watched) => controller.updateProgress(pos, watched),
          videoUrl: lesson.videoUrl!,
        ),

        // Showcase overlay - only in portrait mode
        if (!isLandscape && hasVideo && isYouTube)
          Positioned(
            bottom: 5,
            right: 5,
            child: Showcase.withWidget(
              key: controller.videoPlayerKey,
              targetShapeBorder: const CircleBorder(),
              container: Transform.translate(
                offset: const Offset(-15, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomPaint(
                      painter: _ArrowPainter(isUpwards: true),
                      size: const Size(20, 10),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(0),
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.screen_rotation_rounded,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Fullscreen & Quality',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap here to fullscreen, then rotate your device to see video resolutions.',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              child: const IgnorePointer(
                child: SizedBox(width: 40, height: 40),
              ),
            ),
          ),
      ],
    );
  }
}

class _ArrowPainter extends CustomPainter {
  final bool isUpwards;

  _ArrowPainter({this.isUpwards = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    if (isUpwards) {
      path.moveTo(0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0);
      path.close();
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
