import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/word_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String collectionName = 'saved_words';

  Future<bool> saveWord(WordModel word) async {
    try {
      final docRef = _firestore
          .collection(collectionName)
          .doc(word.id.toString());

      final existingDoc = await docRef.get();

      if (existingDoc.exists) {
        return false;
      }

      await docRef.set({
        ...word.toJson(),
        'savedAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      throw Exception('Failed to save word');
    }
  }

  Future<List<WordModel>> getSavedWords() async {
    try {
      final snapshot = await _firestore.collection(collectionName).get();

      return snapshot.docs.map((doc) {
        final data = doc.data();

        return WordModel(
          id: data['id'],
          word: data['word'],
          meaning: data['meaning'],
          translation: data['translation'],
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch words');
    }
  }
}
