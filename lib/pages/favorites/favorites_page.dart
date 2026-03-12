import 'package:flutter/material.dart';
import 'package:hololive_id_cards/providers/hololive_provider.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: _buildUI());
  }

  PreferredSizeWidget _appBar() {
    return AppBar(title: const Text('Favorites'));
  }

  Widget _buildUI() {
    return Consumer<HololiveProvider>(
      builder: (context, hololiveMembers, _) {
        if (hololiveMembers.hololiveList.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No favorites yet!'),
                duration: Duration(seconds: 1),
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.pop(context);
          });
        }
        return ListView.builder(
          itemCount: hololiveMembers.hololiveList.length,
          itemBuilder: (context, index) {
            final member = hololiveMembers.hololiveList[index];
            return ListTile(
              title: Text(member.name),
              subtitle: Text('Gen ${member.generation}'),
              leading: Image.network(member.imageUrl),
              trailing: IconButton(
                icon: const Icon(Icons.remove_circle),
                onPressed: () {
                  hololiveMembers.removeHololive(member);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${member.name} is removed from favorites!',
                      ),
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
