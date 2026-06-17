import 'package:flutter/material.dart';

import '../../models/word_model.dart';

class WordCard extends StatelessWidget {
  final WordModel word;
  final VoidCallback? onDelete;

  const WordCard({
    super.key,
    required this.word,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    word.word,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (onDelete != null)
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(
                      Icons.delete_outline,
                    ),
                    tooltip: 'Delete Word',
                  ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Meaning: ',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Expanded(
                  child: Text(
                    word.meaning,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Translation: ',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Expanded(
                  child: Text(
                    word.translation,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}