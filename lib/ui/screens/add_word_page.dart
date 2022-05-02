import 'dart:developer';

import 'package:app_word/database/entity/word.dart';
import 'package:app_word/database/firebase_global.dart';
import 'package:app_word/database/repository/firestore_repo.dart';
import 'package:app_word/res/global.dart';
import 'package:app_word/ui/widgets/error_dialog_widget.dart';
import 'package:app_word/ui/widgets/loading_widget.dart';
import 'package:app_word/viewmodel/navbar_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:textfield_tags/textfield_tags.dart';

class AddWordPage extends StatefulWidget {
  static const route = "/add_word";

  const AddWordPage({Key? key}) : super(key: key);

  @override
  State<AddWordPage> createState() => _AddWordPageState();
}

class _AddWordPageState extends State<AddWordPage> {
  String wordsBook = FirestoreRepository.personalWordsBook;

  String selectedValue = "Verbo";

  int genderValue = 0;

  int multeplicityValue = 0;

  int itaValue = 0;

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

  late TextfieldTagsController synController, antController, phraseController;

  Word word = Word();

  @override
  void initState() {
    synController = TextfieldTagsController();
    antController = TextfieldTagsController();
    phraseController = TextfieldTagsController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<NavBarModel>(context);

    Future.delayed(const Duration(milliseconds: 0)).then((value) {
      if (synController.getTags != null) {
        synController.onTagDelete("");
      }
      if (antController.getTags != null) {
        antController.onTagDelete("");
      }
      if (phraseController.getTags != null) {
        phraseController.onTagDelete("");
      }
    });

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        border: null,
        backgroundColor: CupertinoTheme.of(context)
            .scaffoldBackgroundColor
            .withOpacity(0.75),
        middle: const Text("Aggiungi vocabolo"),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 65, right: 15, left: 15, bottom: 15),
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
                          color: CupertinoTheme.of(context)
                              .primaryContrastingColor,
                        ),
                      ),
                      Word.sostantivo: Text(
                        Word.sostantivo,
                        style: TextStyle(
                          color: CupertinoTheme.of(context)
                              .primaryContrastingColor,
                        ),
                      ),
                      Word.altro: Text(
                        Word.altro,
                        style: TextStyle(
                          color: CupertinoTheme.of(context)
                              .primaryContrastingColor,
                        ),
                      ),
                    },
                    onValueChanged: (value) {
                      setState(() {
                        selectedValue = value.toString();
                        if (selectedValue == Word.sostantivo) {
                          word.gender = Word.male;
                          word.multeplicity = Word.singular;
                        } else {
                          word.gender = null;
                          word.multeplicity = null;
                        }
                        word.type = selectedValue;
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
                                      onSelectedItemChanged: (index) => {
                                        {selectedTipology = index},
                                        word.tipology = tipologies
                                            .elementAt(selectedTipology!)
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
                      CupertinoIcons.text_cursor, (value) => word.word = value),
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
                  Global.buildCupertinoTextField(
                      "Definizione",
                      null,
                      CupertinoIcons.text_justify,
                      (value) => word.definition = value),
                  Visibility(
                    child: Global.buildCupertinoTextField(
                        "Campo semantico",
                        1,
                        CupertinoIcons.textbox,
                        (value) => word.semanticField = value),
                  ),
                  Global.buildTextFieldTags(
                    "Frase già inserita!",
                    "Inserire una frase",
                    null,
                    phraseController,
                    CupertinoIcons.text_quote,
                  ),
                  AnimatedScale(
                    scale: selectedValue != "Altro" ? 1 : 0,
                    duration: const Duration(milliseconds: 500),
                    child: StaggeredGrid.count(
                      crossAxisCount: 1,
                      mainAxisSpacing: 15,
                      children: [
                        Global.buildTextFieldTags(
                            "Sinonimo già inserito!",
                            "Inserire un sinonimo",
                            " ",
                            synController,
                            CupertinoIcons.sun_max),
                        Global.buildTextFieldTags(
                            "Contrario già inserito!",
                            "Inseriro un contrario",
                            " ",
                            antController,
                            CupertinoIcons.moon),
                      ],
                    ),
                  ),
                  CupertinoSlidingSegmentedControl(
                      groupValue: itaValue,
                      children: const {
                        0: Text("Ita moderno"),
                        1: Text("Ita letteratura"),
                      },
                      onValueChanged: (index) {
                        setState(() {
                          itaValue = index as int;
                          word.italianCorrespondence = itaValue == 0
                              ? "Italiano moderno"
                              : "Italiano letteratura";
                        });
                      }),
                  Visibility(
                    visible: itaValue == 1 ? true : false,
                    child: CupertinoTextField(
                      placeholder: "Corrispondenza italiano moderno",
                      onChanged: (value) => word.italianCorrespondence = value,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: CupertinoButton.filled(
                      child: const Text(
                        "Aggiungi",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: CupertinoColors.white),
                      ),
                      onPressed: () async {
                        if (word.word!.isEmpty) {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) => const ErrorDialogWidget(
                                "Inserire il vocabolo!"),
                          );
                        } else if (word.definition!.isEmpty) {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) => const ErrorDialogWidget(
                                "Inserire la definizione!"),
                          );
                        } else if (word.semanticField!.isEmpty) {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) => const ErrorDialogWidget(
                                "Inserire il campo semantico!"),
                          );
                        } else {
                          showCupertinoDialog(
                              context: context,
                              builder: (context) => const LoadingWidget());
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
                          log("1_ Word to add: " + word.toString());
                          await FirestoreRepository.addWord(
                              word, model.selectedBook);
                          log("3_ Word added");
                          Navigator.pop(context);
                          Navigator.pop(context);
                          //Navigator.pop(context);
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
