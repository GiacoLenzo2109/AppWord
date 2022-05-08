import 'dart:developer';

import 'package:app_word/database/entity/word.dart';
import 'package:app_word/database/repository/firestore_repo.dart';
import 'package:app_word/res/global.dart';
import 'package:app_word/ui/screens/add_word_page.dart';
import 'package:app_word/viewmodel/navbar_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class WordPage extends StatefulWidget {
  static const route = "/word";

  Word word;
  final bool? editable;
  WordPage(this.word, {Key? key, this.editable = true}) : super(key: key);

  @override
  State<WordPage> createState() => _WordPageState();
}

class _WordPageState extends State<WordPage> {
  Stream<QuerySnapshot<Object?>>? wordSnapshot;
  Future<String?> getID() async {
    return await FirestoreRepository.getWordsBook()
        .then((value) => value.docs.isNotEmpty ? value.docs.first.id : null);
  }

  @override
  void initState() {
    getID().then((value) => value != null
        ? wordSnapshot =
            FirestoreRepository.getWordSnapshot(value, widget.word.id!)
        : null);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirestoreRepository.getWord(
              FirestoreRepository.personalWordsBook, widget.word.word!)
          .then((value) {
        log(value.docs.length.toString());
        return value.docs.isEmpty ? true : false;
      }),
      builder: (context, snapshot) => StreamBuilder<QuerySnapshot>(
          stream: wordSnapshot,
          builder: (context, wordSnapshot) {
            Word? word;
            if (wordSnapshot.hasData && wordSnapshot.data!.docs.isNotEmpty) {
              word = Word.fromSnapshot(
                  wordSnapshot.data!.docs.first as Map<String, dynamic>,
                  widget.word.id!);
              widget.word = word;
            }
            return SizedBox.expand(
              child: CupertinoPageScaffold(
                child: CustomScrollView(
                  slivers: <Widget>[
                    CupertinoSliverNavigationBar(
                        largeTitle: Text(Global.capitalize(widget.word.word!)),
                        border: null,
                        backgroundColor: CupertinoTheme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.5),
                        trailing: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(),
                            Row(
                              children: [
                                Visibility(
                                  visible: snapshot.hasData
                                      ? snapshot.data as bool
                                      : false,
                                  child: CupertinoButton(
                                      padding: const EdgeInsets.only(
                                          right: 0, top: 10),
                                      alignment: Alignment.centerRight,
                                      child: const Icon(
                                        CupertinoIcons.add_circled,
                                        color: CupertinoColors.activeOrange,
                                      ),
                                      onPressed: () {
                                        FirestoreRepository.addWord(
                                                widget.word,
                                                FirestoreRepository
                                                    .personalWordsBook)
                                            .whenComplete(
                                                () => Navigator.pop(context));
                                      }),
                                ),
                                Visibility(
                                  visible: widget.editable != null &&
                                      widget.editable!,
                                  child: CupertinoButton(
                                    padding: const EdgeInsets.only(
                                        right: 0, top: 10),
                                    alignment: Alignment.centerRight,
                                    child: const Icon(
                                      CupertinoIcons.pen,
                                      color: CupertinoColors.activeBlue,
                                    ),
                                    onPressed: () {
                                      showCupertinoModalBottomSheet(
                                          context: context,
                                          builder: (context) => AddWordPage(
                                                word: word ?? widget.word,
                                              ));
                                    },
                                  ),
                                )
                              ],
                            )
                          ],
                        )),
                    SliverFillRemaining(
                      child: StaggeredGrid.count(
                        crossAxisCount: 1,
                        mainAxisSpacing: 14,
                        children: [
                          Visibility(
                            visible:
                                widget.word.type != Word.altro ? true : false,
                            child: Text(
                              widget.word.type! == Word.sostantivo
                                  ? widget.word.type! +
                                      ", " +
                                      widget.word.gender! +
                                      ", " +
                                      widget.word.multeplicity!
                                  : widget.word.type!,
                              style: const TextStyle(
                                  color: CupertinoColors.systemGrey,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                          Global.buildNeumorphicTile(
                            context,
                            StaggeredGrid.count(
                              crossAxisCount: 1,
                              children: [
                                Text(
                                  "Definizione:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    color: CupertinoTheme.of(context)
                                        .primaryContrastingColor,
                                  ),
                                ),
                                SizedBox(
                                  width: Global.getSize(context).width,
                                  height: (widget.word.definitions!.length * 23)
                                      .toDouble(),
                                  child: ListView.builder(
                                    padding: const EdgeInsets.all(0),
                                    itemExtent: 23,
                                    itemCount: widget.word.definitions!.length,
                                    itemBuilder: (context, index) => Row(
                                      children: [
                                        Text(
                                          (index + 1).toString() + ". ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: CupertinoTheme.of(context)
                                                .primaryContrastingColor,
                                          ),
                                        ),
                                        Text(
                                          '"' +
                                              widget.word.definitions!
                                                  .elementAt(index) +
                                              '"',
                                          style: TextStyle(
                                            color: CupertinoTheme.of(context)
                                                .primaryContrastingColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Global.buildNeumorphicTile(
                            context,
                            StaggeredGrid.count(
                              crossAxisCount: 1,
                              children: [
                                Text(
                                  "Campo semantico:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    color: CupertinoTheme.of(context)
                                        .primaryContrastingColor,
                                  ),
                                ),
                                SizedBox(
                                  width: Global.getSize(context).width,
                                  height:
                                      (widget.word.semanticFields!.length * 23)
                                          .toDouble(),
                                  child: ListView.builder(
                                    padding: const EdgeInsets.all(0),
                                    itemExtent: 23,
                                    itemCount:
                                        widget.word.semanticFields!.length,
                                    itemBuilder: (context, index) => Row(
                                      children: [
                                        Text(
                                          (index + 1).toString() + ". ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: CupertinoTheme.of(context)
                                                .primaryContrastingColor,
                                          ),
                                        ),
                                        Text(
                                          widget.word.semanticFields!
                                              .elementAt(index),
                                          style: TextStyle(
                                            color: CupertinoTheme.of(context)
                                                .primaryContrastingColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: widget.word.examplePhrases!.isNotEmpty,
                            child: Global.buildNeumorphicTile(
                              context,
                              StaggeredGrid.count(
                                crossAxisCount: 1,
                                children: [
                                  Text(
                                    "Frasi esempio:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                      color: CupertinoTheme.of(context)
                                          .primaryContrastingColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: Global.getSize(context).width,
                                    height:
                                        (widget.word.examplePhrases!.length *
                                                23)
                                            .toDouble(),
                                    child: ListView.builder(
                                      padding: const EdgeInsets.all(0),
                                      itemExtent: 23,
                                      itemCount:
                                          widget.word.examplePhrases!.length,
                                      itemBuilder: (context, index) => Row(
                                        children: [
                                          Text(
                                            (index + 1).toString() + ". ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: CupertinoTheme.of(context)
                                                  .primaryContrastingColor,
                                            ),
                                          ),
                                          Text(
                                            '"' +
                                                widget.word.examplePhrases!
                                                    .elementAt(index) +
                                                '"',
                                            style: TextStyle(
                                              color: CupertinoTheme.of(context)
                                                  .primaryContrastingColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: widget.word.synonyms!.isNotEmpty ||
                                widget.word.antonyms!.isNotEmpty,
                            child: Global.buildNeumorphicTile(
                              context,
                              StaggeredGrid.count(
                                crossAxisCount: 2,
                                children: [
                                  StaggeredGrid.count(
                                    crossAxisCount: 1,
                                    children: [
                                      Visibility(
                                        visible:
                                            widget.word.synonyms!.isNotEmpty
                                                ? true
                                                : false,
                                        child: const Text(
                                          "Sinonimi:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25),
                                        ),
                                      ),
                                      Visibility(
                                        visible:
                                            widget.word.synonyms!.isNotEmpty
                                                ? true
                                                : false,
                                        child: SizedBox(
                                          width: Global.getSize(context).width,
                                          height:
                                              (widget.word.synonyms!.length *
                                                      23)
                                                  .toDouble(),
                                          child: ListView.builder(
                                            padding: const EdgeInsets.all(0),
                                            itemExtent: 23,
                                            itemCount:
                                                widget.word.synonyms!.length,
                                            itemBuilder: (context, index) =>
                                                Text(
                                              (index + 1).toString() +
                                                  ". " +
                                                  widget.word.synonyms!
                                                      .elementAt(index),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  StaggeredGrid.count(
                                    crossAxisCount: 1,
                                    children: [
                                      Visibility(
                                        visible:
                                            widget.word.antonyms!.isNotEmpty
                                                ? true
                                                : false,
                                        child: const Text(
                                          "Contrari:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25),
                                        ),
                                      ),
                                      Visibility(
                                        visible:
                                            widget.word.antonyms!.isNotEmpty
                                                ? true
                                                : false,
                                        child: SizedBox(
                                          width: Global.getSize(context).width,
                                          height:
                                              (widget.word.antonyms!.length *
                                                      23)
                                                  .toDouble(),
                                          child: ListView.builder(
                                            padding: const EdgeInsets.all(0),
                                            itemExtent: 23,
                                            itemCount:
                                                widget.word.antonyms!.length,
                                            itemBuilder: (context, index) =>
                                                Text(
                                              (index + 1).toString() +
                                                  ". " +
                                                  widget.word.antonyms!
                                                      .elementAt(index),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: widget.word.italianType == Word.letteratura
                                ? true
                                : false,
                            child: Global.buildCupertinoTextWithTitle(
                                context,
                                "Corrispondenza italiano moderno",
                                widget.word.italianCorrespondence != null
                                    ? widget.word.italianCorrespondence!
                                    : ""),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
