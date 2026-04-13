import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/member_model.dart';
import 'member_detail/widgets/member_info_panel.dart';
import 'member_detail/widgets/videos_panel.dart';

@RoutePage()
class HololiveDetailScreen extends StatelessWidget {
  final MemberModel member;
  const HololiveDetailScreen({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // TOP HALF: Member Info (fixed)
          MemberInfoPanel(member: member),

          // BOTTOM: Streams Panel (scrollable)
          Expanded(child: VideosPanel(member: member)),
        ],
      ),
    );
  }
}
