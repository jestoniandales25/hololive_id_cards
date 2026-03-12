class HololiveModel {
  final String id;
  final String imageUrl;
  final String name;
  final String jpName;
  final String debutDate;
  final String height;
  final String birthday;
  final String fanBaseName;
  final String languageSpoken;
  final int generation;
  final String youtubeChannel;
  final String twitter;

  HololiveModel({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.jpName,
    required this.debutDate,
    required this.height,
    required this.birthday,
    required this.fanBaseName,
    required this.youtubeChannel,
    required this.twitter,
    required this.generation,
    required this.languageSpoken,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HololiveModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
