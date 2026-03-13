import 'package:flutter/material.dart';
import 'package:hololive_id_cards/data/models/member_model.dart';
import 'package:provider/provider.dart';
import '../../blocs/hololive_bloc.dart';

class MembersScreen extends StatelessWidget {
  const MembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text(
          'Hololive Members',
          style: TextStyle(
            color: Color(0xFF00ADB5),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Consumer<HololiveBloc>(
            builder: (_, bloc, __) => IconButton(
              icon: const Icon(Icons.refresh, color: Color(0xFF00ADB5)),
              onPressed: bloc.retry,
            ),
          ),
        ],
      ),
      body: Consumer<HololiveBloc>(
        builder: (context, bloc, _) {
          // ── Loading ──────────────────────────────
          if (bloc.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF00ADB5),
              ),
            );
          }

          // ── Error ────────────────────────────────
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
                    onPressed: bloc.retry,
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

          // ── Empty ────────────────────────────────
          if (bloc.members.isEmpty) {
            return const Center(
              child: Text(
                'No members found.',
                style: TextStyle(color: Colors.white54),
              ),
            );
          }

          // ── List ─────────────────────────────────
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: bloc.members.length,
            separatorBuilder: (_, __) => const Divider(
              color: Color(0xFF1A1A2E),
              height: 1,
            ),
            itemBuilder: (_, index) =>
                _MemberTile(member: bloc.members[index]),
          );
        },
      ),
    );
  }
}

class _MemberTile extends StatelessWidget {
  final MemberModel member;

  const _MemberTile({required this.member});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

      // ── Avatar ───────────────────────────────────
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: const Color(0xFF1A1A2E),
        child: ClipOval(
          child: Image.network(
            member.avatarUrl,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Center(
              child: Text(
                member.displayName.isNotEmpty
                    ? member.displayName[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  color: Color(0xFF00ADB5),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ),

      // ── Name & Group ─────────────────────────────
      title: Text(
        member.displayName,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (member.englishName != null && member.englishName != member.name)
            Text(
              member.name,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          if (member.group != null)
            Text(
              member.group!,
              style: const TextStyle(
                color: Color(0xFF00ADB5),
                fontSize: 11,
              ),
            ),
        ],
      ),

      // ── Subscribers ──────────────────────────────
      trailing: Text(
        member.formattedSubs,
        style: const TextStyle(
          color: Colors.white60,
          fontSize: 12,
        ),
      ),
    );
  }
}