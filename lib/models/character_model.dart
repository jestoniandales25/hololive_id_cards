class CharacterModel {
  final String id;
  final String name;
  final String imageUrl;
  final String role; // e.g., 'Hero', 'Villain', 'Support'
  bool isFavorite;

  CharacterModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.role,
    this.isFavorite = false,
  });
}
