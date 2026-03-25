import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hololive_id_cards/blocs/bookmark/bookmark_bloc.dart';
import 'package:hololive_id_cards/blocs/bookmark/bookmark_event.dart';
import 'package:hololive_id_cards/blocs/bookmark/bookmark_state.dart';
import 'package:hololive_id_cards/blocs/hololive/hololive_bloc.dart';
import 'package:hololive_id_cards/blocs/hololive/hololive_state.dart';
import 'package:hololive_id_cards/data/models/member_model.dart';
import '../../data/models/video_model.dart';
import 'package:hololive_id_cards/ui/widgets/skeleton_loading.dart';

class HololiveDetailScreen extends StatelessWidget {
  const HololiveDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final member = ModalRoute.of(context)!.settings.arguments as MemberModel;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            // ── TOP HALF: Member Info (fixed) ────────
            _MemberInfoPanel(member: member),

            // ── TAB BAR ──────────────────────────────
            const TabBar(
              indicatorColor: Color(0xFF00ADB5),
              labelColor: Color(0xFF00ADB5),
              unselectedLabelColor: Colors.white54,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              tabs: [
                Tab(text: 'Streams'),
                Tab(text: 'Songs'),
              ],
            ),

            // ── BOTTOM HALF: Tab Views (scrollable) ─────
            Expanded(
              child: TabBarView(
                children: [
                  _VideosPanel(member: member),
                  _SongsPanel(member: member),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── TOP PANEL ─────────────────────────────────────────
class _MemberInfoPanel extends StatelessWidget {
  final MemberModel member;

  const _MemberInfoPanel({required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0D0D0D),
      child: Column(
        children: [
          // Banner + back button
          Stack(
            children: [
              Container(
                height: 120,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1A1A2E), Color(0xFF00ADB5)],
                  ),
                ),
              ),
              SafeArea(
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),

          // Avatar + Info row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.translate(
                  offset: const Offset(0, -30),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF00ADB5),
                        width: 3,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: const Color(0xFF1A1A2E),
                      child: ClipOval(
                        child: Image.network(
                          member.avatarUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Text(
                            member.displayName[0].toUpperCase(),
                            style: const TextStyle(
                              color: Color(0xFF00ADB5),
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (member.name != member.displayName)
                          Text(
                            member.name,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            if (member.group != null)
                              _Badge(
                                label: member.group!,
                                color: const Color(0xFF00ADB5),
                              ),
                            const SizedBox(width: 6),
                            if (member.org != null)
                              _Badge(
                                label: member.org!,
                                color: const Color(0xFF1A1A2E),
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

          // Stats row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  icon: Icons.people_rounded,
                  label: 'Subscribers',
                  value: member.formattedSubs,
                ),
                _StatItem(
                  icon: Icons.video_library_rounded,
                  label: 'Videos',
                  value: member.videoCount?.toString() ?? 'N/A',
                ),
                _StatItem(
                  icon: Icons.info_outline_rounded,
                  label: 'Status',
                  value: member.inactive ? 'Inactive' : 'Active',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── BOTTOM PANEL ───────────────────────────────────────
class _VideosPanel extends StatelessWidget {
  final MemberModel member; // ✅ added

  const _VideosPanel({required this.member}); // ✅ added

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HololiveBloc, HololiveState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Icon(
                    Icons.play_circle_outline_rounded,
                    color: Color(0xFF00ADB5),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Recent Streams',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: state.videosStatus == HololiveStatus.loading || state.videosStatus == HololiveStatus.idle
                  ? const SkeletonVideoList()
                  : state.videos.isEmpty
                  ? const Center(
                      child: Text(
                        'No videos found.',
                        style: TextStyle(color: Colors.white38),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.fromLTRB(
                        12,
                        4,
                        12,
                        MediaQuery.of(context).padding.bottom + 20,
                      ),
                      itemCount: state.videos.length,
                      itemBuilder: (_, index) => _VideoCard(
                        video: state.videos[index],
                        member: member, // ✅ pass member to card
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _SongsPanel extends StatelessWidget {
  final MemberModel member;

  const _SongsPanel({required this.member});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HololiveBloc, HololiveState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Icon(
                    Icons.music_note_rounded,
                    color: Color(0xFF00ADB5),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Recent Songs',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: state.songsStatus == HololiveStatus.loading || state.songsStatus == HololiveStatus.idle
                  ? const SkeletonVideoList()
                  : state.songs.isEmpty
                  ? const Center(
                      child: Text(
                        'No songs found.',
                        style: TextStyle(color: Colors.white38),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.fromLTRB(
                        12,
                        4,
                        12,
                        MediaQuery.of(context).padding.bottom + 20,
                      ),
                      itemCount: state.songs.length,
                      itemBuilder: (_, index) =>
                          _VideoCard(video: state.songs[index], member: member),
                    ),
            ),
          ],
        );
      },
    );
  }
}

// ── VIDEO CARD ─────────────────────────────────────────
class _VideoCard extends StatelessWidget {
  final VideoModel video;
  final MemberModel member; // ✅ added

  const _VideoCard({
    required this.video,
    required this.member, // ✅ added
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/video-player', arguments: video),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // ── Thumbnail ──────────────────────────
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
                      color: const Color(0xFF0D0D0D),
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

            // ── Info + Bookmark ─────────────────────
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

                    // ✅ Watch + Bookmark row
                    Row(
                      children: [
                        // Watch label
                        const Icon(
                          Icons.play_arrow_rounded,
                          color: Color(0xFF00ADB5),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          video.isUpcoming ? 'Upcoming' : 'Watch',
                          style: const TextStyle(
                            color: Color(0xFF00ADB5),
                            fontSize: 11,
                          ),
                        ),

                        const Spacer(),

                        // ✅ Bookmark icon toggle
                        BlocBuilder<BookmarkBloc, BookmarkState>(
                          builder: (context, state) {
                            final isBookmarked = state.isBookmarked(
                              video.id,
                            );
                            return GestureDetector(
                              onTap: () => context.read<BookmarkBloc>().add(ToggleBookmarkEvent(member.id, video)),
                              child: Icon(
                                isBookmarked
                                    ? Icons.bookmark_rounded
                                    : Icons.bookmark_border_rounded,
                                color: isBookmarked
                                    ? const Color(0xFF00ADB5)
                                    : Colors.white38,
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

// ── HELPERS ────────────────────────────────────────────
class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.6)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF00ADB5), size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white38, fontSize: 10),
        ),
      ],
    );
  }
}
