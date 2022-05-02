import 'dart:developer';

import 'package:app_word/database/repository/firestore_repo.dart';
import 'package:app_word/res/global.dart';
import 'package:app_word/ui/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class JoinBookDialog extends StatefulWidget {
  const JoinBookDialog({Key? key}) : super(key: key);

  @override
  State<JoinBookDialog> createState() => _JoinBookDialog();
}

class _JoinBookDialog extends State<JoinBookDialog> {
  String pin = "";
  String pin_1 = "";
  String pin_2 = "";
  String pin_3 = "";
  String pin_4 = "";

  Widget buildInputField(Function(String) onChanged) {
    return CupertinoTextField(
      textAlign: TextAlign.center,
      padding: const EdgeInsets.all(15),
      maxLines: 1,
      expands: false,
      onChanged: onChanged,
      maxLength: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(35),
          child: Container(
              width: Global.getSize(context).width,
              decoration: BoxDecoration(
                  color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(10)),
              padding: Global.padding,
              child: StaggeredGrid.count(
                crossAxisCount: 1,
                mainAxisSpacing: 25,
                children: [
                  const Text("Inserisci pin gruppo",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  StaggeredGrid.count(
                    crossAxisSpacing: 10,
                    crossAxisCount: 4,
                    children: [
                      buildInputField((value) => setState(() => pin_1 = value)),
                      buildInputField((value) => setState(() => pin_2 = value)),
                      buildInputField((value) => setState(() => pin_3 = value)),
                      buildInputField((value) => setState(() => pin_4 = value)),
                    ],
                  ),
                  StaggeredGrid.count(
                    crossAxisCount: 2,
                    children: [
                      CupertinoButton(
                          child: const Text(
                            "Annulla",
                            style: TextStyle(color: CupertinoColors.systemRed),
                          ),
                          onPressed: () => Navigator.pop(context)),
                      CupertinoButton(
                          child: const Text(
                            "Conferma",
                            style:
                                TextStyle(color: CupertinoColors.systemGreen),
                          ),
                          onPressed: () {
                            if (pin_1 == "" ||
                                pin_2 == "" ||
                                pin_3 == "" ||
                                pin_4 == "") {
                              log("Insert all fields of the pin");
                            } else {
                              pin = pin_1 + pin_2 + pin_3 + pin_4;
                              log("Pin rubrica: " + pin);
                              showCupertinoDialog(
                                  context: context,
                                  builder: (_) => const LoadingWidget());
                              FirestoreRepository.joinWordBook(pin)
                                  .whenComplete(() => {
                                        Navigator.pop(context),
                                        Navigator.pop(context)
                                      });
                            }
                          }),
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}
