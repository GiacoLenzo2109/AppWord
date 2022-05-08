import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:app_word/database/entity/word.dart';
import 'package:app_word/ui/widgets/word_book_widget.dart';
import 'package:app_word/viewmodel/navbar_model.dart';
import 'package:app_word/viewmodel/word_book_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class WordsBook extends StatefulWidget {
  final List<String> words;
  final NavBarModel model;
  final WordBookModel wordBookModel;
  final List<Word> wordsEntity;

  const WordsBook(this.model, this.words, this.wordBookModel, this.wordsEntity,
      {Key? key})
      : super(key: key);

  @override
  State<WordsBook> createState() => _WordsBookState();
}

class _WordsBookState extends State<WordsBook> {
  bool addCheck = true;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          widget.words.sort((a, b) {
            return a.compareTo(b);
          });
          if (!widget.model.isTappedLeading) {
            widget.wordBookModel.resetAll();
          }
        });
      }
    });

    Map<String, bool> wordsMap = _buildMap(widget.words);

    return wordsMap.isNotEmpty
        ? AlphabetListScrollView(
            strList: widget.words,
            indexedHeight: (index) {
              if (wordsMap[widget.words[index]]!) {
                return 110;
              }
              return 50;
            },
            normalTextStyle: TextStyle(
                color: CupertinoTheme.of(context).primaryContrastingColor),
            showPreview: true,
            keyboardUsage: true,
            itemBuilder: (context, index) {
              if (wordsMap[widget.words[index]]!) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.words[index].substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: CupertinoColors.systemYellow,
                          ),
                        ),
                      ),
                    ),
                    WordBook(widget.model, widget.wordBookModel,
                        widget.wordsEntity.elementAt(index)),
                  ],
                );
              }
              return WordBook(
                widget.model,
                widget.wordBookModel,
                widget.wordsEntity.elementAt(index),
              );
            },
            // headerWidgetList: <AlphabetScrollListHeader>[
            //   AlphabetScrollListHeader(
            //     widgetList: [
            //       const CupertinoSearchTextField(),
            //     ],
            //     icon: const Icon(CupertinoIcons.search),
            //     indexedHeaderHeight: (index) => 35,
            //   ),
            // ],
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
                    onPressed: widget.model.actionTrailing),
              ],
            ),
          );
  }
}

Map<String, bool> _buildMap(List<String> words) {
  List<String> bools = [];
  Map<String, bool> wordsMap = {};
  for (var word in words) {
    if (!bools.contains(word.substring(0, 1))) {
      bools.add(word.substring(0, 1));
      wordsMap.putIfAbsent(word, () => true);
    } else {
      wordsMap.putIfAbsent(word, () => false);
    }
  }
  return wordsMap;
}
