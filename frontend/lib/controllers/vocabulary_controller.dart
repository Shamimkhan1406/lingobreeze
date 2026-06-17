import 'package:flutter/material.dart';

import '../models/word_model.dart';
import '../services/api_service.dart';
import '../services/firebase_service.dart';
import '../services/local_storage_service.dart';

class VocabularyController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final FirebaseService _firebaseService = FirebaseService();
  final LocalStorageService _localStorageService =
      LocalStorageService();

  List<WordModel> savedWords = [];
  List<WordModel> availableWords = [];
  List<WordModel> filteredWords = [];

  bool isLoading = false;
  String? errorMessage;

  /// Load words from local cache first
  Future<void> loadCachedWords() async {
    savedWords = await _localStorageService.getWords();
    notifyListeners();
  }

  /// Fetch latest words from Firebase and update cache
  Future<void> syncWords() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final words = await _firebaseService.getSavedWords();

      savedWords = words;

      await _localStorageService.saveWords(words);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// App startup flow
  Future<void> initialize() async {
    await loadCachedWords();
    await syncWords();
  }

  /// Fetch all words from Node.js API
  Future<void> loadAvailableWords() async {
    try {
      errorMessage = null;

      availableWords = await _apiService.getWords();

      filteredWords = availableWords;

      notifyListeners();
    } catch (e) {
      errorMessage = 'Failed to load available words';
      notifyListeners();
    }
  }

  /// Search words locally
  void searchWords(String query) {
    if (query.trim().isEmpty) {
      filteredWords = availableWords;
    } else {
      filteredWords = availableWords.where((word) {
        return word.word
            .toLowerCase()
            .contains(query.toLowerCase());
      }).toList();
    }

    notifyListeners();
  }

  /// Save word to Firebase and local storage
  Future<bool> addWord(WordModel word) async {
    try {
      final saved = await _firebaseService.saveWord(word);

      if (!saved) {
        errorMessage = 'Word already saved';
        notifyListeners();
        return false;
      }

      savedWords.add(word);

      await _localStorageService.saveWords(savedWords);

      notifyListeners();

      return true;
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();

      return false;
    }
  }

  /// Pull to refresh
  Future<void> refreshWords() async {
    await syncWords();
  }

  /// Clear error
  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}