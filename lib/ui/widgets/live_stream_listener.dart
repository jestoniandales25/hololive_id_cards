import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

import '../../blocs/hololive/hololive_bloc.dart';
import '../../blocs/hololive/hololive_event.dart';
import '../../blocs/hololive/hololive_state.dart';
import '../../data/models/video_model.dart';

class LiveStreamListener extends StatefulWidget {
  final Widget child;

  const LiveStreamListener({super.key, required this.child});

  @override
  State<LiveStreamListener> createState() => _LiveStreamListenerState();
}

class _LiveStreamListenerState extends State<LiveStreamListener> {
  Timer? _pollingTimer;
  final Set<String> _notifiedVideoIds = {};

  @override
  void initState() {
    super.initState();
    // Fetch live streams immediately upon loading app
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HololiveBloc>().add(FetchLiveVideosEvent());
    });
    // Poll for live streams every 60 seconds universally
    _pollingTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      if (mounted) {
        context.read<HololiveBloc>().add(FetchLiveVideosEvent());
      }
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HololiveBloc, HololiveState>(
      listenWhen: (previous, current) =>
          previous.liveVideosStatus != current.liveVideosStatus &&
          current.liveVideosStatus == HololiveStatus.success,
      listener: (context, state) {
        if (state.liveVideos.isEmpty) return;

        // Find new live videos that haven't been notified yet
        final newActiveVideos = state.liveVideos.where((v) {
          final isLiveOnly = v.isLive;
          final isNew = !_notifiedVideoIds.contains(v.id);
          return isLiveOnly && isNew;
        }).toList();

        if (newActiveVideos.isEmpty) return;

        // Mark all as notified
        for (final video in newActiveVideos) {
          _notifiedVideoIds.add(video.id);
        }

        if (newActiveVideos.length == 1) {
          final video = newActiveVideos.first;
          toastification.show(
            context: context,
            type: video.isLive ? ToastificationType.error : ToastificationType.info,
            style: ToastificationStyle.flat,
            title: Text(
              video.isLive ? 'LIVE NOW' : 'Upcoming Stream',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            description: Text(
              video.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white70),
            ),
            alignment: Alignment.topCenter,
            autoCloseDuration: const Duration(seconds: 5),
            icon: Icon(
              video.isLive ? Icons.stream_rounded : Icons.schedule_rounded,
              color: video.isLive ? Colors.redAccent : const Color(0xFF00ADB5),
            ),
            showProgressBar: false,
            primaryColor: video.isLive ? Colors.redAccent : const Color(0xFF00ADB5),
            backgroundColor: const Color(0xFF1A1A2E),
            foregroundColor: Colors.white,
          );
        } else {
          // Aggregate toast
          final liveCount = newActiveVideos.where((v) => v.isLive).length;
          final upcomingCount = newActiveVideos.length - liveCount;

          String title = 'Hololive Streams';
          String desc = '';
          IconData iconData = Icons.stream_rounded;
          Color pColor = const Color(0xFF00ADB5);
          ToastificationType tType = ToastificationType.info;

          if (liveCount > 0 && upcomingCount > 0) {
            desc = '$liveCount members Live Now, $upcomingCount Upcoming';
            title = 'Updates Available';
            pColor = Colors.redAccent;
            tType = ToastificationType.error;
          } else if (liveCount > 0) {
            desc = '$liveCount members are Live Now!';
            title = 'LIVE NOW';
            pColor = Colors.redAccent;
            tType = ToastificationType.error;
          } else {
            desc = '$upcomingCount new Upcoming Streams!';
            title = 'Upcoming Streams';
            iconData = Icons.schedule_rounded;
          }

          toastification.show(
            context: context,
            type: tType,
            style: ToastificationStyle.flat,
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            description: Text(
              desc,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white70),
            ),
            alignment: Alignment.topCenter,
            autoCloseDuration: const Duration(seconds: 5),
            icon: Icon(iconData, color: pColor),
            showProgressBar: false,
            primaryColor: pColor,
            backgroundColor: const Color(0xFF1A1A2E),
            foregroundColor: Colors.white,
          );
        }
      },
      child: widget.child, // Pass down the child
    );
  }
}
