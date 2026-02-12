import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:yuna/features/courses/data/models/lesson_model.dart';
import 'package:yuna/core/widgets/responsive/responsive_center.dart';

import '../providers/lesson_view_provider.dart';
import '../widgets/lesson_viewer/lesson_app_bar.dart';
import '../widgets/lesson_viewer/lesson_content.dart';
import '../widgets/lesson_viewer/lesson_video_player.dart';

class LessonViewerScreen extends ConsumerWidget {
  final LessonModel lesson;

  const LessonViewerScreen({super.key, required this.lesson});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize controller logic
    final controller = ref.read(lessonViewProvider(lesson).notifier);

    return ShowCaseWidget(
      builder: (innerContext) {
        // Trigger Tips Check
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.checkAndShowTips(innerContext, lesson.hasVideo);
        });

        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (didPop) return;
            controller.syncAndPop(context);
          },
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: LessonAppBar(lesson: lesson),
            body: ResponsiveCenter(
              child: SizedBox.expand(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LessonVideoPlayer(lesson: lesson),
                    LessonContent(lesson: lesson),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
