import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../blocs/hololive/hololive_bloc.dart';
import '../../../../blocs/hololive/hololive_event.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/member_model.dart';
import 'detail_components.dart';

class MemberInfoPanel extends StatelessWidget {
  final MemberModel member;

  const MemberInfoPanel({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
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
                    colors: [AppColors.cardColor, AppColors.primary],
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
                        color: AppColors.primary,
                        width: 3,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.cardColor,
                      child: ClipOval(
                        child: Image.network(
                          member.avatarUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Text(
                            member.displayName[0].toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.primary,
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
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            if (member.group != null)
                              DetailBadge(
                                label: member.group!,
                                color: AppColors.primary,
                              ),
                            const SizedBox(width: 6),
                            if (member.org != null)
                              DetailBadge(
                                label: member.org!,
                                color: AppColors.cardColor,
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

          // Songs button row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: GestureDetector(
              onTap: () {
                final searchName = member.englishName ?? member.displayName;
                context.read<HololiveBloc>().add(
                  FetchItunesSongsEvent(searchName),
                );
                Navigator.pushNamed(
                  context,
                  '/member-songs',
                  arguments: member,
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.music_note_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'View Songs & Music',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white70,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Stats row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StatItem(
                  icon: Icons.people_rounded,
                  label: 'Subscribers',
                  value: member.formattedSubs,
                ),
                StatItem(
                  icon: Icons.video_library_rounded,
                  label: 'Videos',
                  value: member.videoCount?.toString() ?? 'N/A',
                ),
                StatItem(
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
