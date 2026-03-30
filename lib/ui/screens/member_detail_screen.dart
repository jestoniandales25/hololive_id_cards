import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/member_model.dart';
import 'member_detail/widgets/member_info_panel.dart';
import 'member_detail/widgets/videos_panel.dart';

class HololiveDetailScreen extends StatelessWidget {
  const HololiveDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final member = ModalRoute.of(context)!.settings.arguments as MemberModel;

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
