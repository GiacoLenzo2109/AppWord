import 'dart:developer';

import 'package:app_word/database/entity/word.dart';
import 'package:app_word/database/firebase_global.dart';
import 'package:app_word/database/repository/firestore_repo.dart';
import 'package:app_word/res/global.dart';
import 'package:app_word/res/theme_class.dart';
import 'package:app_word/ui/widgets/error_dialog_widget.dart';
import 'package:app_word/ui/widgets/loading_widget.dart';
import 'package:app_word/viewmodel/navbar_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:textfield_tags/textfield_tags.dart';

class AddWordPage extends StatefulWidget {
  static const route = "/add_word";

  final Word? word;

  const AddWordPage({
    Key? key,
    this.word,
  }) : super(key: key);

  @override
  State<AddWordPage> createState() => _AddWordPageState();
}

class _AddWordPageState extends State<AddWordPage> {
  String wordsBook = FirestoreRepository.personalWordsBook;

  String selectedValue = Word.verbo;

  int genderValue = 0;

  int multeplicityValue = 0;

  String itaValue = Word.modern;

  bool definitionsLoaded = false;
  bool semanticFieldsLoaded = false;
  bool synLoaded = false;
  bool antLoaded = false;
  bool phrasesLoaded = false;

  int? selectedTipology;
  List<String> tipologies = [
    "Locuzione",
    "Avverbio",
    "Pronome",
    "Preposizione"
  ];

  List<Text> getTipologies() {
    List<Text> list = [];
    for (var item in tipologies) {
      list.add(Text(item));
    }
    return list;
  }

  TextfieldTagsController synController = TextfieldTagsController(),
      antController = TextfieldTagsController(),
      phraseController = TextfieldTagsController(),
      definitionController = TextfieldTagsController(),
      semanticFieldController = TextfieldTagsController();

  Word word = Word();

