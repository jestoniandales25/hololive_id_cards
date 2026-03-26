import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hololive_id_cards/blocs/hololive/hololive_bloc.dart';
import 'package:hololive_id_cards/blocs/hololive/hololive_event.dart';
import 'package:hololive_id_cards/blocs/hololive/hololive_state.dart';
import 'package:hololive_id_cards/data/models/member_model.dart';
import 'package:hololive_id_cards/data/models/song_model.dart';

class MemberSongsScreen extends StatelessWidget {
  const MemberSongsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final member = ModalRoute.of(context)!.settings.arguments as MemberModel;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Column(
        children: [
          // ── Header ────────────────────────────────────
          Container(
            color: const Color(0xFF1A1A2E),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 16, 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    // Avatar
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: const Color(0xFF00ADB5),
                      child: ClipOval(
                        child: Image.network(
                          member.avatarUrl,
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Text(
                            member.displayName[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member.displayName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Text(
                            'Songs & Music · iTunes',
                            style: TextStyle(
                              color: Color(0xFF00ADB5),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Retry button
                    BlocBuilder<HololiveBloc, HololiveState>(
                      builder: (context, state) {
                        if (state.itunesSongsStatus == HololiveStatus.error) {
                          return IconButton(
                            icon: const Icon(Icons.refresh, color: Colors.white54),
                            onPressed: () {
                              final name = member.englishName ?? member.displayName;
                              context.read<HololiveBloc>().add(FetchItunesSongsEvent(name));
                            },
                          );
                        }
                        return const Icon(
                          Icons.music_note_rounded,
                          color: Color(0xFF00ADB5),
                          size: 22,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Songs List ────────────────────────────────
          Expanded(
            child: BlocBuilder<HololiveBloc, HololiveState>(
              builder: (context, state) {
                // Loading
                if (state.itunesSongsStatus == HololiveStatus.loading ||
                    state.itunesSongsStatus == HololiveStatus.idle) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Color(0xFF00ADB5),
                          strokeWidth: 2.5,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Fetching songs from iTunes...',
                          style: TextStyle(color: Colors.white54, fontSize: 13),
                        ),
                      ],
                    ),
                  );
                }

                // Error
                if (state.itunesSongsStatus == HololiveStatus.error) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
                        const SizedBox(height: 12),
                        Text(
                          state.itunesSongsError ?? 'Failed to load songs.',
                          style: const TextStyle(color: Colors.white54),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            final name = member.englishName ?? member.displayName;
                            context.read<HololiveBloc>().add(FetchItunesSongsEvent(name));
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00ADB5),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Empty
                if (state.itunesSongs.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.music_off_rounded, color: Colors.white24, size: 48),
                        SizedBox(height: 12),
                        Text(
                          'No songs found on iTunes.',
                          style: TextStyle(color: Colors.white38),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Official music releases may not be available yet.',
                          style: TextStyle(color: Colors.white24, fontSize: 11),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                // Songs list
                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(
                    12,
                    12,
                    12,
                    MediaQuery.of(context).padding.bottom + 20,
                  ),
                  itemCount: state.itunesSongs.length,
                  itemBuilder: (_, index) => _ItunesSongCard(
                    song: state.itunesSongs[index],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── iTunes Song Card ───────────────────────────────────
class _ItunesSongCard extends StatelessWidget {
  final SongModel song;

  const _ItunesSongCard({required this.song});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/song-player',
        arguments: song,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF00ADB5).withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            // ── Album Art ──────────────────────────────
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(12),
                  ),
                  child: Image.network(
                    song.artworkUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      width: 80,
                      height: 80,
                      color: const Color(0xFF0D0D0D),
                      child: const Icon(
                        Icons.music_note_rounded,
                        color: Colors.white24,
                      ),
                    ),
                  ),
                ),
                // Duration badge
                if (song.formattedDuration.isNotEmpty)
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
                        song.formattedDuration,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // ── Song Info ───────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.trackName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      song.artistName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${song.collectionName.replaceAll(' - Single', '').replaceAll(' - EP', '')} · ${song.releaseYear}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00ADB5).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: const Color(0xFF00ADB5).withOpacity(0.4),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.headphones_rounded,
                                color: Color(0xFF00ADB5),
                                size: 10,
                              ),
                              const SizedBox(width: 3),
                              const Text(
                                'Apple Music',
                                style: TextStyle(
                                  color: Color(0xFF00ADB5),
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Genre chip
                        if (song.genre.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              song.genre,
                              style: const TextStyle(
                                color: Colors.white38,
                                fontSize: 9,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Arrow
            const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white24,
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
