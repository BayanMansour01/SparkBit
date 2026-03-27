import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:sparkbit/core/widgets/app_loading_indicator.dart';

/// YouTube Player State
class YouTubePlayerState {
  final bool isPlayerReady;
  final bool embedErrorDetected;
  final bool isFullscreen;

  const YouTubePlayerState({
    this.isPlayerReady = false,
    this.embedErrorDetected = false,
    this.isFullscreen = false,
  });

  YouTubePlayerState copyWith({
    bool? isPlayerReady,
    bool? embedErrorDetected,
    bool? isFullscreen,
  }) {
    return YouTubePlayerState(
      isPlayerReady: isPlayerReady ?? this.isPlayerReady,
      embedErrorDetected: embedErrorDetected ?? this.embedErrorDetected,
      isFullscreen: isFullscreen ?? this.isFullscreen,
    );
  }
}

/// YouTube Player Notifier
class YouTubePlayerNotifier extends StateNotifier<YouTubePlayerState> {
  YouTubePlayerNotifier() : super(const YouTubePlayerState());

  void setPlayerReady() {
    state = state.copyWith(isPlayerReady: true);
  }

  void setEmbedError() {
    state = state.copyWith(embedErrorDetected: true);
  }

  void setFullscreen(bool isFullscreen) {
    state = state.copyWith(isFullscreen: isFullscreen);
  }
}

/// YouTube Player Provider (Family for multi-video support)
final youtubePlayerProvider = StateNotifierProvider.autoDispose
    .family<YouTubePlayerNotifier, YouTubePlayerState, String>(
      (ref, videoId) => YouTubePlayerNotifier(),
    );

/// Provider for tracking progress of a specific video
final youtubeProgressProvider = StateProvider.autoDispose
    .family<(double postion, double watched), String>(
      (ref, videoId) => (0.0, 0.0),
    );

/// YouTube Player Widget - View Only (No Download, No Share, No Copy Link)
class YouTubePlayerWidget extends ConsumerStatefulWidget {
  final String videoUrl;
  final Function(double position, double watched)? onProgress;

  const YouTubePlayerWidget({
    super.key,
    required this.videoUrl,
    this.onProgress,
  });

  /// Extract YouTube video ID
  static String? extractVideoId(String url) {
    return YoutubePlayer.convertUrlToId(url);
  }

  @override
  ConsumerState<YouTubePlayerWidget> createState() =>
      _YouTubePlayerWidgetState();
}

class _YouTubePlayerWidgetState extends ConsumerState<YouTubePlayerWidget> {
  late YoutubePlayerController _controller;
  String? _videoId;
  double _lastTime = -1;
  double _totalWatched = 0;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _videoId = YouTubePlayerWidget.extractVideoId(widget.videoUrl);

    if (_videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: _videoId!,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          enableCaption: true,
          hideControls: false,
          hideThumbnail: false,
          forceHD: false,
          disableDragSeek: false,
          useHybridComposition: true,
        ),
      )..addListener(_onPlayerStateChanged);
    }
  }

  void _onPlayerStateChanged() {
    if (_disposed || _videoId == null) return;

    final value = _controller.value;

    // Mark as ready
    if (value.isReady) {
      ref.read(youtubePlayerProvider(_videoId!).notifier).setPlayerReady();
    }

    // Track error
    if (value.hasError) {
      ref.read(youtubePlayerProvider(_videoId!).notifier).setEmbedError();
    }

    // Track progress
    if (value.isPlaying) {
      _trackProgress();
    }
  }

  void _trackProgress() {
    if (_disposed || _videoId == null) return;

    final currentTime = _controller.value.position.inMilliseconds / 1000.0;
    final duration = _controller.metadata.duration.inMilliseconds / 1000.0;

    if (duration > 0) {
      // Calculate watched time (actual viewing, not seeking)
      if (_lastTime != -1) {
        final diff = currentTime - _lastTime;
        if (diff > 0 && diff < 3) {
          _totalWatched += diff;
        }
      }
      _lastTime = currentTime;

      final posPercent = currentTime / duration;
      final watchedPercent = _totalWatched / duration;

      // Update progress provider
      ref.read(youtubeProgressProvider(_videoId!).notifier).state = (
        posPercent,
        watchedPercent,
      );

      // Notify callback
      widget.onProgress?.call(posPercent, watchedPercent);
    }
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _disposed = true;
    _controller.removeListener(_onPlayerStateChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_videoId == null) {
      return const Center(
        child: Text('Invalid Video URL', style: TextStyle(color: Colors.white)),
      );
    }

    final playerState = ref.watch(youtubePlayerProvider(_videoId!));

    if (playerState.embedErrorDetected) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.error_outline, color: Colors.white, size: 48),
              SizedBox(height: 16),
              Text(
                'Video cannot be embedded',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                'This video may restrict playback on other apps.',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    return YoutubePlayerBuilder(
      onEnterFullScreen: () {
        ref.read(youtubePlayerProvider(_videoId!).notifier).setFullscreen(true);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      },
      onExitFullScreen: () {
        ref
            .read(youtubePlayerProvider(_videoId!).notifier)
            .setFullscreen(false);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.amber,
        progressColors: const ProgressBarColors(
          playedColor: Colors.amber,
          handleColor: Colors.amberAccent,
        ),
        // No top actions = no share, no copy link, no title
        topActions: const [],
        bottomActions: [
          CurrentPosition(),
          const SizedBox(width: 8),
          ProgressBar(isExpanded: true),
          const SizedBox(width: 8),
          RemainingDuration(),
          const SizedBox(width: 8),
          PlaybackSpeedButton(),
          FullScreenButton(),
        ],
        onReady: () {
          ref.read(youtubePlayerProvider(_videoId!).notifier).setPlayerReady();
        },
        onEnded: (metaData) {
          // Video ended - ensure final progress is captured
          if (_videoId != null) {
            final dur = _controller.metadata.duration.inMilliseconds / 1000.0;
            if (dur > 0) {
              final watchedPercent = _totalWatched / dur;
              ref.read(youtubeProgressProvider(_videoId!).notifier).state = (
                1.0,
                watchedPercent,
              );
              widget.onProgress?.call(1.0, watchedPercent);
            }
          }
        },
      ),
      builder: (context, player) {
        return Stack(
          children: [
            player,
            if (!playerState.isPlayerReady)
              Container(
                color: Colors.black,
                child: const Center(
                  child: AppLoadingIndicator(color: Colors.white, size: 40),
                ),
              ),
          ],
        );
      },
    );
  }
}
