import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../blocs/hololive/hololive_bloc.dart';
import '../../../../blocs/hololive/hololive_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/member_model.dart';
import '../../../widgets/skeleton_loading.dart';
import 'video_card.dart';

class VideosPanel extends StatelessWidget {
  final MemberModel member;

  const VideosPanel({super.key, required this.member});

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
                    color: AppColors.primary,
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
              child: state.videosStatus == HololiveStatus.loading ||
                      state.videosStatus == HololiveStatus.idle
                  ? const SkeletonVideoList()
                  : state.videos.isEmpty
                      ? const Center(
                          child: Text(
                            'No videos found.',
                            style: TextStyle(color: AppColors.textMuted),
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
                          itemBuilder: (_, index) => VideoCard(
                            video: state.videos[index],
                            member: member,
                          ),
                        ),
            ),
          ],
        );
      },
    );
  }
}
