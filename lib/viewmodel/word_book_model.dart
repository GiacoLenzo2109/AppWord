import 'dart:developer';
import 'package:app_word/database/entity/word.dart';
import 'package:flutter/widgets.dart';

class WordBookModel extends ChangeNotifier {
  Map<String, bool> get words => _words;

  final Map<String, bool> _words = {};

  void clearWords() {
    _words.clear();
    notifyListeners();
  }

  List<Word> get clickedWords => _clickedWords;

  final List<Word> _clickedWords = [];

  void addWord(Word word) {
    _words.putIfAbsent(word.id!, () => false);
    notifyListeners();
  }

  bool isClicked(Word word) {
    return _words[word.id]!;
  }

  void click(Word word) {
    if (!isClicked(word)) {
      _clickedWords.add(word);
    } else {
      _clickedWords.removeWhere((element) => element.id == word.id);
    }
    _words.update(word.id!, ((value) => !_words[word.id]!));
    notifyListeners();
  }

  void resetAll() {
    for (var element in _words.keys) {
      _words[element] = false;
    }
    _clickedWords.clear();
    notifyListeners();
  }
}
