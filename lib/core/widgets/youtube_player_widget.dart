import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:yuna/core/widgets/app_loading_indicator.dart';

/// JS constants for the player
const String _cleanPlayerJs = """
   // CRITICAL: Javascript Spoofing to match Windows User Agent
   try {
     Object.defineProperty(navigator, 'platform', {get: function(){return 'Win32';}});
     Object.defineProperty(navigator, 'maxTouchPoints', {get: function(){return 0;}}); 
     Object.defineProperty(navigator, 'vendor', {get: function(){return 'Google Inc.';}});
   } catch(e) {}

   function cleanPlayer() {
     const css = `.ytp-chrome-top, .ytp-youtube-button, .ytp-impression-link, .iv-branding,
     .ytp-endscreen, .ytp-endscreen-content, .ytp-pause-overlay, .ytp-watermark,
     .ytp-contextmenu, .ytp-next-button, .ytp-prev-button {
       display: none !important; visibility: hidden !important;
     }`;
     if (!document.getElementById('youtube-cleaner-style')) {
       const style = document.createElement('style');
       style.id = 'youtube-cleaner-style';
       style.type = 'text/css';
       style.appendChild(document.createTextNode(css));
       document.head.appendChild(style);
     }
   }
   const observer = new MutationObserver(cleanPlayer);
   const targetNode = document.body;
   if (targetNode) { observer.observe(targetNode, { childList: true, subtree: true }); }
   cleanPlayer();

   function detectEmbedError(){
     try{
       const text = (document.body && document.body.innerText) ? document.body.innerText : '';
       if(text.indexOf('Error 153') !== -1 || text.indexOf('Video player configuration error') !== -1){
         PlayerStatusChannel.postMessage('embed_error');
       }
       document.querySelectorAll('a').forEach(a=>{
         if(!a.__blocked_by_flutter){
           a.__blocked_by_flutter = true;
           a.addEventListener('click', function(e){ e.preventDefault(); PlayerStatusChannel.postMessage('blocked_link:'+this.href); }, {passive:false});
           a.setAttribute('target','_self');
         }
       });
     }catch(e){}
   }
   setInterval(detectEmbedError, 1000);
   detectEmbedError();
   PlayerStatusChannel.postMessage('ready');
""";

const String _progressTrackerJs = """
  var lastTime = -1;
  var totalWatched = 0;
  var lastSentTimestamp = 0;
  
  setInterval(function() {
    try {
      var player = document.getElementById('movie_player');
      if (player && player.getDuration && player.getCurrentTime) {
        var duration = player.getDuration();
        var currentTime = player.getCurrentTime();
        var playerState = player.getPlayerState(); // 1 = playing
        
        if (duration > 0 && playerState === 1) {
           // 1. Calculate Watched Time Logic (Every Second - High Precision)
           if (lastTime !== -1) {
             var diff = currentTime - lastTime;
             if (diff > 0 && diff < 3) { // Ignore seeking/skipping
               totalWatched += diff;
             }
           }
           lastTime = currentTime;
           
           // 2. Optimized Messaging (Low Frequency)
           var posPercent = currentTime / duration;
           var watchedPercent = totalWatched / duration;
           var now = Date.now();
           
           // Send message ONLY if:
           // - 5 seconds passed since last send (Regular update)
           // - OR watchedPercent just crossed 0.85 (Critical event for completion)
           // - OR video ended
           
           var isCriticalUpdate = (watchedPercent >= 0.85 && watchedPercent < 0.87); // Critical window
           var isPeriodicUpdate = (now - lastSentTimestamp > 5000); // Every 5 seconds
           
           if (isPeriodicUpdate || isCriticalUpdate) {
               PlayerStatusChannel.postMessage('progress:' + posPercent + ':' + watchedPercent);
               lastSentTimestamp = now;
           }
        } else {
           lastTime = currentTime;
        }
      }
    } catch(e) {}
  }, 1000); // Internal logic runs every 1s for accuracy, messaging is throttled.
""";

