import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../../core/di/service_locator.dart';
import '../../data/models/lesson_model.dart';
import 'courses_provider.dart';

import '../../../profile/presentation/providers/profile_provider.dart';

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
    // Final sync and invalidate related data on dispose
    ref.onDispose(() {
      if (!_isUserLoggedIn()) return;

      // 1. Optimistic Updates (Ensure state is reflected in lists)
      final currentP = state.currentProgress;
      _performOptimisticUpdates(
        lessonId: lesson.id,
        progress: currentP,
        isCompleted: currentP >= 99,
      );

      // 2. Network Sync (Fire & Forget)
      if (lesson.hasVideo) {
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
    return const LessonViewState();
  }

  /// Check if user is logged in (not a guest)
  bool _isUserLoggedIn() {
    final userProfile = ref.read(userProfileProvider).value;
    return userProfile != null && userProfile.id != -1;
  }

  void _invalidateAll(Ref ref, int courseId) {
    // 1. My Courses list screen - Silent Refresh
    ref.read(myCoursesProvider.notifier).refreshData();

    // 2. Courses list (Categories, Search) - Silent Refresh
    ref.read(coursesProvider.notifier).refreshData();

    // 3. Specific course details (Lessons list) - Silent Refresh
    // Removed to prevent redundant requests on exit. rely on optimistic updates.
    // ref.read(lessonsProvider(courseId).notifier).refreshData();

    // Note: HomeData updates automatically as it watches the above providers
  }

  // ... markAsComplete/Incomplete remain same ...

  Future<void> syncAndPop(BuildContext context) async {
    // Just Close! Logic is handled in onDispose
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  void updateProgress(double currentPositionRatio, double watchedRatio) {
    // watchedRatio is already (totalWatched / duration) as calculated in JS
    final progress = (watchedRatio * 100).clamp(0, 100).toDouble();

    // 1. Update local state for UI (Progress Bar) - always update locally
    if ((progress - state.currentProgress).abs() < 0.5 && progress < 100)
      return;
    state = state.copyWith(currentProgress: progress);

    // 2. Milestone-based Sync Logic (25%, 50%, 75%, 100%)
    // Only sync to server if user is logged in
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

    state = state.copyWith(isMarkedComplete: true);

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

    state = state.copyWith(isMarkedComplete: false);

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
