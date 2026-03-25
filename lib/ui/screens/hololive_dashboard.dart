import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hololive_id_cards/blocs/bookmark/bookmark_bloc.dart';
import 'package:hololive_id_cards/blocs/bookmark/bookmark_state.dart';
import 'package:hololive_id_cards/blocs/hololive/hololive_bloc.dart';
import 'package:hololive_id_cards/blocs/hololive/hololive_event.dart';
import 'package:hololive_id_cards/blocs/hololive/hololive_state.dart';
import 'package:hololive_id_cards/data/models/member_model.dart';
import 'package:hololive_id_cards/ui/widgets/skeleton_loading.dart';

class HololiveDashboard extends StatelessWidget {
  const HololiveDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A2E),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'hololive',
                style: TextStyle(
                  color: Color(0xFF00ADB5),
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              BlocBuilder<HololiveBloc, HololiveState>(
                builder: (context, state) => Text(
                  state.membersStatus == HololiveStatus.loading
                      ? 'Loading...'
                      : '${state.members.length} talents',
                  style: const TextStyle(color: Colors.white38, fontSize: 13),
                ),
              ),
            ],
          ),
          Row(
            children: [
              // Bookmark button
              BlocBuilder<BookmarkBloc, BookmarkState>(
                builder: (context, state) => GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/bookmarks'),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00ADB5).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF00ADB5).withOpacity(0.4),
                      ),
                    ),
                    child: Stack(
                      children: [
                        const Icon(
                          Icons.bookmark_rounded,
                          color: Color(0xFF00ADB5),
                          size: 20,
                        ),
                        if (state.allBookmarks.isNotEmpty)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Refresh button
              BlocBuilder<HololiveBloc, HololiveState>(
                builder: (context, state) => GestureDetector(
                  onTap: () => context.read<HololiveBloc>().add(RefreshEvent()),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00ADB5).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF00ADB5).withOpacity(0.4),
                      ),
                    ),
                    child: const Icon(
                      Icons.refresh_rounded,
                      color: Color(0xFF00ADB5),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Body ────────────────────────────────────────────
  Widget _buildBody() {
    return BlocBuilder<HololiveBloc, HololiveState>(
      builder: (context, state) {
        // ✅ Skeleton loading
        if (state.membersStatus == HololiveStatus.loading ||
            state.membersStatus == HololiveStatus.idle) {
          return const SkeletonMemberGrid();
        }

        // Error
        if (state.membersStatus == HololiveStatus.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.redAccent,
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  state.membersError ?? 'Something went wrong',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () =>
                      context.read<HololiveBloc>().add(RefreshEvent()),
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
        if (state.members.isEmpty) {
          return const Center(
            child: Text(
              'No members found.',
              style: TextStyle(color: Colors.white54),
            ),
          );
        }

        // ✅ Real card grid
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.62,
          ),
          itemCount: state.members.length,
          itemBuilder: (_, index) => _MemberCard(member: state.members[index]),
        );
      },
    );
  }
}

// ── Member Card ─────────────────────────────────────────
class _MemberCard extends StatelessWidget {
  final MemberModel member;

  const _MemberCard({required this.member});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final bloc = context.read<HololiveBloc>();
        bloc.add(FetchVideosEvent(member.id));
        bloc.add(FetchSongsEvent(member.id));
        Navigator.pushNamed(context, '/member-detail', arguments: member);
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00ADB5).withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: const Color(0xFF00ADB5).withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            // ── Card Top: Avatar ───────────────────
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      member.avatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        color: const Color(0xFF0D0D0D),
                        child: Center(
                          child: Text(
                            member.displayName.isNotEmpty
                                ? member.displayName[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              color: Color(0xFF00ADB5),
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Gradient fade
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            const Color(0xFF1A1A2E).withOpacity(0.6),
                            const Color(0xFF1A1A2E),
                          ],
                          stops: const [0.0, 0.5, 0.8, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // Group badge
                  if (member.group != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.65),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF00ADB5).withOpacity(0.6),
                          ),
                        ),
                        child: Text(
                          member.group!,
                          style: const TextStyle(
                            color: Color(0xFF00ADB5),
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                  // Active dot
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: member.inactive
                            ? Colors.grey
                            : Colors.greenAccent,
                        boxShadow: [
                          BoxShadow(
                            color: member.inactive
                                ? Colors.grey.withOpacity(0.4)
                                : Colors.greenAccent.withOpacity(0.6),
                            blurRadius: 6,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Card Bottom: Info ──────────────────
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      member.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    if (member.englishName != null &&
                        member.name != member.displayName)
                      Text(
                        member.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 10,
                        ),
                      ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.people_rounded,
                          size: 11,
                          color: Color(0xFF00ADB5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          member.formattedSubs,
                          style: const TextStyle(
                            color: Color(0xFF00ADB5),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
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
      ),
    );
  }
}
