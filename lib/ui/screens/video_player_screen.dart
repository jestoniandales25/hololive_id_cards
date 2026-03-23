import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../data/models/video_model.dart';

class VideoPlayerScreen extends StatefulWidget {
  final VideoModel video;

  const VideoPlayerScreen({super.key, required this.video});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  void _initPlayer() {
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.video.id,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        mute: false,
        loop: false,
        strictRelatedVideos: true,
        origin: 'https://www.youtube-nocookie.com',
      ),
    );
  
    // ✅ Auto open YouTube app if video is unplayable
    _controller.listen((value) async {
      if (value.playerState == PlayerState.unknown) {
        final url = Uri.parse(widget.video.youtubeUrl);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
          if (mounted) Navigator.pop(context);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.close();          // ✅ always close the controller
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
      controller: _controller,
      // ✅ YoutubePlayerScaffold handles fullscreen automatically
      builder: (context, player) {
        return Scaffold(
          backgroundColor: const Color(0xFF0D0D0D),
          body: SafeArea(
            child: Column(
              children: [

                // ── Top Bar ───────────────────────────
                Container(
                  color: const Color(0xFF1A1A2E),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      // Back button
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      // Title
                      Expanded(
                        child: Text(
                          widget.video.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── YouTube Player ─────────────────────
                // ✅ player fills 16:9 ratio automatically
                // ✅ no scroll, no manual HTML, no JS needed
                player,

                // ── Video Info ─────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Live badge
                        if (widget.video.isLive)
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.circle,
                                    color: Colors.white, size: 8),
                                SizedBox(width: 6),
                                Text(
                                  'LIVE NOW',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Video title
                        Text(
                          widget.video.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Duration + type
                        Row(
                          children: [
                            if (widget.video.formattedDuration
                                .isNotEmpty) ...[
                              const Icon(Icons.timer_outlined,
                                  color: Colors.white38, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                widget.video.formattedDuration,
                                style: const TextStyle(
                                    color: Colors.white38,
                                    fontSize: 12),
                              ),
                              const SizedBox(width: 16),
                            ],
                            const Icon(Icons.live_tv_rounded,
                                color: Colors.white38, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              widget.video.isUpcoming
                                  ? 'Upcoming Stream'
                                  : 'Stream',
                              style: const TextStyle(
                                  color: Colors.white38, fontSize: 12),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        const Divider(color: Color(0xFF1A1A2E)),
                        const SizedBox(height: 12),

                        // Open in YouTube button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final url =
                                  Uri.parse(widget.video.youtubeUrl);
                              if (await canLaunchUrl(url)) {
                                await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                );
                              }
                            },
                            icon: const Icon(
                                Icons.open_in_new_rounded,
                                size: 16),
                            label: const Text('Open in YouTube'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF00ADB5),
                              side: const BorderSide(
                                  color: Color(0xFF00ADB5)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}