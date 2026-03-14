import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../../core/di/service_locator.dart';
import '../../data/models/lesson_model.dart';
import 'courses_provider.dart';

import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../home/presentation/providers/home_provider.dart';

// State for the Lesson Viewer
class LessonViewState {
  final double currentProgress;
  final bool isMarkedComplete;
  final bool isTipsShown;

  const LessonViewState({
    this.currentProgress = 0,
    this.isMarkedComplete = false,
    this.isTipsShown = false,
  });

  LessonViewState copyWith({
    double? currentProgress,
    bool? isMarkedComplete,
    bool? isTipsShown,
  }) {
    return LessonViewState(
      currentProgress: currentProgress ?? this.currentProgress,
      isMarkedComplete: isMarkedComplete ?? this.isMarkedComplete,
      isTipsShown: isTipsShown ?? this.isTipsShown,
    );
  }
}

// Logic Controller
class LessonViewController
    extends AutoDisposeFamilyNotifier<LessonViewState, LessonModel> {
  final Set<int> _syncedMilestones = {};
  final GlobalKey videoPlayerKey = GlobalKey();

  @override
  LessonViewState build(LessonModel lesson) {
    // Initialize state with existing progress from lesson (from API)
    final initialProgress = lesson.progress ?? 0;

    // Final sync and invalidate related data on dispose
    ref.onDispose(() {
      if (!_isUserLoggedIn()) return;

      // Get the final progress from state
      final currentP = state.currentProgress;

      // 🔒 CRITICAL: Only save if progress increased (forward-only)
      // Compare with initial progress from lesson to prevent overwriting higher values
      if (currentP <= initialProgress) {
        // Progress didn't increase, skip save and just invalidate
        _invalidateAll(ref, lesson.courseId);
        return;
      }

      // 1. Optimistic Updates (Ensure state is reflected in lists immediately)
      _performOptimisticUpdates(
        lessonId: lesson.id,
        progress: currentP,
        isCompleted: currentP >= 99,
      );

      // 2. Network Sync (Fire & Forget)
      // Only sync if:
      // - Lesson has video (video lessons track progress)
      // - Progress increased from initial state
      if (lesson.hasVideo && currentP > initialProgress) {
        ref
            .read(coursesProvider.notifier)
            .updateLessonProgress(lesson.id, currentP)
            .then((_) {
              _invalidateAll(ref, lesson.courseId);
            });
      } else {
        _invalidateAll(ref, lesson.courseId);
      }
    });

    // Return initial state with progress from lesson
    return LessonViewState(currentProgress: initialProgress);
  }

  /// Check if user is logged in (not a guest)
  bool _isUserLoggedIn() {
    final userProfile = ref.read(userProfileProvider).value;
    return userProfile != null && userProfile.id != -1;
  }

  void _invalidateAll(Ref ref, int courseId) {
    // 1. My Courses list screen - Direct refresh for immediate update
    ref.read(myCoursesProvider.notifier).refreshData();

    // 2. Home Popular Courses - Invalidate to trigger rebuild with fresh data
    ref.invalidate(homePopularCoursesProvider);

    // 3. Courses list (Categories, Search) - Silent Refresh
    ref.read(coursesProvider.notifier).refreshData();

    // 4. Home page data provider - Invalidate to rebuild with updated dependencies
    ref.invalidate(homeDataProvider);
  }

  void updateProgress(double currentPositionRatio, double watchedRatio) {
    // watchedRatio is already (totalWatched / duration) as calculated in JS
    final progress = (watchedRatio * 100).clamp(0, 100).toDouble();

    // ⚠️ FORWARD-ONLY PROGRESS: Don't update if user rewinds the video
    // This ensures progress always increases, never decreases
    if (progress < state.currentProgress) {
      return;
    }

    // Skip small incremental updates (less than 0.5%) unless reaching 100%
    // This reduces unnecessary state updates and improves performance
    if ((progress - state.currentProgress).abs() < 0.5 && progress < 100) {
      return;
    }

    // 1. Update local state for UI (Progress Bar, etc.)
    state = state.copyWith(currentProgress: progress);

    // 2. Milestone-based Sync Logic (25%, 50%, 75%, 100%)
    // Only sync to server at key milestones to reduce API calls
    // Only sync if user is logged in
    if (!_isUserLoggedIn()) return;

    final milestones = [25, 50, 75, 100];
    for (final milestone in milestones) {
      if (progress >= milestone && !_syncedMilestones.contains(milestone)) {
        _syncedMilestones.add(milestone);
        // Async call to server and invalidate all relevant providers
        ref
            .read(coursesProvider.notifier)
            .updateLessonProgress(arg.id, progress)
            .then((_) {
              // Refetch all APIs that contain course progress after successful update
              _invalidateAll(ref, arg.courseId);
            });
        break; // Sync one milestone at a time
      }
    }
  }

  void markAsComplete(LessonModel lesson) {
    if (state.isMarkedComplete) return;
    // Only mark as complete if user is logged in
    if (!_isUserLoggedIn()) return;

    // Update state to reflect completion (100% progress)
    state = state.copyWith(isMarkedComplete: true, currentProgress: 100);

    // PERFORM OPTIMISTIC UPDATES
    _performOptimisticUpdates(
      lessonId: lesson.id,
      progress: 100,
      isCompleted: true,
    );

    // Call API in background
    ref.read(coursesProvider.notifier).markLessonCompleted(lesson).then((_) {
      // Invalidate eventually to sync perfectly
      _invalidateAll(ref, lesson.courseId);
    });
  }

  void markAsIncomplete(LessonModel lesson) {
    if (!state.isMarkedComplete) return;
    // Only mark as incomplete if user is logged in
    if (!_isUserLoggedIn()) return;

    // Update state to reflect incompletion (reset progress)
    state = state.copyWith(isMarkedComplete: false, currentProgress: 0);

    // PERFORM OPTIMISTIC UPDATES
    _performOptimisticUpdates(
      lessonId: lesson.id,
      progress: 0,
      isCompleted: false,
    );

    // Call API in background
    ref.read(coursesProvider.notifier).markLessonIncomplete(lesson.id).then((
      _,
    ) {
      _invalidateAll(ref, lesson.courseId);
    });
  }

  /// Helper to update all local states immediately
  void _performOptimisticUpdates({
    required int lessonId,
    required double progress,
    required bool isCompleted,
  }) {
    // 1. Update Lessons List (Immediate Icon/Status change)
    final lessonsNotifier = ref.read(lessonsProvider(arg.courseId).notifier);
    lessonsNotifier.updateLocalState(
      lessonId,
      isCompleted: isCompleted,
      progress: progress,
    );

    // 2. Calculate New Course Progress Percentage based on the updated lessons list
    // We need to read the *updated* list from the state we just modified (or modify a copy to calc)
    final lessonsState = ref.read(lessonsProvider(arg.courseId));

    if (lessonsState.hasValue && lessonsState.value != null) {
      final allLessons = lessonsState.value!.data;
      if (allLessons.isNotEmpty) {
        final completedCount = allLessons
            .where((l) => l.isCompleted == true)
            .length;
        // Note: If we just updated the state above, `allLessons` might already reflect it
        // depending on if Riverpod syncs synchronously. To be safe, we re-verify or trust the calculation.
        // Let's assume the updateLocalState works.

        final newPercentage = ((completedCount / allLessons.length) * 100)
            .round();

        // 3. Update Course Lists (MyCourses, Home, etc)
        ref
            .read(myCoursesProvider.notifier)
            .updateCourseLocalProgress(arg.courseId, newPercentage);

        ref
            .read(coursesProvider.notifier)
            .updateCourseLocalProgress(arg.courseId, newPercentage);
      }
    }
  }

  Future<void> checkAndShowTips(BuildContext context, bool hasVideo) async {
    if (state.isTipsShown) return;

    final prefs = getIt<SharedPreferences>();
    final hasShown = prefs.getBool('hasShownVideoTips') ?? false;

    if (hasVideo && !hasShown) {
      // Delay for UI stability
      await Future.delayed(const Duration(milliseconds: 1000));
      if (context.mounted) {
        ShowCaseWidget.of(context).startShowCase([videoPlayerKey]);
        prefs.setBool('hasShownVideoTips', true);
        state = state.copyWith(isTipsShown: true);
      }
    }
  }
}

final lessonViewProvider = NotifierProvider.autoDispose
    .family<LessonViewController, LessonViewState, LessonModel>(
      LessonViewController.new,
    );
