import 'dart:developer';

import 'package:app_word/database/entity/word.dart';
import 'package:app_word/database/repository/firestore_repo.dart';
import 'package:app_word/res/global.dart';
import 'package:app_word/ui/screens/search_filter_page.dart';
import 'package:app_word/ui/widgets/word_book_widget.dart';
import 'package:app_word/ui/widgets/word_item_list_widget.dart';
import 'package:app_word/ui/widgets/words_book_widget.dart';
import 'package:app_word/viewmodel/navbar_model.dart';
import 'package:app_word/viewmodel/search_filter_model.dart';
import 'package:app_word/viewmodel/word_book_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Map<String, Word> words = {};

  SearchFilterModel searchFilterModel = SearchFilterModel();

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<NavBarModel>(context);

    return StaggeredGrid.count(
      crossAxisCount: 1,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height / 12.5),
        Stack(
          alignment: AlignmentDirectional.centerEnd,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  right: (MediaQuery.of(context).size.width / 10)),
              child: CupertinoSearchTextField(
                onSubmitted: (value) async => {
                  words.clear(),
                  if (searchFilterModel.semanticField != null ||
                      searchFilterModel.synonym != null ||
                      searchFilterModel.antonym != null)
                    {
                      await FirestoreRepository.getWords(
                              FirestoreRepository.personalWordsBook,
                              value,
                              searchFilterModel.semanticField,
                              searchFilterModel.synonym,
                              searchFilterModel.antonym)
                          .then(
                        (value) {
                          if (value.docs.isNotEmpty) {
                            for (var word in value.docs) {
                              Word w = Word.fromSnapshot(word.data(), word.id);
                              words.putIfAbsent(w.word!, () => w);
                            }
                          }
                        },
                      ),
                      await FirestoreRepository.getWords(
                              FirestoreRepository.classWordsBook,
                              value,
                              searchFilterModel.semanticField,
                              searchFilterModel.synonym,
                              searchFilterModel.antonym)
                          .then(
                        (value) {
                          if (value.docs.isNotEmpty) {
                            for (var word in value.docs) {
                              Word w = Word.fromSnapshot(word.data(), word.id);
                              words.putIfAbsent(w.word!, () => w);
                            }
                          }
                        },
                      ),
                    }
                  else
                    {
                      await FirestoreRepository.getWord(
                              FirestoreRepository.personalWordsBook, value)
                          .then((value) {
                        if (value.docs.isNotEmpty) {
                          Word w = Word.fromSnapshot(
                              value.docs.first.data(), value.docs.first.id);
                          words.putIfAbsent(w.word!, () => w);
                        }
                      }),
                      await FirestoreRepository.getWord(
                              FirestoreRepository.classWordsBook, value)
                          .then((value) {
                        if (value.docs.isNotEmpty) {
                          Word w = Word.fromSnapshot(
                              value.docs.first.data(), value.docs.first.id);
                          words.putIfAbsent(w.word!, () => w);
                        }
                      }),
                    },
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: (MediaQuery.of(context).size.width / 1.23),
              ),
              child: CupertinoButton(
                onPressed: () {
                  searchFilterModel.setSearch(false);
                  showCupertinoModalBottomSheet(
                    context: model.context,
                    builder: (context) => ChangeNotifierProvider(
                      create: (context) => searchFilterModel,
                      builder: (context, _) =>
                          SearchFilterPage(searchFilterModel),
                    ),
                  ).whenComplete(() async {
                    if (searchFilterModel.search) {
                      words.clear();
                      await FirestoreRepository.getWords(
                              FirestoreRepository.classWordsBook,
                              null,
                              searchFilterModel.semanticField,
                              searchFilterModel.synonym,
                              searchFilterModel.antonym)
                          .then(
                        (value) {
                          if (value.docs.isNotEmpty) {
                            for (var word in value.docs) {
                              Word w = Word.fromSnapshot(word.data(), word.id);
                              words.putIfAbsent(w.word!, () => w);
                            }
                          }
                        },
                      );
                      await FirestoreRepository.getWords(
                              FirestoreRepository.personalWordsBook,
                              null,
                              searchFilterModel.semanticField,
                              searchFilterModel.synonym,
                              searchFilterModel.antonym)
                          .then(
                        (value) {
                          if (value.docs.isNotEmpty) {
                            for (var word in value.docs) {
                              Word w = Word.fromSnapshot(word.data(), word.id);
                              words.putIfAbsent(w.word!, () => w);
                            }
                          }
                        },
                      );
                    }
                  });
                },
                color: null,
                child: const Icon(
                  CupertinoIcons.line_horizontal_3_decrease,
                  color: CupertinoColors.activeBlue,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: Global.getSize(context).width,
          height: Global.getSize(context).height,
          child: ListView.separated(
            padding: const EdgeInsets.all(0),
            itemCount: words.length,
            itemBuilder: (context, index) {
              if (words.isNotEmpty) {
                WordBookModel wordBookModel = WordBookModel();
                wordBookModel.addWord(words.values.elementAt(index).word!);
                return WordBook(
                    model, wordBookModel, words.values.elementAt(index));
              }
              return const Text("");
            },
            separatorBuilder: (context, index) {
              return Container(
                color: Colors.grey[350],
                height: 1,
              );
            },
          ),
        ),
      ],
    );
  }
}
