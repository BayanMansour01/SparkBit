import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/services/device_service.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../home/presentation/providers/home_provider.dart';

/// Splash screen with highly animated coding theme
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Controllers
  late AnimationController _mainController;
  late AnimationController _bgController; // For continuous background movement

  // Letter Animations
  final List<Animation<double>> _letterScaleAnimations = [];
  final List<Animation<double>> _letterFadeAnimations = [];
  final List<Animation<Offset>> _letterSlideAnimations = [];

  // Subtitle Animation
  late Animation<int> _typingAnimation;
  late Animation<double> _cursorOpacity;

  static const String _subtitleText = '< Learn. Grow. Succeed. />';

  // Floating code symbols
  final List<_CodeSymbol> _symbols = [];
  final int _symbolCount = 10; // Optimized count for faster performance
  final List<String> _codeTokens = [
    '{ }',
    '</>',
    ';',
    '//',
    'var',
    'int',
    '()',
    '=>',
    '[]',
    '*',
    '!',
    '&&',
    '||',
    '\$',
  ];

  Future<void>? _homePrefetchFuture;

  @override
  void initState() {
    super.initState();

    // Main sequence controller
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1500), // Reduced for faster splash
      vsync: this,
    );

    // Background loop controller (slow rising bubbles)
    _bgController = AnimationController(
      duration: const Duration(seconds: 6), // Faster background
      vsync: this,
    )..repeat();

    _setupAnimations();
    _generateSymbols();

    // Warm up Home data while splash animation is running.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _startHomePrefetch();
    });

    _mainController.forward();
    _mainController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _checkAuthAndNavigate();
        });
      }
    });
  }

  void _setupAnimations() {
    // 1. Setup Letter Animations (S P A R K)
    const int letterCount = 8; // S-p-a-r-k-B-i-t
    const double startTime = 0.03; // Start earlier
    const double stagger = 0.06; // Faster stagger for 8 letters

    for (int i = 0; i < letterCount; i++) {
      final start = startTime + (i * stagger);
      final end = start + 0.3; // Quicker bounce

      // Scale: Pop in with elastic bounce (Clamped to 1.0)
      _letterScaleAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _mainController,
            curve: Interval(
              start,
              math.min(end, 1.0),
              curve: Curves.elasticOut,
            ),
          ),
        ),
      );

      // Fade: Smooth appearance
      _letterFadeAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _mainController,
            curve: Interval(start, math.min(end, 1.0), curve: Curves.easeOut),
          ),
        ),
      );

      // Slide: Bigger upward movement
      _letterSlideAnimations.add(
        Tween<Offset>(begin: const Offset(0, 1.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _mainController,
            curve: Interval(
              start,
              math.min(end, 1.0),
              curve: Curves.elasticOut,
            ),
          ),
        ),
      );
    }

    // 2. Setup Typewriter Animation
    // Start typing after letters are mostly done (around 0.45)
    _typingAnimation = StepTween(begin: 0, end: _subtitleText.length).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.45, 0.9, curve: Curves.linear),
      ),
    );

    // 3. Blinking Cursor
    _cursorOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _bgController,
        curve: const Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );
  }

  void _generateSymbols() {
    final random = math.Random();
    _symbols.clear();
    for (int i = 0; i < _symbolCount; i++) {
      _symbols.add(
        _CodeSymbol(
          text: _codeTokens[random.nextInt(_codeTokens.length)],
          initialX: random.nextDouble(), // 0.0 to 1.0
          initialY: random.nextDouble(), // 0.0 to 1.0
          scale: 0.5 + random.nextDouble() * 0.8, // Size variation
          speed: 0.2 + random.nextDouble() * 0.4, // Rising speed
          rotationSpeed:
              (random.nextDouble() - 0.5) * 2.0, // Rotates left or right
        ),
      );
    }
  }

  void _startHomePrefetch() {
    if (_homePrefetchFuture != null) return;

    final container = ProviderScope.containerOf(context, listen: false);
    _homePrefetchFuture = container
        .read(homeDataProvider.future)
        .then((_) {
          debugPrint('Home prefetch completed during splash');
        })
        .catchError((error) {
          debugPrint('Home prefetch failed during splash: $error');
        });
  }

  Future<void> _awaitShortPrefetchWindow() async {
    final future = _homePrefetchFuture;
    if (future == null) return;

    try {
      // Keep navigation snappy; only wait a short time for warm-up.
      await future.timeout(const Duration(milliseconds: 350));
    } catch (_) {
      // Ignore timeout/errors here and continue navigation.
    }
  }

  Future<void> _checkAuthAndNavigate() async {
    if (!mounted) return;

    final prefs = getIt<SharedPreferences>();
    final token = prefs.getString('access_token');

    if (token != null && token.isNotEmpty) {
      await _awaitShortPrefetchWindow();
      if (!mounted) return;
      getIt<DeviceService>().registerDeviceIfChanged(force: true).catchError((
        e,
      ) {
        debugPrint('Device registration failed on startup: $e');
        return false;
      });
      context.go(AppRoutes.home);
    } else {
      // Guest Mode: Go to Home directly
      debugPrint('No token found, entering Guest Mode');
      await _awaitShortPrefetchWindow();
      if (!mounted) return;
      context.go(AppRoutes.home);
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;
    final primaryColor = AppColors.primary;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final secondaryTextColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    // Cache size
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Dynamic Background (Rising Symbols) - Optimized with RepaintBoundary
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _bgController,
              builder: (context, child) {
                return Stack(
                  children: _symbols.map((symbol) {
                    return _buildRisingSymbol(symbol, size, isDark);
                  }).toList(),
                );
              },
            ),
          ),

          // 2. Main Center Content
          Center(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo Letters
                  RepaintBoundary(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildLetter('S', 0, primaryColor),
                        _buildLetter('p', 1, textColor),
                        _buildLetter('a', 2, textColor),
                        _buildLetter('r', 3, textColor),
                        _buildLetter('k', 4, primaryColor),
                        // const SizedBox(width: 16),
                        _buildLetter('B', 5, primaryColor),
                        _buildLetter('i', 6, textColor),
                        _buildLetter('t', 7, primaryColor),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Progress Line with Speed Performance Curve
                  AnimatedBuilder(
                    animation: _mainController,
                    builder: (context, child) {
                      // Using a custom curve for the progress width to make it feel "snappy"
                      final curve = CurvedAnimation(
                        parent: _mainController,
                        curve: Curves.fastOutSlowIn,
                      );
                      return Container(
                        height: 4,
                        width: 160 * curve.value,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withValues(
                                alpha: 0.5 * _mainController.value,
                              ),
                              blurRadius: 10 * _mainController.value,
                              spreadRadius: 2 * _mainController.value,
                            ),
                          ],
                          gradient: LinearGradient(
                            colors: [
                              primaryColor.withValues(alpha: 0.2),
                              primaryColor,
                              primaryColor.withValues(alpha: 0.2),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Typewriter Subtitle
                  RepaintBoundary(
                    child: AnimatedBuilder(
                      animation: _typingAnimation,
                      builder: (context, child) {
                        final count = _typingAnimation.value;
                        final currentText = _subtitleText.substring(0, count);

                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              currentText,
                              style: GoogleFonts.firaCode(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: secondaryTextColor,
                              ),
                            ),
                            // Blinking Cursor
                            AnimatedBuilder(
                              animation: _cursorOpacity,
                              builder: (context, child) {
                                final opacity =
                                    (math.sin(
                                          _bgController.value * 20 * math.pi,
                                        ) +
                                        1) /
                                    2;
                                return Opacity(
                                  opacity: opacity,
                                  child: Container(
                                    width: 8,
                                    height: 2,
                                    color: primaryColor,
                                    margin: const EdgeInsets.only(
                                      left: 4,
                                      top: 8,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLetter(String char, int index, Color color) {
    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) {
        if (index >= _letterScaleAnimations.length) return const SizedBox();

        return Opacity(
          opacity: _letterFadeAnimations[index].value,
          child: SlideTransition(
            position: _letterSlideAnimations[index],
            child: Transform.scale(
              scale: _letterScaleAnimations[index].value,
              child: Text(
                char,
                style: GoogleFonts.outfit(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: color,
                  height: 1.0,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRisingSymbol(_CodeSymbol symbol, Size screenSize, bool isDark) {
    // Optimized position calculation
    double yProgress =
        (symbol.initialY - (_bgController.value * symbol.speed)) % 1.2;
    if (yProgress < 0) yProgress += 1.2;

    final top = (yProgress * screenSize.height) - 50;

    final xSway =
        math.sin((_bgController.value * 2 * math.pi) + symbol.initialY * 10) *
        20;
    final left = (symbol.initialX * screenSize.width) + xSway;

    final rotation = (_bgController.value * 2 * math.pi * symbol.rotationSpeed);

    return Positioned(
      top: top,
      left: left,
      child: Transform.rotate(
        angle: rotation,
        child: Opacity(
          opacity: isDark ? 0.15 : 0.08,
          child: Text(
            symbol.text,
            style: GoogleFonts.firaCode(
              fontSize: 20 * symbol.scale,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _CodeSymbol {
  final String text;
  final double initialX;
  final double initialY;
  final double scale;
  final double speed;
  final double rotationSpeed;

  _CodeSymbol({
    required this.text,
    required this.initialX,
    required this.initialY,
    required this.scale,
    required this.speed,
    required this.rotationSpeed,
  });
}
