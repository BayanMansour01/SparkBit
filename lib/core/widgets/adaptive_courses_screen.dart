import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/profile/presentation/providers/profile_provider.dart';
import '../../features/courses/presentation/screens/courses_screen.dart';
import '../../features/courses/presentation/screens/my_courses_screen.dart';
import 'exit_confirm_wrapper.dart';

/// Adaptive screen that shows:
/// - Browse Courses for guest users
/// - My Courses for logged-in users
class AdaptiveCoursesScreen extends ConsumerWidget {
  const AdaptiveCoursesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider).valueOrNull;
    final isGuest = profile?.id == -1;

    // Show all courses for guests, my courses for logged-in users
    return ExitConfirmWrapper(
      child: isGuest ? const CoursesScreen() : const MyCoursesScreen(),
    );
  }
}