/// YouTube Player State
class YouTubePlayerState {
  final bool isPlayerReady;
  final bool embedErrorDetected;

  const YouTubePlayerState({
    this.isPlayerReady = false,
    this.embedErrorDetected = false,
  });

  YouTubePlayerState copyWith({bool? isPlayerReady, bool? embedErrorDetected}) {
    return YouTubePlayerState(
      isPlayerReady: isPlayerReady ?? this.isPlayerReady,
      embedErrorDetected: embedErrorDetected ?? this.embedErrorDetected,
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

/// Provider for managing the WebViewController for a video
final youtubeControllerProvider = Provider.autoDispose.family<WebViewController, String>((
  ref,
  videoId,
) {
  final controller = WebViewController();

  controller
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0xFF000000))
    ..enableZoom(false)
    ..setUserAgent(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.6312.122 Safari/537.36",
    )
    ..setNavigationDelegate(
      NavigationDelegate(
        onPageFinished: (String url) {
          controller.runJavaScript(_cleanPlayerJs + _progressTrackerJs);
        },
        onNavigationRequest: (NavigationRequest request) {
          final url = request.url;
          if (url.contains('youtube.com/watch') || url.contains('youtu.be/')) {
            return NavigationDecision.prevent;
          }
          final state = ref.read(youtubePlayerProvider(videoId));
          if (state.embedErrorDetected &&
              (url.startsWith('http') || url.contains('youtube.com'))) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..addJavaScriptChannel(
      'PlayerStatusChannel',
      onMessageReceived: (JavaScriptMessage message) {
        final msg = message.message;
        if (msg == 'ready') {
          ref.read(youtubePlayerProvider(videoId).notifier).setPlayerReady();
        } else if (msg == 'embed_error') {
          ref.read(youtubePlayerProvider(videoId).notifier).setEmbedError();
        } else if (msg.startsWith('progress:')) {
          try {
            final parts = msg.split(':');
            if (parts.length >= 3) {
              final double position = double.parse(parts[1]);
              final double watched = double.parse(parts[2]);
              // Update progress provider
              ref.read(youtubeProgressProvider(videoId).notifier).state = (
                position,
                watched,
              );
            }
          } catch (e) {}
        }
      },
    );

  final String embedUrl =
      'https://www.youtube-nocookie.com/embed/$videoId?autoplay=1&playsinline=1&modestbranding=1&iv_load_policy=3&fs=1&rel=0&origin=https://www.google.com';

  final Map<String, String> headers = {
    'User-Agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.6312.122 Safari/537.36',
    'Referer': 'https://www.google.com/',
  };

  controller.loadRequest(Uri.parse(embedUrl), headers: headers);

  return controller;
});

/// YouTube Player Widget - View Only (No Download)
class YouTubePlayerWidget extends ConsumerWidget {
  final String videoUrl;
  final Function(double position, double watched)?
  onProgress; // Callback with (pos, watched)

  const YouTubePlayerWidget({
    super.key,
    required this.videoUrl,
    this.onProgress,
  });

  /// Extract YouTube video ID
  static String? _extractVideoId(String url) {
    final RegExp regExp = RegExp(
      r'(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/\s]{11})',
    );
    final match = regExp.firstMatch(url);
    return match?.group(1);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoId = _extractVideoId(videoUrl);

    if (videoId == null) {
      return const Center(
        child: Text('Invalid Video URL', style: TextStyle(color: Colors.white)),
      );
    }

    // Listen to progress updates
    if (onProgress != null) {
      ref.listen(youtubeProgressProvider(videoId), (previous, next) {
        onProgress!(next.$1, next.$2);
      });
    }

    final webViewController = ref.watch(youtubeControllerProvider(videoId));
    final playerState = ref.watch(youtubePlayerProvider(videoId));

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

    return Stack(
      children: [
        WebViewWidget(controller: webViewController),
        if (!playerState.isPlayerReady)
          Container(
            color: Colors.black,
            child: const AppLoadingIndicator(color: Colors.white, size: 40),
          ),
      ],
    );
  }
}
