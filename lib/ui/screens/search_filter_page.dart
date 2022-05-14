import 'package:app_word/res/global.dart';
import 'package:app_word/viewmodel/search_filter_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class SearchFilterPage extends StatelessWidget {
  static const route = "/search_filter";
  final SearchFilterModel model;
  const SearchFilterPage(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        border: null,
        backgroundColor: CupertinoTheme.of(context).scaffoldBackgroundColor,
      ),
      child: Padding(
        padding: Global.padding,
        child: SingleChildScrollView(
          child: StaggeredGrid.count(
            crossAxisCount: 1,
            mainAxisSpacing: 15,
            children: [
              //const SizedBox(height: 50),
              Global.buildCupertinoTextField(
                "Campo semantico",
                1,
                CupertinoIcons.textbox,
                (value) {
                  model.setSemanticField(value);
                },
              ),
              Global.buildCupertinoTextField(
                "Sinonimo",
                1,
                CupertinoIcons.sun_min,
                (value) {
                  model.setSynonym(value);
                },
              ),
              Global.buildCupertinoTextField(
                "Contrario",
                1,
                CupertinoIcons.moon,
                (value) {
                  model.setAntonym(value);
                },
              ),
              CupertinoButton(
                  color: CupertinoColors.systemRed,
                  child: const Text(
                    "Reset filtri",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.white,
                    ),
                  ),
                  onPressed: () => model.clear()),
              CupertinoButton.filled(
                child: const Text(
                  "Cerca",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.white,
                  ),
                ),
                onPressed: () => {
                  model.setSearch(true),
                  Navigator.pop(context),
                },
              ),
              const SizedBox(
                height: 10,
              ),
              // StaggeredGrid.count(
              //   crossAxisCount: 2,
              //   crossAxisSpacing: 50,
              //   children: [
              //     CupertinoButton(
              //       padding: const EdgeInsets.all(0),
              //       child: const Text(
              //         "Annulla",
              //         style: TextStyle(
              //             color: CupertinoColors.white,
              //             fontWeight: FontWeight.bold),
              //       ),
              //       onPressed: () {
              //         Navigator.pop(context);
              //       },
              //       color: CupertinoColors.systemRed,
              //     ),
              //     CupertinoButton(
              //       padding: const EdgeInsets.all(0),
              //       child: const Text(
              //         "Conferma",
              //         style: TextStyle(
              //             color: CupertinoColors.white,
              //             fontWeight: FontWeight.bold),
              //       ),
              //       onPressed: () {},
              //       color: CupertinoColors.systemGreen,
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
