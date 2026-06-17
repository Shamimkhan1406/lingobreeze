import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/word_model.dart';

class LocalStorageService {
  static const String savedWordsKey = 'saved_words';

  Future<void> saveWords(List<WordModel> words) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonList =
        words.map((word) => jsonEncode(word.toJson())).toList();

    await prefs.setStringList(savedWordsKey, jsonList);
  }

  Future<List<WordModel>> getWords() async {
    final prefs = await SharedPreferences.getInstance();

    final jsonList = prefs.getStringList(savedWordsKey);

    if (jsonList == null || jsonList.isEmpty) {
      return [];
    }

    return jsonList
        .map(
          (item) => WordModel.fromJson(
            jsonDecode(item),
          ),
        )
        .toList();
  }

  Future<void> clearWords() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(savedWordsKey);
  }
}