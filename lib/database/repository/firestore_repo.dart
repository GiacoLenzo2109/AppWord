import 'dart:developer';

import 'package:app_word/database/entity/user.dart';
import 'package:app_word/database/entity/word.dart';
import 'package:app_word/database/entity/wordbook.dart';
import 'package:app_word/database/firebase_global.dart';
import 'package:app_word/res/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreRepository {
  static const String personalWordsBook = "Personale";
  static const String classWordsBook = "Classe";

  //USERS
  static Future<bool> signUp(
      String name, String surname, String email, String password) async {
    log("1_ SignUp iniziata");
    await FirebaseGlobal.auth
        .createUserWithEmailAndPassword(email: email, password: password);
    log("2_ Account creato");
    if (FirebaseGlobal.auth.currentUser != null) {
      await FirebaseGlobal.auth.currentUser!.sendEmailVerification();
      FirebaseGlobal.users
          .doc(FirebaseGlobal.auth.currentUser!.uid)
          .set(User(name, surname).toMap())
          .whenComplete(() => true);
    }
    return false;
  }

  static Future<DocumentSnapshot<Object?>> getUser(String id) {
    return FirebaseGlobal.users.doc(id).get();
  }

  //WORDS-BOOK
  // static Future<void> createPersonalWordBook() async {
  //   return await FirebaseGlobal.users
  //       .doc(FirebaseGlobal.auth.currentUser!.uid)
  //       .collection(FirebaseGlobal.wordBook + "/" + FirebaseGlobal.words)
  //       .add({})
  //       .then((value) => log("WordBook Added"))
  //       .catchError((error) => log("Failed to add wordbook: $error"));
  // }

  static Future<void> joinWordBook(String pin) async {
    return await FirebaseGlobal.wordBooks
        .where('pin', isEqualTo: pin)
        .limit(1)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        await FirebaseGlobal.wordBooks.doc(value.docs.first.id).update({
          'members':
              FieldValue.arrayUnion([FirebaseGlobal.auth.currentUser!.uid])
        });
      }
    });
  }

  static Future<QuerySnapshot<Object?>> getPersonalWordBook() async {
    return await FirebaseGlobal.users
        .doc(FirebaseGlobal.auth.currentUser!.uid)
        .collection(FirebaseGlobal.words)
        .get();
  }

  static Future<QuerySnapshot> getWordsBook() async {
    return await FirebaseGlobal.wordBooks
        .where('members', arrayContains: FirebaseGlobal.auth.currentUser!.uid)
        .limit(1)
        .get();
  }

  static Stream<QuerySnapshot> getPersonalWordBookSnapshot() {
    return FirebaseGlobal.users
        .doc(FirebaseGlobal.auth.currentUser!.uid)
        .collection(FirebaseGlobal.words)
        .snapshots();
  }

  static Stream<QuerySnapshot> getWordsBookSnapshot(String id) {
    return FirebaseGlobal.wordBooks
        .doc(id)
        .collection(FirebaseGlobal.words)
        .snapshots();
  }

  static Future<QuerySnapshot?> getAllWords(String rubrica) async {
    String idRubrica = "";

    if (FirebaseGlobal.auth.currentUser != null) {
      if (rubrica == personalWordsBook) {
        idRubrica = FirebaseGlobal.auth.currentUser!.uid;
      } else {
        await FirebaseGlobal.wordBooks
            .where('members',
                arrayContains: FirebaseGlobal.auth.currentUser?.uid ?? "")
            .limit(1)
            .get()
            .then((value) => {
                  idRubrica = value.docs.isNotEmpty
                      ? value.docs.first.id
                      : FirebaseGlobal.auth.currentUser?.uid ?? ""
                });
      }
      return (rubrica == personalWordsBook
              ? FirebaseGlobal.users
              : FirebaseGlobal.wordBooks)
          .doc(idRubrica)
          .collection(FirebaseGlobal.words)
          .orderBy(Word.TIMESTAMP, descending: true)
          .limit(10)
          .get();
    }
    return null;
  }

  // WORDS
  static Future<QuerySnapshot> getDailyWord() async {
    return await FirebaseGlobal.dailyWords.limit(1).get();
  }

  static Future<void> addDailyWord(Word word) async {
    log("2_ Adding word: " + word.toString());

    String id = FirebaseGlobal.dailyWords.doc().id;

    return FirebaseGlobal.dailyWords
        .doc(id)
        .set(word.toMap())
        .then((value) => log("Word Added"))
        .catchError((error) => log("Failed to add word: $error"));
  }

  static Future<void> addWord(Word word, String rubrica) async {
    log("2_ Adding word: " + word.toString());

    String idRubrica = "";

    if (rubrica == personalWordsBook) {
      idRubrica = FirebaseGlobal.auth.currentUser!.uid;
    } else {
      await FirebaseGlobal.wordBooks
          .where('members', arrayContains: FirebaseGlobal.auth.currentUser!.uid)
          .limit(1)
          .get()
          .then((value) => {
                idRubrica = value.docs.isNotEmpty
                    ? value.docs.first.id
                    : FirebaseGlobal.auth.currentUser!.uid
              });
    }

    String id = (rubrica == personalWordsBook
            ? FirebaseGlobal.users
            : FirebaseGlobal.wordBooks)
        .doc(idRubrica)
        .collection(FirebaseGlobal.words)
        .doc()
        .id;

    if (word.definitions != null) {
      for (int i = 0; i < word.definitions!.length; i++) {
        word.definitions![i] =
            Global.capitalize(word.definitions!.elementAt(i));
      }
    }

    if (word.semanticFields != null) {
      for (int i = 0; i < word.semanticFields!.length; i++) {
        word.semanticFields![i] =
            Global.capitalize(word.semanticFields!.elementAt(i));
      }
    }
    if (word.examplePhrases != null) {
      for (int i = 0; i < word.examplePhrases!.length; i++) {
        word.examplePhrases![i] =
            Global.capitalize(word.examplePhrases!.elementAt(i));
      }
    }

    if (word.synonyms != null) {
      for (int i = 0; i < word.synonyms!.length; i++) {
        word.synonyms![i] = Global.capitalize(word.synonyms!.elementAt(i));
      }
    }

    if (word.antonyms != null) {
      for (int i = 0; i < word.antonyms!.length; i++) {
        word.antonyms![i] = Global.capitalize(word.antonyms!.elementAt(i));
      }
    }

    return (rubrica == personalWordsBook
            ? FirebaseGlobal.users
            : FirebaseGlobal.wordBooks)
        .doc(idRubrica)
        .collection(FirebaseGlobal.words)
        .doc(id)
        .set(word.toMap())
        .then((value) => log("Word Added"))
        .catchError((error) => log("Failed to add word: $error"));
  }

  static Future<void> updateWord(Word word, String rubrica) async {
    String idRubrica = "";

    if (rubrica == personalWordsBook) {
      idRubrica = FirebaseGlobal.auth.currentUser!.uid;
    } else {
      await FirebaseGlobal.wordBooks
          .where('members', arrayContains: FirebaseGlobal.auth.currentUser!.uid)
          .limit(1)
          .get()
          .then((value) => {
                idRubrica = value.docs.isNotEmpty
                    ? value.docs.first.id
                    : FirebaseGlobal.auth.currentUser!.uid
              });
    }

    if (word.definitions != null) {
      for (int i = 0; i < word.definitions!.length; i++) {
        word.definitions![i] =
            Global.capitalize(word.definitions!.elementAt(i));
      }
    }

    if (word.semanticFields != null) {
      for (int i = 0; i < word.semanticFields!.length; i++) {
        word.semanticFields![i] =
            Global.capitalize(word.semanticFields!.elementAt(i));
      }
    }
    if (word.examplePhrases != null) {
      for (int i = 0; i < word.examplePhrases!.length; i++) {
        word.examplePhrases![i] =
            Global.capitalize(word.examplePhrases!.elementAt(i));
      }
    }

    if (word.synonyms != null) {
      for (int i = 0; i < word.synonyms!.length; i++) {
        word.synonyms![i] = Global.capitalize(word.synonyms!.elementAt(i));
      }
    }

    if (word.antonyms != null) {
      for (int i = 0; i < word.antonyms!.length; i++) {
        word.antonyms![i] = Global.capitalize(word.antonyms!.elementAt(i));
      }
    }

    return (rubrica == personalWordsBook
            ? FirebaseGlobal.users
            : FirebaseGlobal.wordBooks)
        .doc(idRubrica)
        .collection(FirebaseGlobal.words)
        .doc(word.id)
        .set(word.toMap())
        .then((value) => log("Word Updated"))
        .catchError((error) => log("Failed to add word: $error"));
  }

  static Future<void> deleteWords(List<Word> words, String rubrica) async {
    String idRubrica = "";

    if (rubrica == personalWordsBook) {
      idRubrica = FirebaseGlobal.auth.currentUser!.uid;
    } else {
      await FirebaseGlobal.wordBooks
          .where('members', arrayContains: FirebaseGlobal.auth.currentUser!.uid)
          .limit(1)
          .get()
          .then((value) => {
                idRubrica = value.docs.isNotEmpty
                    ? value.docs.first.id
                    : FirebaseGlobal.auth.currentUser!.uid
              });
    }

    for (var word in words) {
      log("1_ Deleting word $word");
      log("2_ Rubrica: $idRubrica");
      await (rubrica == personalWordsBook
              ? FirebaseGlobal.users
              : FirebaseGlobal.wordBooks)
          .doc(idRubrica)
          .collection(FirebaseGlobal.words)
          .doc(word.id)
          .delete()
          .whenComplete(() => log("3_ Word deleted"));
    }
    return;
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getWord(
      String rubrica, String value) async {
    String idRubrica = "";

    if (rubrica == classWordsBook) {
      await FirebaseGlobal.wordBooks
          .where('members', arrayContains: FirebaseGlobal.auth.currentUser!.uid)
          .limit(1)
          .get()
          .then((value) => {
                idRubrica = value.docs.isNotEmpty
                    ? value.docs.first.id
                    : FirebaseGlobal.auth.currentUser!.uid
              });
    } else {
      idRubrica = FirebaseGlobal.auth.currentUser!.uid;
    }

    return await (rubrica == personalWordsBook
            ? FirebaseGlobal.users
            : FirebaseGlobal.wordBooks)
        .doc(idRubrica)
        .collection(FirebaseGlobal.words)
        .where(Word.WORD, isEqualTo: value.toLowerCase())
        .get();
  }

  static Stream<QuerySnapshot> getWordSnapshot(String rubrica, String word) {
    String idRubrica = "";
    if (rubrica == classWordsBook) {
      FirebaseGlobal.wordBooks
          .where('members', arrayContains: FirebaseGlobal.auth.currentUser!.uid)
          .limit(1)
          .get()
          .then((value) {
        idRubrica = value.docs.isNotEmpty
            ? value.docs.first.id
            : FirebaseGlobal.auth.currentUser!.uid;
        return (rubrica == personalWordsBook
                ? FirebaseGlobal.users
                : FirebaseGlobal.wordBooks)
            .doc(idRubrica)
            .collection(FirebaseGlobal.words)
            .snapshots();
      });
    } else {
      idRubrica = FirebaseGlobal.auth.currentUser!.uid;
    }
    return (rubrica == personalWordsBook
            ? FirebaseGlobal.users
            : FirebaseGlobal.wordBooks)
        .doc(idRubrica)
        .collection(FirebaseGlobal.words)
        .snapshots();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getWords(
    String rubrica,
    String? value,
    String? semanticField,
    String? synonym,
    String? antonym,
  ) async {
    String idRubrica = "";
    if (rubrica == FirestoreRepository.classWordsBook) {
      await FirebaseGlobal.wordBooks
          .where('members', arrayContains: FirebaseGlobal.auth.currentUser!.uid)
          .limit(1)
          .get()
          .then((value) => {
                idRubrica = value.docs.isNotEmpty
                    ? value.docs.first.id
                    : FirebaseGlobal.auth.currentUser!.uid
              });
    } else {
      idRubrica = FirebaseGlobal.auth.currentUser!.uid;
    }
    if (value != null) {
      if (semanticField == null && synonym == null && antonym == null) {
        return await FirebaseGlobal.wordBooks
            .doc(idRubrica)
            .collection(FirebaseGlobal.words)
            .where(Word.WORD, isEqualTo: value.toLowerCase())
            .orderBy(Word.TIMESTAMP, descending: true)
            .get();
      } else if (semanticField != null && synonym == null && antonym == null) {
        return await FirebaseGlobal.wordBooks
            .doc(idRubrica)
            .collection(FirebaseGlobal.words)
            .where(Word.WORD, isEqualTo: value.toLowerCase())
            .where(Word.SEMANTIC_FIELD,
                arrayContains: semanticField.toLowerCase())
            .get();
      } else if (semanticField == null && synonym != null && antonym == null) {
        return await FirebaseGlobal.wordBooks
            .doc(idRubrica)
            .collection(FirebaseGlobal.words)
            .where(Word.WORD, isEqualTo: value.toLowerCase())
            .where(Word.SYNONYMS, arrayContains: synonym.toLowerCase())
            .get();
      } else if (semanticField == null && synonym == null && antonym != null) {
        return await FirebaseGlobal.wordBooks
            .doc(idRubrica)
            .collection(FirebaseGlobal.words)
            .where(Word.WORD, isEqualTo: value.toLowerCase())
            .where(Word.ANTONYMS, arrayContains: antonym.toLowerCase())
            .get();
      } else if (semanticField != null && synonym != null && antonym == null) {
        return await FirebaseGlobal.wordBooks
            .doc(idRubrica)
            .collection(FirebaseGlobal.words)
            .where(Word.WORD, isEqualTo: value.toLowerCase())
            .where(Word.SEMANTIC_FIELD,
                arrayContains: semanticField.toLowerCase())
            .where(Word.SYNONYMS, arrayContains: synonym.toLowerCase())
            .get();
      } else if (semanticField != null && synonym == null && antonym != null) {
        return await FirebaseGlobal.wordBooks
            .doc(idRubrica)
            .collection(FirebaseGlobal.words)
            .where(Word.WORD, isEqualTo: value.toLowerCase())
            .where(Word.SEMANTIC_FIELD,
                arrayContains: semanticField.toLowerCase())
            .where(Word.ANTONYMS, arrayContains: antonym.toLowerCase())
            .get();
      } else if (semanticField == null && synonym != null && antonym != null) {
        return await FirebaseGlobal.wordBooks
            .doc(idRubrica)
            .collection(FirebaseGlobal.words)
            .where(Word.WORD, isEqualTo: value.toLowerCase())
            .where(Word.SYNONYMS, arrayContains: synonym.toLowerCase())
            .where(Word.ANTONYMS, arrayContains: antonym.toLowerCase())
            .get();
      } else {
        return await FirebaseGlobal.wordBooks
            .doc(idRubrica)
            .collection(FirebaseGlobal.words)
            .where(Word.WORD, isEqualTo: value.toLowerCase())
            .where(Word.SEMANTIC_FIELD,
                arrayContains: semanticField!.toLowerCase())
            .where(Word.SYNONYMS, arrayContains: synonym!.toLowerCase())
            .where(Word.ANTONYMS, arrayContains: antonym!.toLowerCase())
            .get();
      }
    } else {
      if (semanticField != null && synonym == null && antonym == null) {
        return await FirebaseGlobal.wordBooks
            .doc(idRubrica)
            .collection(FirebaseGlobal.words)
            .where(Word.SEMANTIC_FIELD,
                arrayContains: semanticField.toLowerCase())
            .get();
      } else if (semanticField == null && synonym != null && antonym == null) {
        return await FirebaseGlobal.wordBooks
            .doc(idRubrica)
            .collection(FirebaseGlobal.words)
            .where(Word.SYNONYMS, arrayContains: synonym.toLowerCase())
            .get();
      } else if (semanticField == null && synonym == null && antonym != null) {
        return await FirebaseGlobal.wordBooks
            .doc(idRubrica)
            .collection(FirebaseGlobal.words)
            .where(Word.ANTONYMS, arrayContains: antonym.toLowerCase())
            .get();
      } else if (semanticField != null && synonym != null && antonym == null) {
        return await FirebaseGlobal.wordBooks
            .doc(idRubrica)
            .collection(FirebaseGlobal.words)
            .where(Word.SEMANTIC_FIELD,
                arrayContains: semanticField.toLowerCase())
            .where(Word.SYNONYMS, arrayContains: synonym.toLowerCase())
            .get();
      } else if (semanticField != null && synonym == null && antonym != null) {
        return await FirebaseGlobal.wordBooks
            .doc(idRubrica)
            .collection(FirebaseGlobal.words)
            .where(Word.SEMANTIC_FIELD,
                arrayContains: semanticField.toLowerCase())
            .where(Word.ANTONYMS, arrayContains: antonym.toLowerCase())
            .get();
      } else if (semanticField == null && synonym != null && antonym != null) {
        return await FirebaseGlobal.wordBooks
            .doc(idRubrica)
            .collection(FirebaseGlobal.words)
            .where(Word.SYNONYMS, arrayContains: synonym.toLowerCase())
            .where(Word.ANTONYMS, arrayContains: antonym.toLowerCase())
            .get();
      } else if (semanticField != null && synonym != null && antonym != null) {
        return await FirebaseGlobal.wordBooks
            .doc(idRubrica)
            .collection(FirebaseGlobal.words)
            .where(Word.SEMANTIC_FIELD,
                arrayContains: semanticField.toLowerCase())
            .where(Word.SYNONYMS, arrayContains: synonym.toLowerCase())
            .where(Word.ANTONYMS, arrayContains: antonym.toLowerCase())
            .get();
      } else {
        return await FirebaseGlobal.wordBooks
            .doc(idRubrica)
            .collection(FirebaseGlobal.words)
            .where(Word.WORD, isEqualTo: "")
            .get();
      }
    }
  }
}
