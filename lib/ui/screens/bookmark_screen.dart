import 'package:flutter/material.dart';
import 'package:hololive_id_cards/blocs/bookmark_bloc_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/video_model.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(8, 12, 20, 12),
              decoration: const BoxDecoration(
                color: Color(0xFF1A1A2E),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 4),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bookmarks',
                          style: TextStyle(
                            color: Color(0xFF00ADB5),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Your saved videos',
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Bookmarks List ───────────────────────
            Expanded(
              child: Consumer<BookmarkBlocProvider>(
                builder: (context, bloc, _) {
                  final bookmarks = bloc.allBookmarks;

                  if (bookmarks.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bookmark_border_rounded,
                            color: Colors.white24,
                            size: 64,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No bookmarks yet',
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tap the bookmark icon on any video\nto save it here',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white24,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: bookmarks.length,
                    itemBuilder: (_, index) =>
                        _BookmarkCard(video: bookmarks[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookmarkCard extends StatelessWidget {
  final VideoModel video;

  const _BookmarkCard({required this.video});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF00ADB5).withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          // ── Thumbnail ──────────────────────────────
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(12)),
                child: Image.network(
                  video.thumbnailUrl,
                  width: 120,
                  height: 72,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 120,
                    height: 72,
                    color: const Color(0xFF0D0D0D),
                    child: const Icon(Icons.video_library_rounded,
                        color: Colors.white24),
                  ),
                ),
              ),
              if (video.isLive)
                Positioned(
                  top: 4,
                  left: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'LIVE',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              if (video.formattedDuration.isNotEmpty)
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      video.formattedDuration,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 9),
                    ),
                  ),
                ),
            ],
          ),

          // ── Info ───────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      // Watch button
                      GestureDetector(
                        onTap: () async {
                          final url = Uri.parse(video.youtubeUrl);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(
                              url,
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.play_arrow_rounded,
                                color: Color(0xFF00ADB5), size: 14),
                            SizedBox(width: 4),
                            Text(
                              'Watch',
                              style: TextStyle(
                                color: Color(0xFF00ADB5),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Remove bookmark
                      GestureDetector(
                        onTap: () {
                          // Find which channel this video belongs to
                          final bloc = context.read<BookmarkBlocProvider>();
                          for (final entry in bloc.bookmarks.entries) {
                            if (entry.value.any((v) => v.id == video.id)) {
                              bloc.toggleBookmark(entry.key, video);
                              break;
                            }
                          }
                        },
                        child: const Icon(
                          Icons.bookmark_rounded,
                          color: Color(0xFF00ADB5),
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}