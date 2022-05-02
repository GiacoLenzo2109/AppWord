import 'dart:developer';

import 'package:app_word/database/repository/firestore_repo.dart';
import 'package:app_word/ui/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';

class DeleteAlertDialog extends StatefulWidget {
  final String title;
  final String text;
  final List<String> words;
  final String rubrica;
  const DeleteAlertDialog(this.title, this.text, this.words, this.rubrica,
      {Key? key})
      : super(key: key);

  @override
  State<DeleteAlertDialog> createState() => _DeleteAlertDialogState();
}

class _DeleteAlertDialogState extends State<DeleteAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(widget.title),
      content: Text(widget.text),
      actions: [
        CupertinoButton(
            child: const Text("Annulla"),
            onPressed: () => Navigator.pop(context)),
        CupertinoButton(
          child: const Text(
            "Elimina",
            style: TextStyle(
              color: CupertinoColors.systemRed,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () => {
            showCupertinoDialog(
                context: context, builder: (context) => const LoadingWidget()),
            FirestoreRepository.deleteWords(widget.words, widget.rubrica)
                .whenComplete(
              () => {
                log("Parole cancellate!"),
                Navigator.pop(context),
                Navigator.pop(context),
              },
            ),
          },
        ),
      ],
    );
  }
}
