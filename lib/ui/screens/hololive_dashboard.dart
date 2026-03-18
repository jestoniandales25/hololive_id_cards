import 'package:flutter/material.dart';
import 'package:hololive_id_cards/blocs/hololive_bloc_provider.dart';
import 'package:hololive_id_cards/data/models/member_model.dart';
import 'package:provider/provider.dart';

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
                'Hololive',
                style: TextStyle(
                  color: Color(0xFF00ADB5),
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              Consumer<HololiveBlocProvider>(
                builder: (_, bloc, __) => Text(
                  '${bloc.members.length} talents',
                  style: const TextStyle(color: Colors.white38, fontSize: 13),
                ),
              ),
            ],
          ),
          Consumer<HololiveBlocProvider>(
            builder: (_, bloc, __) => GestureDetector(
              onTap: bloc.refresh,
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
    );
  }

  // ── Body ────────────────────────────────────────────
  Widget _buildBody() {
    return Consumer<HololiveBlocProvider>(
      builder: (context, bloc, _) {
        // Loading
        if (bloc.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF00ADB5)),
          );
        }

        // Error
        if (bloc.state == BlocState.error) {
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
                  bloc.error ?? 'Something went wrong',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: bloc.refresh,
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
        if (bloc.members.isEmpty) {
          return const Center(
            child: Text(
              'No members found.',
              style: TextStyle(color: Colors.white54),
            ),
          );
        }

        // 2-column playing card grid
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 cards per row
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.62, // portrait card ratio
          ),
          itemCount: bloc.members.length,
          itemBuilder: (_, index) => _MemberCard(member: bloc.members[index]),
        );
      },
    );
  }
}

// ── Playing Card ────────────────────────────────────────
class _MemberCard extends StatelessWidget {
  final MemberModel member;

  const _MemberCard({required this.member});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<HololiveBlocProvider>().loadVideos(member.id);
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
            // ── Card Top: Avatar fills most of card ──
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Avatar image fills top
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      member.avatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
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

                  // Gradient fade at bottom of image
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

                  // Group badge top-left
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

                  // Active dot top-right
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

            // ── Card Bottom: Info ─────────────────────
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Name
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

                    // JP name
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

                    // Subscriber count
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
