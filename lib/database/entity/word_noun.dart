import 'package:app_word/database/entity/word.dart';

class WordNoun extends Word {
  static const male = "Maschile";
  static const female = "Femminile";
  static const singular = "Singolare";
  static const plural = "Plurale";

  @override
  List<String>? synonyms = [];
  @override
  List<String>? antonyms = [];

  @override
  String? gender;
  String? multeplicity;

  WordNoun(
      {required String word,
      required String definition,
      required String semanticField,
      required List<String> examplePhrases,
      required String italianType,
      String? italianCorrespondence,
      this.synonyms,
      this.antonyms,
      this.gender,
      this.multeplicity})
      : super(
            type: "Sostantivo",
            word: word,
            definition: definition,
            semanticField: semanticField,
            examplePhrases: examplePhrases,
            italianType: italianType,
            italianCorrespondence: italianCorrespondence);
}
