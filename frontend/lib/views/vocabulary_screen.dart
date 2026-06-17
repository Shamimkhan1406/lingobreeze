import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/vocabulary_controller.dart';
import '../models/word_model.dart';
import 'widgets/empty_state.dart';
import 'widgets/loading_widget.dart';
import 'widgets/word_card.dart';

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({super.key});

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VocabularyController>().initialize();
    });
  }

  Future<void> _showAddWordSheet() async {
    final controller = context.read<VocabularyController>();

    await controller.openWordPicker();

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _WordSelectionSheet(),
    );
  }

  Future<void> _deleteWord(
    VocabularyController controller,
    WordModel word,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Word'),
        content: Text(
          'Remove "${word.word}" from your vocabulary?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(
              context,
              false,
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(
              context,
              true,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await controller.deleteWord(word);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${word.word} removed',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VocabularyController>(
      builder: (context, controller, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('My Vocabulary'),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _showAddWordSheet,
            icon: const Icon(Icons.add),
            label: const Text('Add Word'),
          ),
          body: RefreshIndicator(
            onRefresh: controller.refreshWords,
            child: Builder(
              builder: (_) {
                if (controller.isLoading &&
                    controller.savedWords.isEmpty) {
                  return const LoadingWidget();
                }

                if (controller.errorMessage != null &&
                    controller.savedWords.isEmpty) {
                  return ListView(
                    children: [
                      SizedBox(
                        height:
                            MediaQuery.of(context).size.height * 0.7,
                        child: Center(
                          child: Text(
                            controller.errorMessage!,
                          ),
                        ),
                      ),
                    ],
                  );
                }

                if (controller.savedWords.isEmpty) {
                  return EmptyState(
                    onAddWord: _showAddWordSheet,
                  );
                }

                return ListView.builder(
                  physics:
                      const AlwaysScrollableScrollPhysics(),
                  itemCount: controller.savedWords.length,
                  itemBuilder: (context, index) {
                    final word =
                        controller.savedWords[index];

                    return WordCard(
                      word: word,
                      onDelete: () => _deleteWord(
                        controller,
                        word,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _WordSelectionSheet extends StatefulWidget {
  const _WordSelectionSheet();

  @override
  State<_WordSelectionSheet> createState() =>
      _WordSelectionSheetState();
}

class _WordSelectionSheetState
    extends State<_WordSelectionSheet> {
  @override
  Widget build(BuildContext context) {
    return Consumer<VocabularyController>(
      builder: (context, controller, child) {
        return Padding(
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SizedBox(
            height: 600,
            child: Column(
              children: [
                const SizedBox(height: 16),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search words...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged:
                        controller.searchWords,
                  ),
                ),

                const SizedBox(height: 16),

                Expanded(
                  child: ListView.builder(
                    itemCount:
                        controller.filteredWords.length,
                    itemBuilder: (context, index) {
                      final word =
                          controller.filteredWords[index];

                      return ListTile(
                        title: Text(word.word),
                        subtitle:
                            Text(word.meaning),
                        trailing: const Icon(
                          Icons.add_circle,
                        ),
                        onTap: () async {
                          final success =
                              await controller
                                  .addWord(word);

                          if (!context.mounted) {
                            return;
                          }

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? 'Word saved successfully'
                                    : 'Word already saved',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}