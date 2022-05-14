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
  bool addCheck = true;
  bool notInitialized = true;
  late String id;

  List<Widget> wordsBook = [const SizedBox(), const SizedBox()];

  String selectedBook = FirestoreRepository.personalWordsBook;

  bool resetWords = false;

  @override
  Widget build(BuildContext context) {
    final size = Global.getSize(context);
    final model = Provider.of<NavBarModel>(context);

    Future.delayed(
      const Duration(milliseconds: 0),
      () => {
        setState(
          () {
            if (notInitialized) {
              wordsBook.clear();
              wordsBook.add(
                SizedBox(
                  height: size.height - 175,
                  width: size.width,
                  child: const WordsBook(
                    FirestoreRepository.personalWordsBook,
                  ),
                ),
              );
              wordsBook.add(
                SizedBox(
                  height: size.height - 175,
                  width: size.width,
                  child: const WordsBook(
                    FirestoreRepository.classWordsBook,
                  ),
                ),
              );
              notInitialized = false;
            }
            selectedBook = model.selectedBook;
          },
        )
      },
    );

    return StaggeredGrid.count(
      crossAxisCount: 1,
      mainAxisSpacing: 14,
      children: [
        SizedBox(height: Global.getSize(context).height / 12),
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
        IndexedStack(
          index: selectedBook == FirestoreRepository.personalWordsBook ? 0 : 1,
          children: wordsBook,
        ),
      ],
    );
  }
}
