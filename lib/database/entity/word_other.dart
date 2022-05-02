import 'package:app_word/database/entity/word.dart';
import 'package:flutter/rendering.dart';

class WordOther extends Word {
  @override
  String? tipology;

  WordOther({
    required String type,
    required String word,
    required String definition,
    required String semanticField,
    required List<String> examplePhrases,
    required String italianType,
    required this.tipology,
  }) : super(
            type: type,
            word: word,
            definition: definition,
            semanticField: semanticField,
            examplePhrases: examplePhrases,
            italianType: italianType);
}
