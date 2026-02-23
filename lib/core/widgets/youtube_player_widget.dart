import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:sparkbit/core/widgets/app_loading_indicator.dart';

/// JS constants for the player
const String _cleanPlayerJs = """
   // ===== 1. PLATFORM SPOOFING (Desktop User Agent) =====
   try {
     Object.defineProperty(navigator, 'platform', {get: function(){return 'Win32';}});
     Object.defineProperty(navigator, 'maxTouchPoints', {get: function(){return 0;}}); 
     Object.defineProperty(navigator, 'vendor', {get: function(){return 'Google Inc.';}});
   } catch(e) {}

   // ===== 2. BLOCK CLIPBOARD / SHARE / WINDOW.OPEN =====
   try {
     // Block clipboard API (prevents copy link)
     if (navigator.clipboard) {
       Object.defineProperty(navigator, 'clipboard', {
         get: function() {
           return {
             writeText: function() { return Promise.reject('blocked'); },
             write: function() { return Promise.reject('blocked'); },
             readText: function() { return Promise.resolve(''); },
             read: function() { return Promise.resolve([]); }
           };
         }
       });
     }
     // Block Web Share API
     if (navigator.share) {
       navigator.share = function() { return Promise.reject('blocked'); };
     }
     if (navigator.canShare) {
       navigator.canShare = function() { return false; };
     }
     // Block window.open (prevent opening video in browser)
     window.open = function() { return null; };
   } catch(e) {}

   // ===== 3. BLOCK CONTEXT MENU / TEXT SELECTION / DRAG =====
   document.addEventListener('contextmenu', function(e) { e.preventDefault(); e.stopPropagation(); return false; }, true);
   document.addEventListener('selectstart', function(e) { e.preventDefault(); return false; }, true);
   document.addEventListener('dragstart', function(e) { e.preventDefault(); return false; }, true);
   document.addEventListener('copy', function(e) { e.preventDefault(); return false; }, true);
   document.addEventListener('cut', function(e) { e.preventDefault(); return false; }, true);

   // ===== 4. CSS: HIDE ALL YOUTUBE UI THAT COULD EXPOSE VIDEO INFO =====
   function cleanPlayer() {
     const css = `
       /* Hide share, watch later, copy link, info, overlays */
       .ytp-chrome-top, .ytp-youtube-button, .ytp-impression-link, .iv-branding,
       .ytp-endscreen, .ytp-endscreen-content, .ytp-pause-overlay, .ytp-watermark,
       .ytp-contextmenu, .ytp-next-button, .ytp-prev-button,
       .ytp-share-button, .ytp-copylink-button, .ytp-watch-later-button,
       .ytp-title, .ytp-title-link, .ytp-chrome-top-buttons,
       .ytp-overflow-menu-item[data-title-no-tooltip="Copy link"],
       .ytp-overflow-menu-item[data-title-no-tooltip="Share"],
       .ytp-button[data-tooltip-target-id="ytp-autonav-toggle-button"],
       .ytp-paid-content-overlay, .ytp-ce-element, .ytp-cards-button,
       .ytp-cards-teaser, .annotation {
         display: none !important; visibility: hidden !important;
         pointer-events: none !important; opacity: 0 !important;
       }
       /* Disable text selection globally */
       * {
         -webkit-user-select: none !important;
         -moz-user-select: none !important;
         -ms-user-select: none !important;
         user-select: none !important;
         -webkit-touch-callout: none !important;
       }
     `;
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

   // ===== 5. BLOCK ALL LINKS + DETECT EMBED ERRORS =====
   function detectEmbedError(){
     try{
       const text = (document.body && document.body.innerText) ? document.body.innerText : '';
       if(text.indexOf('Error 153') !== -1 || text.indexOf('Video player configuration error') !== -1){
         PlayerStatusChannel.postMessage('embed_error');
       }
       // Block ALL anchor clicks and remove href
       document.querySelectorAll('a').forEach(a=>{
         if(!a.__blocked_by_flutter){
           a.__blocked_by_flutter = true;
           a.addEventListener('click', function(e){ e.preventDefault(); e.stopPropagation(); PlayerStatusChannel.postMessage('blocked_link:'+this.href); }, {passive:false, capture:true});
           a.addEventListener('touchend', function(e){ e.preventDefault(); e.stopPropagation(); }, {passive:false, capture:true});
           a.setAttribute('target','_self');
           a.removeAttribute('href');
         }
       });
       // Also block iframes trying to open new windows
       document.querySelectorAll('iframe').forEach(f=>{
         try { f.setAttribute('sandbox','allow-scripts allow-same-origin'); } catch(e){}
       });
     }catch(e){}
   }
   setInterval(detectEmbedError, 1000);
   detectEmbedError();
   PlayerStatusChannel.postMessage('ready');
   
   // ===== 6. FULLSCREEN DETECTION =====
   document.addEventListener('fullscreenchange', function() {
     if (document.fullscreenElement) {
       FullscreenChannel.postMessage('enter_fullscreen');
     } else {
       FullscreenChannel.postMessage('exit_fullscreen');
     }
   });
   document.addEventListener('webkitfullscreenchange', function() {
     if (document.webkitFullscreenElement) {
       FullscreenChannel.postMessage('enter_fullscreen');
     } else {
       FullscreenChannel.postMessage('exit_fullscreen');
     }
   });
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

          // Allow only the initial embed URL to load
          if (url.contains('youtube-nocookie.com/embed/') ||
              url.contains('youtube.com/embed/') ||
              url.startsWith('about:blank')) {
            return NavigationDecision.navigate;
          }

          // Block everything else: watch pages, share links, channel pages, etc.
          return NavigationDecision.prevent;
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
    )
    ..addJavaScriptChannel(
      'FullscreenChannel',
      onMessageReceived: (JavaScriptMessage message) {
        final msg = message.message;
        if (msg == 'enter_fullscreen') {
          ref.read(youtubePlayerProvider(videoId).notifier).setFullscreen(true);
        } else if (msg == 'exit_fullscreen') {
          ref
              .read(youtubePlayerProvider(videoId).notifier)
              .setFullscreen(false);
        }
      },
    );

  final String embedUrl =
      'https://www.youtube-nocookie.com/embed/$videoId?autoplay=1&modestbranding=1&iv_load_policy=3&fs=1&rel=0&origin=https://www.google.com';

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

    // Listen to fullscreen changes → force orientation
    ref.listen(youtubePlayerProvider(videoId), (previous, next) {
      if (previous != null && previous.isFullscreen != next.isFullscreen) {
        if (next.isFullscreen) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
        } else {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
        }
      }
    });

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
