import 'dart:developer';

import 'package:app_word/database/entity/word.dart';
import 'package:app_word/res/global.dart';
import 'package:app_word/ui/screens/word_page.dart';
import 'package:app_word/viewmodel/navbar_model.dart';
import 'package:app_word/viewmodel/word_book_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class WordBook extends StatefulWidget {
  final NavBarModel model;
  Word word;
  WordBookModel wordBookModel;

  WordBook(this.model, this.word, this.wordBookModel, {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _WordBookState();
}

class _WordBookState extends State<WordBook> {
  var check = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final wordBookModel = Provider.of<WordBookModel>(context);
    // if (wordBookModel == null) {
    //   check = false;
    //   wordBookModel = WordBookModel();
    //   wordBookModel!.addWord(widget.word.word!);
    // }
    return StaggeredGrid.count(
      //mainAxisSize: MainAxisSize.min,
      crossAxisCount: 1,
      children: [
        Row(
          children: [
            Visibility(
              visible: check && widget.model.isTappedLeading,
              child: GestureDetector(
                  child: widget.wordBookModel.isClicked(widget.word)
                      ? const Icon(CupertinoIcons.check_mark_circled_solid)
                      : const Icon(CupertinoIcons.circle),
                  onTap: () => {
                        widget.wordBookModel.click(widget.word),
                      }),
            ),
            Expanded(
              child: CupertinoButton(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    Global.capitalize(widget.word.word!),
                    style: TextStyle(
                      fontSize: 15.0,
                      color: CupertinoTheme.of(context).primaryContrastingColor,
                    ),
                  ),
                ),
                onPressed: () {
                  if (widget.model.isTappedLeading) {
                    widget.wordBookModel.click(widget.word);
                  } else {
                    Navigator.push(
                        widget.model.context,
                        CupertinoPageRoute(
                            builder: (context) => WordPage(widget.word)));
                  }
                },
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 75),
          child: Container(
            color: CupertinoColors.systemGrey,
            height: 0.1,
          ),
        ),
      ],
    );
  }
}
