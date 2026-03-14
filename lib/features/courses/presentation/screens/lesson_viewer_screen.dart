import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sparkbit/features/courses/data/models/lesson_model.dart';
import 'package:sparkbit/features/home/presentation/providers/home_provider.dart';

import '../providers/lesson_view_provider.dart';
import '../providers/courses_provider.dart';
import '../widgets/lesson_viewer/lesson_app_bar.dart';
import '../widgets/lesson_viewer/lesson_content.dart';
import '../widgets/lesson_viewer/lesson_video_player.dart';

class LessonViewerScreen extends ConsumerStatefulWidget {
  final LessonModel lesson;

  const LessonViewerScreen({super.key, required this.lesson});

  @override
  ConsumerState<LessonViewerScreen> createState() => _LessonViewerScreenState();
}

class _LessonViewerScreenState extends ConsumerState<LessonViewerScreen> {
  @override
  void dispose() {
    // Always reset system UI when leaving this screen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(lessonViewProvider(widget.lesson).notifier);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // Update system UI based on orientation (after frame)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (isLandscape) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      }
    });

    // Single stable ShowCaseWidget - never recreated on orientation change
    return ShowCaseWidget(
      builder: (innerContext) {
        if (!isLandscape) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            controller.checkAndShowTips(innerContext, widget.lesson.hasVideo);
          });
        }

        return PopScope(
          canPop: true,
          onPopInvokedWithResult: (didPop, result) {
            // Trigger immediate data refresh when leaving lesson
            if (didPop) {
              // Force refresh all course data providers immediately
              Future.microtask(() {
                ref.read(myCoursesProvider.notifier).refreshData();
                ref.invalidate(homePopularCoursesProvider);
                ref.read(coursesProvider.notifier).refreshData();
                ref.invalidate(homeDataProvider);
              });
            }
          },
          child: Scaffold(
            backgroundColor: isLandscape
                ? Colors.black
                : Theme.of(context).colorScheme.surface,
            appBar: isLandscape ? null : LessonAppBar(lesson: widget.lesson),
            body: LayoutBuilder(
              builder: (context, constraints) {
                // Video height: full screen in landscape, 16:9 ratio in portrait
                final videoHeight = isLandscape
                    ? constraints.maxHeight
                    : constraints.maxWidth * 9 / 16;

                // STABLE TREE: LessonVideoPlayer is ALWAYS at Column[0] > SizedBox
                // This ensures the WebView is never destroyed on orientation change
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: constraints.maxWidth,
                      height: videoHeight,
                      child: LessonVideoPlayer(lesson: widget.lesson),
                    ),
                    if (!isLandscape)
                      Expanded(child: LessonContent(lesson: widget.lesson)),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