  @override
  void initState() {
    if (widget.word != null) {
      word = widget.word!;

      selectedValue = widget.word!.type!.isNotEmpty
          ? Global.capitalize(widget.word!.type!)
          : Word.verbo;

      selectedTipology =
          widget.word!.tipology != null && widget.word!.tipology!.isNotEmpty
              ? tipologies.indexOf(widget.word!.tipology!)
              : null;

      genderValue =
          widget.word!.gender != null && widget.word!.gender!.isNotEmpty
              ? widget.word!.gender! == Word.male
                  ? 0
                  : 1
              : 0;

      multeplicityValue = widget.word!.multeplicity != null &&
              widget.word!.multeplicity!.isNotEmpty
          ? widget.word!.multeplicity! == Word.singular
              ? 0
              : 1
          : 0;
      itaValue = widget.word!.italianType != null &&
              widget.word!.italianType!.isNotEmpty
          ? widget.word!.italianType!
          : Word.modern;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<NavBarModel>(context);

    Future.delayed(const Duration(milliseconds: 0)).then((value) {
      if (definitionController.getTags != null) {
        if (!definitionsLoaded) {
          for (var tag in word.definitions!) {
            log(tag);
            definitionController.onSubmitted(Global.capitalize(tag));
          }
        }
        definitionsLoaded = true;
        definitionController.onTagDelete("");
      }
      if (semanticFieldController.getTags != null) {
        if (!semanticFieldsLoaded) {
          for (var tag in word.semanticFields!) {
            semanticFieldController.onSubmitted(Global.capitalize(tag));
          }
        }
        semanticFieldsLoaded = true;
        semanticFieldController.onTagDelete("");
      }
      if (synController.getTags != null) {
        if (!synLoaded) {
          for (var tag in word.synonyms!) {
            synController.onSubmitted(Global.capitalize(tag));
          }
        }
        synLoaded = true;
        synController.onTagDelete("");
      }
      if (antController.getTags != null) {
        if (!antLoaded) {
          for (var tag in word.antonyms!) {
            antController.onSubmitted(Global.capitalize(tag));
          }
        }
        antLoaded = true;
        antController.onTagDelete("");
      }
      if (phraseController.getTags != null) {
        if (!phrasesLoaded) {
          for (var tag in word.examplePhrases!) {
            phraseController.onSubmitted(Global.capitalize(tag));
          }
        }
        phrasesLoaded = true;
        phraseController.onTagDelete("");
      }
    });

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        border: null,
        backgroundColor: CupertinoTheme.of(context)
            .scaffoldBackgroundColor
            .withOpacity(0.75),
        middle: Text(
            widget.word != null ? "Modifica vocabolo" : "Aggiungi vocabolo"),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 65, right: 15, left: 15, bottom: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StaggeredGrid.count(
                crossAxisCount: 1,
                mainAxisSpacing: 14,
                children: [
                  CupertinoSegmentedControl(
                    children: {
                      Word.verbo: Text(
                        Word.verbo,
                        style: TextStyle(
                          color: CupertinoTheme.of(context) ==
                                  ThemeClass.darkThemeCupertino
                              ? CupertinoTheme.of(context)
                                  .primaryContrastingColor
                              : selectedValue == Word.verbo
                                  ? CupertinoTheme.of(context)
                                      .scaffoldBackgroundColor
                                  : CupertinoTheme.of(context)
                                      .primaryContrastingColor,
                        ),
                      ),
                      Word.sostantivo: Text(
                        Word.sostantivo,
                        style: TextStyle(
                          color: CupertinoTheme.of(context) ==
                                  ThemeClass.darkThemeCupertino
                              ? CupertinoTheme.of(context)
                                  .primaryContrastingColor
                              : selectedValue == Word.sostantivo
                                  ? CupertinoTheme.of(context)
                                      .scaffoldBackgroundColor
                                  : CupertinoTheme.of(context)
                                      .primaryContrastingColor,
                        ),
                      ),
                      Word.altro: Text(
                        Word.altro,
                        style: TextStyle(
                          color: CupertinoTheme.of(context) ==
                                  ThemeClass.darkThemeCupertino
                              ? CupertinoTheme.of(context)
                                  .primaryContrastingColor
                              : selectedValue == Word.altro
                                  ? CupertinoTheme.of(context)
                                      .scaffoldBackgroundColor
                                  : CupertinoTheme.of(context)
                                      .primaryContrastingColor,
                        ),
                      ),
                    },
                    onValueChanged: (value) {
                      setState(() {
                        if (widget.word == null) {
                          selectedValue = value.toString();
                          if (selectedValue == Word.sostantivo) {
                            word.gender = Word.male;
                            word.multeplicity = Word.singular;
                          } else {
                            word.gender = null;
                            word.multeplicity = null;
                          }
                          word.type = selectedValue;
                        }
                      });
                    },
                    groupValue: selectedValue,
                    unselectedColor:
                        CupertinoTheme.of(context).scaffoldBackgroundColor,
                  ),
                  Visibility(
                      visible: selectedValue == Word.altro ? true : false,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Tipologia:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                selectedTipology != null
                                    ? tipologies.elementAt(selectedTipology!)
                                    : "",
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Global.getSize(context).height / 55,
                          ),
                          CupertinoButton(
                            color: CupertinoColors.activeOrange,
                            child: const Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Scegliere tipologia",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: CupertinoColors.white),
                              ),
                            ),
                            onPressed: () => showCupertinoModalPopup<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return _buildBottomPicker(
                                    CupertinoPicker(
                                      itemExtent: 30,
                                      scrollController:
                                          FixedExtentScrollController(
                                              initialItem:
                                                  selectedTipology != null
                                                      ? selectedTipology!
                                                      : 1),
                                      onSelectedItemChanged: (index) {
                                        selectedTipology = index;
                                        word.tipology = tipologies
                                            .elementAt(selectedTipology!);
                                      },
                                      children: getTipologies(),
                                    ),
                                    context);
                              },
                            ),
                          ),
                        ],
                      )),
                  Global.buildCupertinoTextField("Inserisci vocabolo", 1,
                      CupertinoIcons.text_cursor, (value) => word.word = value,
                      text: widget.word != null
                          ? Global.capitalize(widget.word!.word!)
                          : null),
                  Visibility(
                    visible: selectedValue == "Sostantivo" ? true : false,
                    child: StaggeredGrid.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      children: [
                        CupertinoSlidingSegmentedControl(
                            groupValue: genderValue,
                            children: const {
                              0: Text("M"),
                              1: Text("F"),
                            },
                            onValueChanged: (index) {
                              setState(() {
                                genderValue = index as int;
                                word.gender =
                                    genderValue == 0 ? Word.male : Word.female;
                              });
                            }),
                        CupertinoSlidingSegmentedControl(
                            groupValue: multeplicityValue,
                            children: const {
                              0: Text("S"),
                              1: Text("P"),
                            },
                            onValueChanged: (index) {
                              setState(() {
                                multeplicityValue = index as int;
                                word.multeplicity = multeplicityValue == 0
                                    ? Word.singular
                                    : Word.plural;
                              });
                            }),
                      ],
                    ),
                  ),
                  Global.buildTextFieldTags(
                    "Definizione già inserita",
                    "Inserisci definizione",
                    null,
                    definitionController,
                    CupertinoIcons.text_justify,
                    initialTags:
                        widget.word != null ? widget.word!.definitions : null,
                  ),
                  Global.buildTextFieldTags(
                    "Campo semantico già inserito",
                    "Inserisci campo semantico",
                    null,
                    semanticFieldController,
                    CupertinoIcons.textbox,
                    initialTags: widget.word != null
                        ? widget.word!.semanticFields
                        : null,
                  ),
                  Global.buildTextFieldTags(
                    "Frase già inserita!",
                    "Inserire una frase",
                    null,
                    phraseController,
                    CupertinoIcons.text_quote,
                    initialTags: widget.word != null
                        ? widget.word!.examplePhrases
                        : null,
                  ),
                  Visibility(
                    visible: selectedValue != "Altro" ? true : false,
                    child: StaggeredGrid.count(
                      crossAxisCount: 1,
                      mainAxisSpacing: 15,
                      children: [
                        Global.buildTextFieldTags(
                          "Sinonimo già inserito!",
                          "Inserire un sinonimo",
                          " ",
                          synController,
                          CupertinoIcons.sun_max,
                          initialTags: widget.word != null
                              ? widget.word!.synonyms
                              : null,
                        ),
                        Global.buildTextFieldTags(
                          "Contrario già inserito!",
                          "Inseriro un contrario",
                          " ",
                          antController,
                          CupertinoIcons.moon,
                          initialTags: widget.word != null
                              ? widget.word!.antonyms
                              : null,
                        ),
                      ],
                    ),
                  ),
                  CupertinoSlidingSegmentedControl(
                      groupValue: itaValue,
                      children: const {
                        Word.modern: Text("Ita moderno"),
                        Word.letteratura: Text("Ita letteratura"),
                      },
                      onValueChanged: (value) {
                        setState(() {
                          itaValue = value as String;
                          word.italianCorrespondence = itaValue;
                        });
                      }),
                  Visibility(
                    visible: itaValue == Word.letteratura ? true : false,
                    child: Global.buildCupertinoTextField(
                        "Corrispondenza italiano moderno",
                        1,
                        CupertinoIcons.text_cursor,
                        (value) => word.italianCorrespondence = value,
                        text: widget.word != null &&
                                widget.word!.italianCorrespondence != null
                            ? widget.word!.italianCorrespondence!
                            : null),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: CupertinoButton.filled(
                      child: Text(
                        widget.word != null ? "Aggiorna parola" : "Aggiungi",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: CupertinoColors.white),
                      ),
                      onPressed: () async {
                        word.definitions!.clear();
                        word.semanticFields!.clear();
                        word.synonyms!.clear();
                        word.antonyms!.clear();
                        word.examplePhrases!.clear();

                        if (definitionController.getTags != null) {
                          for (var def in definitionController.getTags!) {
                            word.definitions!.add(def);
                          }
                        }
                        if (semanticFieldController.getTags != null) {
                          for (var sem in semanticFieldController.getTags!) {
                            word.semanticFields!.add(sem);
                          }
                        }
                        if (phraseController.getTags != null) {
                          for (var phrase in phraseController.getTags!) {
                            word.examplePhrases!.add(phrase);
                          }
                        }
                        if (synController.getTags != null) {
                          for (var syn in synController.getTags!) {
                            word.synonyms!.add(syn);
                          }
                        }
                        if (antController.getTags != null) {
                          for (var ant in antController.getTags!) {
                            word.antonyms!.add(ant);
                          }
                        }
                        if (word.word!.isEmpty) {
                          if (widget.word != null) {
                            word.word = widget.word!.word;
                          } else {
                            showCupertinoDialog(
                              context: context,
                              builder: (context) => const ErrorDialogWidget(
                                  "Inserire il vocabolo!"),
                            );
                          }
                        } else if (word.definitions!.isEmpty) {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) => const ErrorDialogWidget(
                                "Inserire la definizione!"),
                          );
                        } else if (word.semanticFields!.isEmpty) {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) => const ErrorDialogWidget(
                                "Inserire il campo semantico!"),
                          );
                        } else if (word.italianType == Word.letteratura &&
                            word.italianCorrespondence!.isEmpty) {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) => const ErrorDialogWidget(
                                "Inserire il termine in italiano moderno!"),
                          );
                        } else {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) => const LoadingWidget(),
                          );

                          if (widget.word != null) {
                            if (word.word!.isEmpty) {
                              word.word = widget.word!.word!;
                              if (word.italianCorrespondence!.isEmpty) {
                                word.italianCorrespondence =
                                    widget.word!.italianCorrespondence!;
                              }
                            }
                            log("1_ Word to edit: " + word.toString());
                            await FirestoreRepository.updateWord(
                                word, model.selectedBook);
                            log("3_ Word updated");
                          } else {
                            if (model.dailyWord) {
                              model.setDailyWord(false);
                              log("1_ Word to add: " + word.toString());
                              await FirestoreRepository.addDailyWord(word);
                              log("3_ Word added");
                            } else {
                              log("1_ Word to add: " + word.toString());
                              await FirestoreRepository.addWord(
                                  word, model.selectedBook);
                              log("3_ Word added");
                            }
                          }
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPicker(Widget picker, BuildContext context) {
    return Container(
      height: 150,
      color: CupertinoTheme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.only(top: 6.0),
      child: picker,
    );
  }
}
