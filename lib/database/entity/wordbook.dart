import 'package:app_word/database/entity/word.dart';

class WordBook {
  List<Word>? words;

  WordBook({List<Word>? words}) : words = words ?? [];

  Map<String, dynamic> toMap(String type) {
    return {
      "type": type,
    };
  }
}
