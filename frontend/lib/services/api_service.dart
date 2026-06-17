import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/word_model.dart';

class ApiService {
  static const String baseUrl =
    'http://10.0.2.2:3001';

  Future<List<WordModel>> getWords() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/words'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load words');
      }

      final jsonData =
          jsonDecode(response.body);

      final List<dynamic> words =
          jsonData['data'];

      return words
          .map(
            (item) => WordModel.fromJson(item),
          )
          .toList();
    } catch (e) {
      throw Exception(
        'Failed to fetch words',
      );
    }
  }
}