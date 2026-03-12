import 'package:flutter/material.dart';
import 'package:hololive_id_cards/datas/hololive_data.dart';
import 'package:hololive_id_cards/providers/hololive_provider.dart';
import 'package:provider/provider.dart';

class HololivePage extends StatelessWidget {
  const HololivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(context), body: _buildUI(context));
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      title: const Text('Hololive ID Cards'),
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_sharp),
          onPressed: () {
            Navigator.pushNamed(context, '/favorites');
          },
        ),
      ],
    );
  }

  Widget _buildUI(BuildContext context) {
    HololiveProvider hololiveProvider = Provider.of<HololiveProvider>(context);
    return ListView.builder(
      itemCount: hololiveMembers.length,
      itemBuilder: (context, index) {
        final member = hololiveMembers[index];
        return ListTile(
          title: Text(member.name),
          subtitle: Text('Gen ${member.generation}'),
          leading: Image.network(member.imageUrl),
          trailing: IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              hololiveProvider.addHololive(member);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${member.name} added to favorites!'),
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
