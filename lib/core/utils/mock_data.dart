import '../../features/courses/data/models/course_model.dart';
import '../../features/courses/data/models/category_model.dart';
import '../../features/courses/data/models/sub_category_model.dart';
import '../../features/courses/data/models/lesson_model.dart';
import '../models/user_profile.dart';
import '../models/constant_value.dart';
import '../config/app_config.dart';

/// ═══════════════════════════════════════════════════════════════════════════
/// CENTRALIZED MOCK DATA
/// ═══════════════════════════════════════════════════════════════════════════
///
/// This file contains ALL mock data for the application.
/// Used when [AppConfig.useMockData] is true.
///
/// Benefits:
/// - Single source of truth for mock data
/// - Easy to maintain and update
/// - Consistent data across all features
///
/// Author: Antigravity AI
/// ═══════════════════════════════════════════════════════════════════════════

class MockData {
  MockData._();

  // ═══════════════════════════════════════════════════════════════════════════
  // USER PROFILES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Mock authenticated user profile
  static UserProfile get mockProfile => const UserProfile(
    id: 1,
    name: 'Bayan Mansour',
    email: 'bayan@example.com',
    role: 'student',
    status: ConstantValue(value: 'active', label: 'Active'),
    avatar:
        'https://ui-avatars.com/api/?name=Bayan+Mansour&background=6366f1&color=fff',
  );

