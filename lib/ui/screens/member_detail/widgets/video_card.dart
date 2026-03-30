import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../blocs/bookmark/bookmark_bloc.dart';
import '../../../../blocs/bookmark/bookmark_event.dart';
import '../../../../blocs/bookmark/bookmark_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/member_model.dart';
import '../../../../data/models/video_model.dart';

class VideoCard extends StatelessWidget {
  final VideoModel video;
  final MemberModel member;

  const VideoCard({
    super.key,
    required this.video,
    required this.member,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/video-player', arguments: video),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Thumbnail
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(12),
                  ),
                  child: Image.network(
                    video.thumbnailUrl,
                    width: 120,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      width: 120,
                      height: 72,
                      color: AppColors.background,
                      child: const Icon(
                        Icons.video_library_rounded,
                        color: Colors.white24,
                      ),
                    ),
                  ),
                ),
                if (video.isLive)
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (video.formattedDuration.isNotEmpty)
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        video.formattedDuration,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Info + Bookmark
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
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

                    // Watch + Bookmark row
                    Row(
                      children: [
                        // Watch label
                        const Icon(
                          Icons.play_arrow_rounded,
                          color: AppColors.primary,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          video.isUpcoming ? 'Upcoming' : 'Watch',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 11,
                          ),
                        ),

                        const Spacer(),

                        // Bookmark icon toggle
                        BlocBuilder<BookmarkBloc, BookmarkState>(
                          builder: (context, state) {
                            final isBookmarked = state.isBookmarked(
                              video.id,
                            );
                            return GestureDetector(
                              onTap: () => context.read<BookmarkBloc>().add(
                                    ToggleBookmarkEvent(member.id, video),
                                  ),
                              child: Icon(
                                isBookmarked
                                    ? Icons.bookmark_rounded
                                    : Icons.bookmark_border_rounded,
                                color: isBookmarked
                                    ? AppColors.primary
                                    : AppColors.textMuted,
                                size: 18,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
