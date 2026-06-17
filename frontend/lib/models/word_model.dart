class WordModel {
  final int id;
  final String word;
  final String meaning;
  final String translation;

  const WordModel({
    required this.id,
    required this.word,
    required this.meaning,
    required this.translation,
  });

  factory WordModel.fromJson(Map<String, dynamic> json) {
    return WordModel(
      id: json['id'],
      word: json['word'],
      meaning: json['meaning'],
      translation: json['translation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word': word,
      'meaning': meaning,
      'translation': translation,
    };
  }

  WordModel copyWith({
    int? id,
    String? word,
    String? meaning,
    String? translation,
  }) {
    return WordModel(
      id: id ?? this.id,
      word: word ?? this.word,
      meaning: meaning ?? this.meaning,
      translation: translation ?? this.translation,
    );
  }
}
