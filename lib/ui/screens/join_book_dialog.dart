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

  Map<int, bool> pins = {};
  Map<int, FocusNode> focusNodes = {};

  @override
  void initState() {
    pins.putIfAbsent(0, () => true);
    pins.putIfAbsent(1, () => false);
    pins.putIfAbsent(2, () => false);
    pins.putIfAbsent(3, () => false);

    for (var n in pins.keys) {
      focusNodes.putIfAbsent(n, () => FocusNode());
    }

    Future.delayed(
      const Duration(milliseconds: 0),
      () => FocusScope.of(context).requestFocus(focusNodes[0]),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildInputField(int n, Function(String) onChanged) {
      return CupertinoTextField(
        focusNode: focusNodes[n],
        decoration: BoxDecoration(
          border: Border.all(
              width: focusNodes[n]!.hasFocus ? 3 : 1,
              color: pins[n]!
                  ? CupertinoColors.activeBlue
                  : CupertinoColors.systemGrey),
          borderRadius: BorderRadius.circular(10),
        ),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        textInputAction:
            n < pins.length - 1 ? TextInputAction.next : TextInputAction.done,
        padding: const EdgeInsets.all(15),
        maxLines: 1,
        expands: false,
        onChanged: onChanged,
        maxLength: 1,
        onEditingComplete: () {
          setState(() {
            n < pins.length - 1
                ? FocusScope.of(context).requestFocus(focusNodes[n + 1])
                : FocusScope.of(context).unfocus();

            pins[n] = false;
            if (n < pins.length - 1) pins[n + 1] = true;
          });
        },
        onTap: () {
          setState(() {
            for (int p in pins.keys) {
              pins[p] = false;
            }
            pins[n] = true;
            FocusScope.of(context).requestFocus(focusNodes[n]);
          });
        },
      );
    }

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
                  const Text(
                    "Inserisci pin gruppo",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  StaggeredGrid.count(
                    crossAxisSpacing: 10,
                    crossAxisCount: 4,
                    children: [
                      buildInputField(
                          0, (value) => setState(() => pin_1 = value)),
                      buildInputField(
                          1, (value) => setState(() => pin_2 = value)),
                      buildInputField(
                          2, (value) => setState(() => pin_3 = value)),
                      buildInputField(
                          3, (value) => setState(() => pin_4 = value)),
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
