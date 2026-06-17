import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final VoidCallback onAddWord;

  const EmptyState({
    super.key,
    required this.onAddWord,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.menu_book_rounded,
              size: 80,
            ),
            const SizedBox(height: 20),
            const Text(
              "You haven't saved any words yet.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onAddWord,
              icon: const Icon(Icons.add),
              label: const Text(
                'Add Your First Word',
              ),
            ),
          ],
        ),
      ),
    );
  }
}