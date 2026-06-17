import 'package:flutter/material.dart';

import '../../models/word_model.dart';

class WordCard extends StatelessWidget {
  final WordModel word;

  const WordCard({
    super.key,
    required this.word,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              word.word,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Meaning: ${word.meaning}',
            ),
            const SizedBox(height: 6),
            Text(
              'Translation: ${word.translation}',
            ),
          ],
        ),
      ),
    );
  }
}