import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Builder'),
        actions: [
          IconButton(
            icon: const Icon(Icons.star),
            onPressed: () {
              // placeholder for achievement unlock
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Profile building UI goes here'),
      ),
    );
  }
}
