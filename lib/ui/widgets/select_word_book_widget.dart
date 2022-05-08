import 'dart:developer';

import 'package:app_word/database/entity/user.dart';
import 'package:app_word/database/firebase_global.dart';
import 'package:app_word/database/repository/firestore_repo.dart';
import 'package:app_word/res/global.dart';
import 'package:app_word/ui/screens/add_word_page.dart';
import 'package:app_word/viewmodel/navbar_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class SelectWordBook extends StatelessWidget {
  bool admin;
  SelectWordBook(this.admin, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<NavBarModel>(context);

    return Align(
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          color: CupertinoTheme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: Global.padding,
        padding: Global.padding,
        child: StaggeredGrid.count(
          crossAxisCount: 1,
          mainAxisSpacing: 22.5,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                CupertinoButton(
                    child: const Icon(
                      CupertinoIcons.xmark_circle_fill,
                      color: CupertinoColors.systemRed,
                    ),
                    onPressed: () => Navigator.pop(context)),
              ],
            ),
            Visibility(
              visible: admin,
              child: ElevatedButton(
                onPressed: () => {
                  model.setDailyWord(true),
                  Navigator.pop(context),
                  showCupertinoModalBottomSheet(
                    context: model.context,
                    builder: (context) => const AddWordPage(),
                  ),
                },
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(1.0),
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                  minimumSize: MaterialStateProperty.all(
                      Size(Global.getSize(context).width, 50)),
                ),
                child: const Text(
                  "Parola del giorno",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15.0),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => {
                model.setBook(FirestoreRepository.personalWordsBook),
                Navigator.pop(context),
                showCupertinoModalBottomSheet(
                  context: model.context,
                  builder: (context) => const AddWordPage(),
                ),
              },
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(1.0),
                backgroundColor: MaterialStateProperty.all(Colors.red),
                minimumSize: MaterialStateProperty.all(
                    Size(Global.getSize(context).width, 50)),
              ),
              child: const Text(
                "Personale",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15.0),
              ),
            ),
            ElevatedButton(
              onPressed: () => {
                model.setBook(FirestoreRepository.classWordsBook),
                Navigator.pop(context),
                showCupertinoModalBottomSheet(
                  context: model.context,
                  builder: (context) => const AddWordPage(),
                ),
              },
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(1.0),
                backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                minimumSize: MaterialStateProperty.all(
                    Size(Global.getSize(context).width, 50)),
              ),
              child: const Text(
                "Classe",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
