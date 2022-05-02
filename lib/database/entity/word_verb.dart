import 'package:app_word/database/entity/word.dart';
import 'package:flutter/rendering.dart';

class WordVerb extends Word {
  @override
  List<String>? synonyms;
  @override
  List<String>? antonyms;
  WordVerb(
      {required String word,
      required String definition,
      required String semanticField,
      required List<String> examplePhrases,
      required String italianType,
      String? italianCorrespondence,
      required this.synonyms,
      required this.antonyms})
      : super(
            type: "Verbo",
            word: word,
            definition: definition,
            semanticField: semanticField,
            examplePhrases: examplePhrases,
            italianType: italianType,
            italianCorrespondence: italianCorrespondence);
}
