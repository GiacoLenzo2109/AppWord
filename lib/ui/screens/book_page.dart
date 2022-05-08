import 'dart:developer';

import 'package:app_word/database/entity/word.dart';
import 'package:app_word/database/firebase_global.dart';
import 'package:app_word/database/repository/firestore_repo.dart';
import 'package:app_word/res/global.dart';
import 'package:app_word/ui/screens/add_word_page.dart';
import 'package:app_word/ui/widgets/loading_widget.dart';
import 'package:app_word/ui/widgets/word_book_widget.dart';
import 'package:app_word/ui/widgets/words_book_widget.dart';
import 'package:app_word/viewmodel/navbar_model.dart';
import 'package:app_word/viewmodel/word_book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class BookPage extends StatefulWidget {
  const BookPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BookPage();
}

class _BookPage extends State<BookPage> {
  List<WordBookModel> models = [];
  var personalWordBookModel = WordBookModel();
  var classWordBookModel = WordBookModel();

  bool addCheck = true;
  late String id;

  Future<String?> getID() async {
    return await FirestoreRepository.getWordsBook()
        .then((value) => value.docs.isNotEmpty ? value.docs.first.id : null);
  }

  Stream<QuerySnapshot<Object?>>? personalWordBook;

  Stream<QuerySnapshot<Object?>>? classWordBook;

  @override
  void initState() {
    models.add(personalWordBookModel);
    models.add(classWordBookModel);
    if (FirebaseGlobal.auth.currentUser != null) {
      personalWordBook = FirestoreRepository.getPersonalWordBookSnapshot();
      getID().then((value) => value != null
          ? classWordBook = FirestoreRepository.getWordsBookSnapshot(value)
          : null);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = Global.getSize(context);
    final model = Provider.of<NavBarModel>(context);

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        if (!model.isTappedLeading) {
          model.setActionTrailing(AddWordPage.route);
        }
        if (model.isTappedLeading) {
          List<Map<String, bool>> maps = [];
          maps.add(personalWordBookModel.words);
          maps.add(classWordBookModel.words);
          model.setActionTrailing("Delete",
              words: models.elementAt(model.selectedWordBook).clickedWords,
              rubrica: model.selectedWordBook == 0
                  ? FirestoreRepository.personalWordsBook
                  : FirestoreRepository.classWordsBook);
        }
      });
    });

    return StaggeredGrid.count(
      crossAxisCount: 1,
      mainAxisSpacing: 14,
      children: [
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoSlidingSegmentedControl(
                groupValue: model.selectedBook,
                children: const {
                  FirestoreRepository.personalWordsBook: Text(
                    FirestoreRepository.personalWordsBook,
                    style: TextStyle(fontSize: 15),
                  ),
                  FirestoreRepository.classWordsBook: Text(
                    FirestoreRepository.classWordsBook,
                    style: TextStyle(fontSize: 15),
                  ),
                },
                onValueChanged: (value) {
                  setState(() {
                    model.setBook(value.toString());
                  });
                },
              ),
            ],
          ),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: classWordBook != null
              ? (model.selectedBook == FirestoreRepository.personalWordsBook
                  ? personalWordBook
                  : classWordBook)
              : null,
          builder: (context, snapshot) {
            List<Word> words = [];
            List<String> wordsStrings = [];
            if (snapshot.hasData) {
              Map<int, QueryDocumentSnapshot<Object?>> wordsMap =
                  snapshot.data!.docs.asMap();

              for (var word in wordsMap.values) {
                wordsStrings.add(word["word"]);
                words.add(
                  Word.fromSnapshot(
                      word.data() as Map<String, dynamic>, word.id),
                );

                model.selectedWordBook == 0
                    ? personalWordBookModel.addWord(word["word"])
                    : classWordBookModel.addWord(word["word"]);
              }

              return model.selectedWordBook == 0
                  ? SizedBox(
                      height: size.height - 175,
                      width: size.width,
                      child: WordsBook(
                          model, wordsStrings, personalWordBookModel, words),
                    )
                  : SizedBox(
                      height: size.height - 175,
                      width: size.width,
                      child: WordsBook(
                          model, wordsStrings, classWordBookModel, words),
                    );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }
}
