import 'package:flutter/material.dart';
import '../models/character_model.dart';
import '../widgets/character_card.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Character List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const CharacterListScreen(),
    );
  }
}

class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({super.key});

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  final List<CharacterModel> _characters = [
    CharacterModel(
      id: '1',
      name: 'Aric Stormbane',
      role: 'Hero',
      imageUrl: 'https://picsum.photos/seed/warrior1/600/400',
    ),
    CharacterModel(
      id: '2',
      name: 'Seraphina Vale',
      role: 'Mage',
      imageUrl: 'https://picsum.photos/seed/mage2/600/400',
    ),
    CharacterModel(
      id: '3',
      name: 'Dusk Revenant',
      role: 'Villain',
      imageUrl: 'https://picsum.photos/seed/villain3/600/400',
    ),
    CharacterModel(
      id: '4',
      name: 'Lyra Swiftwind',
      role: 'Scout',
      imageUrl: 'https://picsum.photos/seed/scout4/600/400',
    ),
    CharacterModel(
      id: '5',
      name: 'Gorrath the Bold',
      role: 'Tank',
      imageUrl: 'https://picsum.photos/seed/tank5/600/400',
    ),
    CharacterModel(
      id: '6',
      name: 'Ember Ashcroft',
      role: 'Support',
      imageUrl: 'https://picsum.photos/seed/support6/600/400',
    ),
  ];

  void _onTap(CharacterModel character) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(character.name),
        content: Text('${character.role} — tap to view full profile.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Characters',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: [IconButton(icon: const Icon(Icons.tune), onPressed: () {})],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        itemCount: _characters.length,
        itemBuilder: (context, index) {
          final character = _characters[index];
          return CharacterCard(
            character: character,
            onTap: () => _onTap(character),
            onFavoriteToggled: (isFav) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isFav
                        ? '${character.name} bookmarked!'
                        : '${character.name} removed from bookmarks.',
                  ),
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
