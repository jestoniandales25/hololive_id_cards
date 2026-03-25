import 'package:equatable/equatable.dart';

abstract class HololiveEvent extends Equatable {
  const HololiveEvent();

  @override
  List<Object?> get props => [];
}

class FetchMembersEvent extends HololiveEvent {}

class FetchVideosEvent extends HololiveEvent {
  final String channelId;

  const FetchVideosEvent(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class FetchSongsEvent extends HololiveEvent {
  final String channelId;

  const FetchSongsEvent(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class RefreshEvent extends HololiveEvent {}
