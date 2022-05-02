import 'dart:developer';
import 'package:flutter/widgets.dart';

class WordBookModel extends ChangeNotifier {
  get words => _words;

  final Map<String, bool> _words = {};

  void clearWords() {
    _words.clear();
    notifyListeners();
  }

  get clickedWords => _clickedWords;

  final List<String> _clickedWords = [];

  void addWord(String word) {
    _words.putIfAbsent(word, () => false);
    notifyListeners();
  }

  bool isClicked(String word) {
    return _words[word]!;
  }

  void click(String word) {
    _words.update(word, ((value) => !_words[word]!));
    if (_words[word]!) {
      _clickedWords.add(word);
    } else {
      _clickedWords.remove(word);
    }
    notifyListeners();
  }

  void resetAll() {
    for (var word in _words.entries) {
      if (_words[word.key]!) click(word.key);
      notifyListeners();
    }
  }
}