  /// Guest user profile (for unauthenticated users)
  static UserProfile get guestProfile => const UserProfile(
    id: -1,
    name: 'Guest',
    email: '',
    role: 'guest',
    status: ConstantValue(value: 'guest', label: 'Guest'),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // CATEGORIES
  // ═══════════════════════════════════════════════════════════════════════════

  static List<CategoryModel> get mockCategories => const [
    CategoryModel(
      id: 1,
      name: 'Development',
      description: 'Learn to code and build amazing software',
      imageUrl:
          'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=500&q=80',
      order: 1,
    ),
    CategoryModel(
      id: 2,
      name: 'Business',
      description: 'Master business strategies and entrepreneurship',
      imageUrl:
          'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=500&q=80',
      order: 2,
    ),
    CategoryModel(
      id: 3,
      name: 'Design',
      description: 'Unlock your creative potential with design',
      imageUrl:
          'https://images.unsplash.com/photo-1561070791-2526d30994b5?w=500&q=80',
      order: 3,
    ),
    CategoryModel(
      id: 4,
      name: 'Marketing',
      description: 'Reach your audience with effective marketing',
      imageUrl:
          'https://images.unsplash.com/photo-1533750516457-a7f992034fec?w=500&q=80',
      order: 4,
    ),
    CategoryModel(
      id: 5,
      name: 'Photography',
      description: 'Capture the world with photography skills',
      imageUrl:
          'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=500&q=80',
      order: 5,
    ),
    CategoryModel(
      id: 6,
      name: 'Music',
      description: 'Learn instruments and music production',
      imageUrl:
          'https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=500&q=80',
      order: 6,
    ),
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // SUB-CATEGORIES
  // ═══════════════════════════════════════════════════════════════════════════

  static List<SubCategoryModel> get mockSubCategories => [
    // Development Sub-Categories
    SubCategoryModel(
      id: 1,
      categoryId: 1,
      name: 'Web Development',
      description: 'HTML, CSS, JS, React, and more',
      imageUrl:
          'https://images.unsplash.com/photo-1547658719-da2b51169166?w=500&q=80',
      order: 1,
    ),
    SubCategoryModel(
      id: 2,
      categoryId: 1,
      name: 'Mobile Development',
      description: 'Flutter, React Native, Swift, Kotlin',
      imageUrl:
          'https://images.unsplash.com/photo-1526498460520-4c246339dccb?w=500&q=80',
      order: 2,
    ),
    SubCategoryModel(
      id: 3,
      categoryId: 1,
      name: 'Data Science',
      description: 'Python, Machine Learning, AI',
      imageUrl:
          'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=500&q=80',
      order: 3,
    ),

    // Business Sub-Categories
    SubCategoryModel(
      id: 4,
      categoryId: 2,
      name: 'Entrepreneurship',
      description: 'Start and grow your own business',
      imageUrl:
          'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=500&q=80',
      order: 4,
    ),
    SubCategoryModel(
      id: 5,
      categoryId: 2,
      name: 'Finance',
      description: 'Accounting, investing, and financial planning',
      imageUrl:
          'https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=500&q=80',
      order: 5,
    ),

    // Design Sub-Categories
    SubCategoryModel(
      id: 6,
      categoryId: 3,
      name: 'UI/UX Design',
      description: 'User interface and experience design',
      imageUrl:
          'https://images.unsplash.com/photo-1586717791821-3f44a5638d4f?w=500&q=80',
      order: 6,
    ),
    SubCategoryModel(
      id: 7,
      categoryId: 3,
      name: 'Graphic Design',
      description: 'Photoshop, Illustrator, and visual communication',
      imageUrl:
          'https://images.unsplash.com/photo-1626785774573-4b79931256ce?w=500&q=80',
      order: 7,
    ),

    // Marketing Sub-Categories
    SubCategoryModel(
      id: 8,
      categoryId: 4,
      name: 'Digital Marketing',
      description: 'SEO, SEM, Social Media Marketing',
      imageUrl:
          'https://images.unsplash.com/photo-1557838923-2985c318be48?w=500&q=80',
      order: 8,
    ),

    // Photography Sub-Categories
    SubCategoryModel(
      id: 9,
      categoryId: 5,
      name: 'Portrait Photography',
      description: 'Master portrait and studio photography',
      imageUrl:
          'https://images.unsplash.com/photo-1554151228-14d9def656e4?w=500&q=80',
      order: 9,
    ),

    // Music Sub-Categories
    SubCategoryModel(
      id: 10,
      categoryId: 6,
      name: 'Piano',
      description: 'Learn piano from beginner to advanced',
      imageUrl:
          'https://images.unsplash.com/photo-1520523839897-bd0b52f945a0?w=500&q=80',
      order: 10,
    ),
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // COURSES
  // ═══════════════════════════════════════════════════════════════════════════

  static List<CourseModel> get mockCourses => const [
    // Course 1: Flutter (Purchased)
    CourseModel(
      id: 1,
      subCategoryId: 2, // Mobile Dev
      instructorId: 1,
      title: 'Flutter & Dart - The Complete Guide [2024 Edition]',
      description:
          'A complete guide to the Flutter SDK & Flutter Framework for building native iOS and Android apps.',
      price: '19.99',
      isFree: false,
      coverImageUrl:
          'https://images.unsplash.com/photo-1617042375876-a13e36732a04?w=500&q=80',
      lessonsCount: 42,
      instructor: InstructorModel(
        id: 1,
        name: 'Maximilian',
        bio: 'Professional Web & Mobile Developer',
        imageUrl:
            'https://ui-avatars.com/api/?name=Maximilian&background=random',
      ),
      order: 1,
      completionPercentage: 35,
      avgRating: 4.8,
      isPurchased: true,
    ),

    // Course 2: Web Dev (Not Purchased)
    CourseModel(
      id: 2,
      subCategoryId: 1, // Web Dev
      instructorId: 2,
      title: 'The Web Developer Bootcamp 2024',
      description:
          'The only course you need to learn web development - HTML, CSS, JS, Node in one course.',
      price: '24.99',
      isFree: false,
      coverImageUrl:
          'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=500&q=80',
      lessonsCount: 68,
      instructor: InstructorModel(
        id: 2,
        name: 'Colt Steele',
        bio: 'Developer and Bootcamp Instructor',
        imageUrl:
            'https://ui-avatars.com/api/?name=Colt+Steele&background=random',
      ),
      order: 2,
      completionPercentage: 0,
      avgRating: 4.5,
      isPurchased: false,
    ),

    // Course 3: ML (Free)
    CourseModel(
      id: 3,
      subCategoryId: 3, // Data Science
      instructorId: 3,
      title: 'Machine Learning A-Z™: AI, Python & R',
      description:
          'Learn to create Machine Learning Algorithms in Python and R from two Data Science experts.',
      price: '0.00',
      isFree: true,
      coverImageUrl:
          'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=500&q=80',
      lessonsCount: 25,
      instructor: InstructorModel(
        id: 3,
        name: 'Kirill Eremenko',
        bio: 'Data Science Management Consultant',
        imageUrl: 'https://ui-avatars.com/api/?name=Kirill&background=random',
      ),
      order: 3,
      completionPercentage: 0,
      avgRating: 5.0,
      isPurchased: false,
    ),

    // Course 4: UI/UX (Not Purchased)
    CourseModel(
      id: 4,
      subCategoryId: 6, // UI/UX
      instructorId: 4,
      title: 'User Experience Design Essentials - Adobe XD UI UX Design',
      description:
          'Use XD to get a job in UI Design, User Interface, User Experience design, UX design & Web Design',
      price: '14.99',
      isFree: false,
      coverImageUrl:
          'https://images.unsplash.com/photo-1581291518633-83b4ebd1d83e?w=500&q=80',
      lessonsCount: 30,
      instructor: InstructorModel(
        id: 4,
        name: 'Daniel Scott',
        bio: 'Adobe Certified Expert',
        imageUrl:
            'https://ui-avatars.com/api/?name=Daniel+Scott&background=random',
      ),
      order: 4,
      completionPercentage: 0,
      avgRating: 4.2,
      isPurchased: false,
    ),

    // Course 5: Marketing (Not Purchased)
    CourseModel(
      id: 5,
      subCategoryId: 8, // Marketing
      instructorId: 5,
      title: 'The Complete Digital Marketing Course - 12 Courses in 1',
      description:
          'Master Digital Marketing Strategy, Social Media Marketing, SEO, YouTube, Email, Facebook Marketing, Analytics & More!',
      price: '29.99',
      isFree: false,
      coverImageUrl:
          'https://images.unsplash.com/photo-1557838923-2985c318be48?w=500&q=80',
      lessonsCount: 55,
      instructor: InstructorModel(
        id: 5,
        name: 'Rob Percival',
        bio: 'Web Developer And Teacher',
        imageUrl:
            'https://ui-avatars.com/api/?name=Rob+Percival&background=random',
      ),
      order: 5,
      completionPercentage: 0,
      avgRating: 4.7,
      isPurchased: false,
    ),

    // Course 6: Piano (Purchased)
    CourseModel(
      id: 6,
      subCategoryId: 10, // Piano
      instructorId: 6,
      title: 'Pianoforall - Incredible New Way To Learn Piano & Keyboard',
      description:
          'Learn Piano in weeks not years. Play-By-Ear & read music. Pop, Blues, Jazz, Ballads, Improvisation, Classical',
      price: '12.99',
      isFree: false,
      coverImageUrl:
          'https://images.unsplash.com/photo-1520523839897-bd0b52f945a0?w=500&q=80',
      lessonsCount: 18,
      instructor: InstructorModel(
        id: 6,
        name: 'Robin Hall',
        bio: 'Piano Teacher',
        imageUrl:
            'https://ui-avatars.com/api/?name=Robin+Hall&background=random',
      ),
      order: 6,
      completionPercentage: 60,
      avgRating: 4.9,
      isPurchased: true,
    ),
  ];

  /// Get only purchased courses (for "My Courses" section)
  static List<CourseModel> get mockMyCourses =>
      mockCourses.where((c) => c.isPurchased).toList();

  // ═══════════════════════════════════════════════════════════════════════════
  // LESSONS
  // ═══════════════════════════════════════════════════════════════════════════

  static List<LessonModel> get mockLessons => const [
    // FREE LESSONS (Accessible to everyone)
    LessonModel(
      id: 1,
      courseId: 1,
      title: '1. Introduction to the Course',
      videoUrl: 'https://www.youtube.com/watch?v=OuevA8l0fWM',
      attachmentPath: null,
      isFree: true,
      order: 1,
      canAccess: true,
      isCompleted: true,
      progress: 100,
      avgRating: 4.5,
    ),
    LessonModel(
      id: 2,
      courseId: 1,
      title: '2. Setup & Installation Guide',
      videoUrl: 'https://www.youtube.com/watch?v=OuevA8l0fWM',
      attachmentPath: 'https://example.com/setup_guide.pdf',
      isFree: true,
      order: 2,
      canAccess: true,
      isCompleted: true,
      progress: 100,
      avgRating: 4.0,
    ),
    LessonModel(
      id: 3,
      courseId: 1,
      title: '3. Your First Flutter App',
      videoUrl: 'https://www.youtube.com/watch?v=OuevA8l0fWM',
      attachmentPath: null,
      isFree: true,
      order: 3,
      canAccess: true,
      isCompleted: false,
      progress: 50,
      avgRating: 4.8,
    ),

    // PAID LESSONS (Accessible to course owner)
    LessonModel(
      id: 4,
      courseId: 1,
      title: '4. Understanding Widgets',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      attachmentPath: 'https://example.com/widgets_cheatsheet.pdf',
      isFree: false,
      order: 4,
      canAccess: true, // Purchased
      isCompleted: false,
      progress: 0,
      avgRating: 4.9,
    ),
    LessonModel(
      id: 5,
      courseId: 1,
      title: '5. State Management Deep Dive',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      attachmentPath: null,
      isFree: false,
      order: 5,
      canAccess: true, // Purchased
      isCompleted: false,
      progress: 0,
      avgRating: 5.0,
    ),
    LessonModel(
      id: 6,
      courseId: 1,
      title: '6. API Integration Masterclass',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      attachmentPath: 'https://example.com/api_examples.zip',
      isFree: false,
      order: 6,
      canAccess: true, // Purchased
      isCompleted: false,
      progress: 0,
      avgRating: 4.7,
    ),

    // LOCKED LESSONS (For non-purchased courses demo)
    LessonModel(
      id: 7,
      courseId: 2, // Different course (not purchased)
      title: '1. Welcome to Web Development',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      attachmentPath: null,
      isFree: true,
      order: 1,
      canAccess: true, // Free lesson
      isCompleted: false,
      progress: 0,
      avgRating: 4.3,
    ),
    LessonModel(
      id: 8,
      courseId: 2,
      title: '2. HTML Fundamentals (Locked)',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      attachmentPath: null,
      isFree: false,
      order: 2,
      canAccess: false, // Not purchased
      isCompleted: false,
      progress: 0,
      avgRating: 0,
    ),
    LessonModel(
      id: 9,
      courseId: 2,
      title: '3. CSS Styling (Locked)',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      attachmentPath: 'https://example.com/css_guide.pdf',
      isFree: false,
      order: 3,
      canAccess: false, // Not purchased
      isCompleted: false,
      progress: 0,
      avgRating: 0,
    ),
  ];

  /// Get lessons for a specific course
  static List<LessonModel> getLessonsForCourse(int courseId) =>
      mockLessons.where((l) => l.courseId == courseId).toList();

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Simulate network delay for realistic mock behavior
  static Future<void> simulateNetworkDelay() async {
    await Future.delayed(Duration(milliseconds: AppConfig.mockNetworkDelayMs));
  }

  /// Get sub-categories for a specific category
  static List<SubCategoryModel> getSubCategoriesForCategory(int categoryId) =>
      mockSubCategories.where((s) => s.categoryId == categoryId).toList();

  /// Get courses for a specific sub-category
  static List<CourseModel> getCoursesForSubCategory(int subCategoryId) =>
      mockCourses.where((c) => c.subCategoryId == subCategoryId).toList();
}
