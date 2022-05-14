import 'package:app_word/database/firebase_global.dart';
import 'package:app_word/res/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Word {
  static const modern = "Ita moderno";
  static const letteratura = "Ita letteratura";

  static const verbo = "Verbo";
  static const sostantivo = "Sostantivo";
  static const altro = "Altro";

  static const singular = "Singolare";
  static const plural = "Plurale";
  static const male = "Maschile";
  static const female = "Femminile";

  static const ID = "id";
  String? id;

  static const TYPE = "type";
  String? type;

  static const WORD = "word";
  String? word;

  static const TIMESTAMP = "timestamp";
  Timestamp? timestamp;

  static const DEFINITION = "definitions";
  List<String>? definitions;

  static const SEMANTIC_FIELD = "semantic_fields";
  List<String>? semanticFields;

  static const EXAMPLE_PHRASES = "example_phrases";
  List<String>? examplePhrases;

  static const SYNONYMS = "synonyms";
  List<String>? synonyms;

  static const ANTONYMS = "antonyms";
  List<String>? antonyms;

  static const GENDER = "gender";
  String? gender;

  static const MULTEPLICITY = "multeplicity";
  String? multeplicity;

  static const TIPOLOGY = "tipology";
  String? tipology;

  static const ITALIAN_TYPE = "italian_type";
  String? italianType;

  static const ITALIAN_CORRESPONDENCE = "italian_correspondence";
  String? italianCorrespondence;

  Word(
      {String? id,
      String? type,
      String? word,
      List<String>? definition,
      List<String>? semanticField,
      List<String>? examplePhrases,
      String? italianType,
      String? italianCorrespondence,
      List<String>? synonyms,
      List<String>? antonyms,
      String? tipology,
      String? gender,
      String? multeplicity})
      : id = id ?? "",
        type = type ?? "Verbo",
        word = word ?? "",
        timestamp = Timestamp.now(),
        definitions = definition ?? [],
        semanticFields = semanticField ?? [],
        examplePhrases = examplePhrases ?? [],
        italianType = italianType ?? Word.modern,
        italianCorrespondence = italianCorrespondence ?? "",
        synonyms = synonyms ?? [],
        antonyms = antonyms ?? [],
        tipology = tipology ?? "",
        gender = gender ?? "",
        multeplicity = multeplicity ?? "";

  @override
  String toString() {
    return "Type: $type \n" +
        "Word: $word \n" +
        "Definition: $definitions \n" +
        "Semantic Filed: $semanticFields \n" +
        "Phrases: $examplePhrases \n" +
        "Syn: $synonyms \n" +
        "Con: $antonyms \n" +
        "Tipology: $tipology \n" +
        "Gender: $gender \n" +
        "Mult: $multeplicity \n";
  }

  Map<String, dynamic> toMap() {
    if (examplePhrases != null) {
      for (var element in examplePhrases!) {
        element.toLowerCase();
      }
    }
    if (synonyms != null) {
      for (var element in synonyms!) {
        element.toLowerCase();
      }
    }
    if (antonyms != null) {
      for (var element in antonyms!) {
        element.toLowerCase();
      }
    }
    return {
      'author': FirebaseGlobal.auth.currentUser!.uid,
      ID: id,
      TYPE: type == null ? type : type!.toLowerCase(),
      WORD: word == null ? word : word!.toLowerCase(),
      TIMESTAMP: timestamp,
      DEFINITION: definitions,
      SEMANTIC_FIELD: semanticFields,
      EXAMPLE_PHRASES: examplePhrases,
      SYNONYMS: synonyms,
      ANTONYMS: antonyms,
      GENDER: gender == null ? gender : gender!.toLowerCase(),
      MULTEPLICITY:
          multeplicity == null ? multeplicity : multeplicity!.toLowerCase(),
      TIPOLOGY: tipology == null ? tipology : tipology!.toLowerCase(),
      ITALIAN_TYPE:
          italianType == null ? italianType : italianType!.toLowerCase(),
      ITALIAN_CORRESPONDENCE: italianCorrespondence == null
          ? italianCorrespondence
          : italianCorrespondence!.toLowerCase(),
    };
  }

  Word.fromSnapshot(Map<String, dynamic> snapshot, this.id)
      : type = Global.capitalize(snapshot[TYPE]),
        word = snapshot[WORD],
        timestamp = snapshot[TIMESTAMP],
        definitions = List<String>.from(snapshot[DEFINITION]),
        semanticFields = List<String>.from(snapshot[SEMANTIC_FIELD]),
        examplePhrases = List<String>.from(snapshot[EXAMPLE_PHRASES]),
        synonyms = List<String>.from(snapshot[SYNONYMS]),
        antonyms = List<String>.from(snapshot[ANTONYMS]),
        gender =
            snapshot[GENDER] != null && snapshot[GENDER].toString().isNotEmpty
                ? Global.capitalize(snapshot[GENDER])
                : snapshot[GENDER],
        multeplicity = snapshot[MULTEPLICITY] != null &&
                snapshot[MULTEPLICITY].toString().isNotEmpty
            ? Global.capitalize(snapshot[MULTEPLICITY])
            : snapshot[MULTEPLICITY],
        tipology = snapshot[TIPOLOGY] != null &&
                snapshot[TIPOLOGY].toString().isNotEmpty
            ? Global.capitalize(snapshot[TIPOLOGY])
            : snapshot[TIPOLOGY],
        italianType = snapshot[ITALIAN_TYPE] != null &&
                snapshot[ITALIAN_TYPE].toString().isNotEmpty
            ? Global.capitalize(snapshot[ITALIAN_TYPE])
            : snapshot[ITALIAN_TYPE],
        italianCorrespondence = snapshot[ITALIAN_CORRESPONDENCE] != null &&
                snapshot[ITALIAN_CORRESPONDENCE].toString().isNotEmpty
            ? Global.capitalize(snapshot[ITALIAN_CORRESPONDENCE])
            : snapshot[ITALIAN_CORRESPONDENCE];
}
