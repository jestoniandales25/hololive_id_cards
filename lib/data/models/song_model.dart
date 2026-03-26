class SongModel {
  final int trackId;
  final String trackName;
  final String artistName;
  final String collectionName;
  final String artworkUrl;
  final String? previewUrl;
  final String trackViewUrl;
  final DateTime releaseDate;
  final String genre;
  final int durationMs;

  SongModel({
    required this.trackId,
    required this.trackName,
    required this.artistName,
    required this.collectionName,
    required this.artworkUrl,
    this.previewUrl,
    required this.trackViewUrl,
    required this.releaseDate,
    required this.genre,
    required this.durationMs,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    // Upscale artwork from 100x100 to 500x500 for better quality
    final rawArtwork = json['artworkUrl100'] as String? ?? '';
    final artworkUrl = rawArtwork.replaceAll('100x100bb', '500x500bb');

    return SongModel(
      trackId: json['trackId'] as int? ?? 0,
      trackName: json['trackName'] as String? ?? 'Unknown Title',
      artistName: json['artistName'] as String? ?? 'Unknown Artist',
      collectionName: json['collectionName'] as String? ?? '',
      artworkUrl: artworkUrl,
      previewUrl: json['previewUrl'] as String?,
      trackViewUrl: json['trackViewUrl'] as String? ?? '',
      releaseDate: DateTime.tryParse(json['releaseDate'] as String? ?? '') ??
          DateTime(2000),
      genre: json['primaryGenreName'] as String? ?? '',
      durationMs: json['trackTimeMillis'] as int? ?? 0,
    );
  }

  /// Returns formatted duration string like "3:07"
  String get formattedDuration {
    if (durationMs == 0) return '';
    final total = Duration(milliseconds: durationMs);
    final minutes = total.inMinutes;
    final seconds = (total.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// Returns just the year of release
  String get releaseYear => releaseDate.year.toString();
}
