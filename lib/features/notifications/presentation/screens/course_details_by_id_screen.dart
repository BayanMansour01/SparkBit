// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:go_router/go_router.dart';
// import 'package:sparkbit/core/constants/app_colors.dart';
// import 'package:sparkbit/core/di/service_locator.dart';
// import 'package:sparkbit/features/courses/domain/repositories/courses_repository.dart';
// import 'package:sparkbit/features/courses/data/models/course_model.dart';
// import 'package:sparkbit/features/courses/presentation/screens/course_details_screen.dart';
// import 'package:sparkbit/features/courses/presentation/providers/courses_provider.dart';

// /// Thin wrapper: loads a CourseModel by ID then delegates to the existing
// /// CourseDetailsScreen. Used when navigating from notifications where only
// /// course_id is available (no CourseModel object in hand).
// class CourseDetailsByIdScreen extends ConsumerStatefulWidget {
//   final int courseId;

//   const CourseDetailsByIdScreen({super.key, required this.courseId});

//   @override
//   ConsumerState<CourseDetailsByIdScreen> createState() =>
//       _CourseDetailsByIdScreenState();
// }

// class _CourseDetailsByIdScreenState
//     extends ConsumerState<CourseDetailsByIdScreen> {
//   CourseModel? _course;
//   bool _isLoading = true;
//   String? _error;

//   @override
//   void initState() {
//     super.initState();
//     _loadCourse();
//   }

//   Future<void> _loadCourse() async {
//     // 1. Try in-memory cache first (instant — no network call)
//     final cached = ref.read(courseByIdProvider(widget.courseId));
//     if (cached != null) {
//       if (mounted)
//         setState(() {
//           _course = cached;
//           _isLoading = false;
//         });
//       return;
//     }

//     // 2. Fetch from API
//     try {
//       final repo = getIt<CoursesRepository>();
//       final result = await repo.getCourseById(widget.courseId);
//       if (mounted)
//         setState(() {
//           _course = result;
//           _isLoading = false;
//         });
//     } catch (e) {
//       if (mounted)
//         setState(() {
//           _error = e.toString();
//           _isLoading = false;
//         });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return Scaffold(
//         backgroundColor: Theme.of(context).colorScheme.surface,
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CircularProgressIndicator(color: AppColors.primary),
//               const SizedBox(height: 16),
//               Text(
//                 'Loading course...',
//                 style: GoogleFonts.outfit(
//                   fontSize: 16,
//                   color: Theme.of(
//                     context,
//                   ).colorScheme.onSurface.withOpacity(0.6),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     if (_error != null || _course == null) {
//       return Scaffold(
//         backgroundColor: Theme.of(context).colorScheme.surface,
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.error_outline_rounded,
//                 size: 64,
//                 color: Colors.red.shade400,
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 'Could not load course',
//                 style: GoogleFonts.outfit(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton.icon(
//                 onPressed: () {
//                   setState(() {
//                     _isLoading = true;
//                     _error = null;
//                   });
//                   _loadCourse();
//                 },
//                 icon: const Icon(Icons.refresh_rounded),
//                 label: const Text('Retry'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primary,
//                   foregroundColor: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               TextButton(
//                 onPressed: () => context.pop(),
//                 child: Text(
//                   'Go Back',
//                   style: GoogleFonts.outfit(color: AppColors.primary),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     // Delegate entirely to the existing CourseDetailsScreen
//     return CourseDetailsScreen(course: _course!);
//   }
// }
