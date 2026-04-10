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
  Timer? _rotationTimer;
  ToastificationItem? _currentToast;

  /// All video IDs we've already seen and marked for display.
  final Set<String> _notifiedVideoIds = {};

  /// Queue of new videos waiting to be shown one by one.
  final List<VideoModel> _queue = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HololiveBloc>().add(FetchLiveVideosEvent());
    });
    _pollingTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      if (mounted) {
        context.read<HololiveBloc>().add(FetchLiveVideosEvent());
      }
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _rotationTimer?.cancel();
    super.dispose();
  }

  /// Dismisses any active toast and shows the next one in the queue.
  void _showNext(BuildContext context) {
    if (_queue.isEmpty) return;

    // Dismiss previous notification before showing the next
    if (_currentToast != null) {
      toastification.dismiss(_currentToast!);
      _currentToast = null;
    }

    final video = _queue.removeAt(0);
    final isLive = video.isLive;

    _currentToast = toastification.show(
      context: context,
      type: isLive ? ToastificationType.error : ToastificationType.info,
      style: ToastificationStyle.flat,
      title: Text(
        isLive ? '🔴 LIVE NOW' : '🕐 Upcoming Stream',
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
        isLive ? Icons.stream_rounded : Icons.schedule_rounded,
        color: isLive ? Colors.redAccent : const Color(0xFF00ADB5),
      ),
      showProgressBar: true,
      primaryColor: isLive ? Colors.redAccent : const Color(0xFF00ADB5),
      backgroundColor: const Color(0xFF1A1A2E),
      foregroundColor: Colors.white,
    );

    // If there are more in the queue, rotate to the next after 5 seconds
    if (_queue.isNotEmpty) {
      _rotationTimer?.cancel();
      _rotationTimer = Timer(const Duration(seconds: 5), () {
        if (mounted) _showNext(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HololiveBloc, HololiveState>(
      listenWhen: (previous, current) =>
          previous.liveVideosStatus != current.liveVideosStatus &&
          current.liveVideosStatus == HololiveStatus.success,
      listener: (context, state) {
        if (state.liveVideos.isEmpty) return;

        final newVideos = state.liveVideos.where((v) {
          return (v.isLive || v.isUpcoming) && !_notifiedVideoIds.contains(v.id);
        }).toList();

        if (newVideos.isEmpty) return;

        for (final video in newVideos) {
          _notifiedVideoIds.add(video.id);
          _queue.add(video);
        }

        // Start showing immediately (dismisses any current toast first)
        _rotationTimer?.cancel();
        _showNext(context);
      },
      child: widget.child,
    );
  }
}
