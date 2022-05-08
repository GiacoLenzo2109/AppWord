import 'dart:developer';

import 'package:app_word/database/entity/word.dart';
import 'package:app_word/database/repository/firestore_repo.dart';
import 'package:app_word/main_bottom.dart';
import 'package:app_word/res/global.dart';
import 'package:app_word/ui/screens/add_word_page.dart';
import 'package:app_word/ui/screens/word_page.dart';
import 'package:app_word/ui/widgets/delete_alert_dialog.dart';
import 'package:app_word/ui/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class NavBarModel extends ChangeNotifier {
  get context => _context;

  BuildContext? _context;

  void setContext(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  get isTappedLeading => _leading;

  bool _leading = false;

  void setTappedLeading() {
    _leading = !_leading;
    notifyListeners();
  }

  get isTappedTrailing => _trailing;

  bool _trailing = false;

  void setTappedTrailing() {
    _trailing = !_trailing;
    notifyListeners();
  }

  get leadingValue => _leading_value;

  Widget? _leading_value;

  void setLeadingValue(Widget? value) {
    _leading_value = value;
    notifyListeners();
  }

  get trailingValue => _trailing_value;

  Widget? _trailing_value;

  void setTrailingValue(Widget? value) {
    _trailing_value = value;
    notifyListeners();
  }

  get trailingColor => _trailing_color;

  CupertinoDynamicColor? _trailing_color = CupertinoColors.activeBlue;

  void setTrailingColor(CupertinoDynamicColor color) {
    _trailing_color = color;
    notifyListeners();
  }

  get title => _title;

  Widget? _title;

  void setTitle(Widget title) {
    _title = title;
    notifyListeners();
  }

  get actionTrailing => _actionTrailing;

  Function()? _actionTrailing;
  void setActionTrailing(String action,
      {List<String>? words, String? rubrica, Word? word}) {
    switch (action) {
      case AddWordPage.route:
        _actionTrailing = () => {
              showCupertinoModalBottomSheet(
                context: context,
                builder: (context) => const AddWordPage(),
              ),
              setTappedTrailing(),
            };
        break;
      case "Add":
        _actionTrailing = () => {
              if (word != null && rubrica != null)
                {
                  FirestoreRepository.addWord(word, rubrica)
                      .whenComplete(() => Navigator.pop(context)),
                }
            };
        break;
      case "Delete":
        _actionTrailing = () => {
              if (words != null && words.isNotEmpty)
                {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) => DeleteAlertDialog(
                        "Conferma",
                        words.length == 1
                            ? "Sei sicuro di eliminare la parola '" +
                                Global.capitalize(words.first) +
                                "' dalla rubrica?"
                            : "Sei sicuro di eliminare la parole selezionate dalla rubrica?",
                        words,
                        rubrica!),
                  ).whenComplete(
                      () => {log("Delete complete"), setTappedLeading()}),
                }
            };
        break;
      default:
    }
    notifyListeners();
  }

  get selectedBook => _selectedBook;

  String _selectedBook = FirestoreRepository.personalWordsBook;

  void setBook(String selectedBook) {
    _selectedBook = selectedBook;
    notifyListeners();
  }

  get checkWordBook => _checkWordBook;
  bool _checkWordBook = false;

  void openWordBook(bool check) {
    _checkWordBook = check;
    notifyListeners();
  }

  get selectedWordBook => _selectedWordBook;
  int _selectedWordBook = 0;

  void setWordBook(int index) {
    _selectedWordBook = index;
    notifyListeners();
  }

  get dailyWord => _dailyWord;
  bool _dailyWord = false;

  void setDailyWord(bool value) {
    _dailyWord = value;
    notifyListeners();
  }
}
