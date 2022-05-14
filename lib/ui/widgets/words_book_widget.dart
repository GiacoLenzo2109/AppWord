import 'dart:developer';

import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:app_word/database/entity/word.dart';
import 'package:app_word/database/firebase_global.dart';
import 'package:app_word/database/repository/firestore_repo.dart';
import 'package:app_word/res/global.dart';
import 'package:app_word/ui/screens/add_word_page.dart';
import 'package:app_word/ui/screens/word_page.dart';
import 'package:app_word/ui/widgets/error_dialog_widget.dart';
import 'package:app_word/ui/widgets/word_book_widget.dart';
import 'package:app_word/viewmodel/navbar_model.dart';
import 'package:app_word/viewmodel/word_book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class WordsBook extends StatefulWidget {
  final String repo;

  const WordsBook(this.repo, {Key? key}) : super(key: key);

  @override
  State<WordsBook> createState() => _WordsBookState();
}

class _WordsBookState extends State<WordsBook> {
  bool addCheck = true;
  bool resetWords = false;

  bool notInitialized = true;

  WordBookModel wordBookModel = WordBookModel();

  Stream<QuerySnapshot<Object?>>? wordBook;

  NavBarModel model = NavBarModel();

  Future<String?> getID() async {
    return await FirestoreRepository.getWordsBook()
        .then((value) => value.docs.isNotEmpty ? value.docs.first.id : null);
  }

  @override
  void initState() {
    if (FirebaseGlobal.auth.currentUser != null) {
      if (widget.repo == FirestoreRepository.personalWordsBook) {
        wordBook = FirestoreRepository.getPersonalWordBookSnapshot();
      } else {
        getID().then((value) => value != null
            ? wordBook = FirestoreRepository.getWordsBookSnapshot(value)
            : null);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<NavBarModel>(context);
    Future.delayed(
      const Duration(milliseconds: 0),
      () => {
        setState(
          () {
            if (!model.isTappedLeading) {
              model.setActionTrailing(AddWordPage.route);
              wordBookModel.resetAll();
            }
            if (model.isTappedLeading) {
              if (wordBookModel.clickedWords.isNotEmpty) {
                model.setActionTrailing("Delete",
                    words: wordBookModel.clickedWords, rubrica: widget.repo);
              }
            }
          },
        ),
      },
    );

    return StreamBuilder<QuerySnapshot>(
      stream: wordBook,
      builder: (context, snapshot) {
        List<Word> words = [];
        List<String> wordsStrings = [];
        if (snapshot.hasData) {
          Map<int, QueryDocumentSnapshot<Object?>> _wordsMap =
              snapshot.data!.docs.asMap();

          for (var word in _wordsMap.values) {
            Word w =
                Word.fromSnapshot(word.data() as Map<String, dynamic>, word.id);
            wordsStrings.add(Global.capitalize(w.word!));
            words.add(w);

            wordBookModel.addWord(w);
          }

          words.sort((a, b) {
            return a.word!.compareTo(b.word!);
          });

          wordsStrings.sort((a, b) {
            return a.compareTo(b);
          });
          Map<String, bool> wordsMap = _buildMap(wordsStrings);

          return wordsMap.isNotEmpty
              ? AlphabetListScrollView(
                  strList: wordsStrings,
                  indexedHeight: (index) {
                    if (wordsMap[wordsStrings[index]]!) {
                      return 85;
                    }
                    return 50;
                  },
                  normalTextStyle: TextStyle(
                      color:
                          CupertinoTheme.of(context).primaryContrastingColor),
                  showPreview: true,
                  keyboardUsage: true,
                  itemBuilder: (context, index) {
                    if (wordsMap[wordsStrings[index]]!) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                wordsStrings[index]
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: CupertinoColors.systemYellow,
                                ),
                              ),
                            ),
                          ),
                          WordBook(
                              model, words.elementAt(index), wordBookModel),
                        ],
                      );
                    }
                    return WordBook(
                        model, words.elementAt(index), wordBookModel);
                  },
                )
              : Center(
                  child: StaggeredGrid.count(
                    crossAxisCount: 1,
                    mainAxisSpacing: 10,
                    children: [
                      const Icon(
                        CupertinoIcons.doc_plaintext,
                        size: 50,
                        color: CupertinoColors.systemGrey,
                      ),
                      const Text(
                        "Rubrica vuota!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: CupertinoColors.systemGrey,
                            fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "Aggiungi una parola",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: CupertinoColors.systemGrey,
                            fontWeight: FontWeight.bold),
                      ),
                      CupertinoButton(
                          child: const Icon(CupertinoIcons.add),
                          onPressed: model.actionTrailing),
                    ],
                  ),
                );
        }
        return const SizedBox();
      },
    );
  }

  Map<String, bool> _buildMap(List<String> words) {
    List<String> bools = [];
    Map<String, bool> wordsMap = {};

    for (var word in words) {
      if (!bools.contains(word.substring(0, 1).toUpperCase())) {
        bools.add(word.substring(0, 1));
        wordsMap.putIfAbsent(word, () => true);
      } else {
        wordsMap.putIfAbsent(word, () => false);
      }
    }
    return wordsMap;
  }
}
