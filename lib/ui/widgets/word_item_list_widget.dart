import 'dart:developer';

import 'package:app_word/database/entity/word.dart';
import 'package:app_word/database/repository/firestore_repo.dart';
import 'package:app_word/res/custom_colors.dart';
import 'package:app_word/ui/screens/word_page.dart';
import 'package:app_word/viewmodel/navbar_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WordItemList extends StatelessWidget {
  final Word word;

  const WordItemList({Key? key, required this.word}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<NavBarModel>(context);
    return CupertinoButton(
      alignment: Alignment.centerLeft,
      child: Text(
        word.word!,
        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15.0),
      ),
      onPressed: () {
        Navigator.push(model.context,
            CupertinoPageRoute(builder: (context) => WordPage(word)));
      },
    );
  }
}
