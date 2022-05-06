import 'dart:developer';

import 'package:app_word/database/entity/word.dart';
import 'package:app_word/database/firebase_global.dart';
import 'package:app_word/database/repository/firestore_repo.dart';
import 'package:app_word/res/custom_colors.dart';
import 'package:app_word/res/global.dart';
import 'package:app_word/ui/screens/add_word_page.dart';
import 'package:app_word/ui/screens/book_page.dart';
import 'package:app_word/ui/screens/join_book_dialog.dart';
import 'package:app_word/ui/screens/word_page.dart';
import 'package:app_word/ui/widgets/loading_widget.dart';
import 'package:app_word/ui/widgets/pie_chart_widget.dart';
import 'package:app_word/ui/widgets/word_item_list_widget.dart';
import 'package:app_word/viewmodel/navbar_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const route = "HomePage";

  @override
  State<StatefulWidget> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  int selectedIndex = 0;
  int badge = 0;

  late Word? dailyWord;
  late Map<String, Word> newWords = {};

  bool loaded = false;

  final padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 12);

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //   if (mounted) {
    //     showCupertinoDialog(
    //         context: context, builder: (context) => const LoadingWidget());
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final model = Provider.of<NavBarModel>(context);

    Shimmer buildShimmer(Widget widget) {
      return Shimmer.fromColors(
        child: widget,
        baseColor: CupertinoTheme.of(context).scaffoldBackgroundColor,
        highlightColor: CupertinoColors.systemGrey4,
      );
    }

    Widget buildHomeLoaded() {
      return SingleChildScrollView(
        child: Padding(
          padding: Global.padding,
          child: StaggeredGrid.count(
            crossAxisCount: 1,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            children: <Widget>[
              SizedBox(
                height: Global.getSize(context).height / 25,
              ),
              dailyWord != null
                  ? _buildTile(
                      Padding(
                        padding: const EdgeInsets.all(35.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Parola del giorno:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      color: CupertinoTheme.of(context)
                                          .primaryContrastingColor,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  SizedBox(
                                    width: Global.getSize(context).width / 3,
                                    child: Column(
                                      children: [
                                        CupertinoButton(
                                          padding: const EdgeInsets.all(0),
                                          child: Text(
                                            dailyWord != null
                                                ? dailyWord!.word!
                                                : ". . .",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22.0,
                                            ),
                                          ),
                                          onPressed: () => Navigator.push(
                                            model.context,
                                            CupertinoPageRoute(
                                              builder: (context) =>
                                                  WordPage(dailyWord!),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Material(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.amber[400],
                              child: Padding(
                                padding: padding,
                                child: Icon(
                                  Icons.lightbulb_rounded,
                                  size: size.height / 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(height: 0),
              StaggeredGrid.count(
                crossAxisCount: 1,
                mainAxisSpacing: 14,
                children: [
                  _buildTile(
                    Padding(
                      padding: padding,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Rubriche:",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 20.0,
                              color: CupertinoTheme.of(context)
                                  .primaryContrastingColor,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(7.5),
                            color: Colors.grey,
                            height: 1,
                          ),
                          const SizedBox(height: 7.5),
                          ElevatedButton(
                            onPressed: () => {
                              model.setWordBook(0),
                              model.openWordBook(true),
                            },
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(1.0),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                              minimumSize: MaterialStateProperty.all(
                                  Size(size.width, 50)),
                            ),
                            child: const Text(
                              "Personale",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 15.0),
                            ),
                          ),
                          const SizedBox(height: 22.5),
                          ElevatedButton(
                            onPressed: () => {
                              model.setWordBook(1),
                              model.openWordBook(true),
                            },
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(1.0),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blueAccent),
                              minimumSize: MaterialStateProperty.all(
                                  Size(size.width, 50)),
                            ),
                            child: const Text(
                              "Classe",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 15.0),
                            ),
                          ),
                          const SizedBox(height: 7.5),
                        ],
                      ),
                    ),
                  ),
                  /*Row(
                    children: [
                      Expanded(
                        child: _buildTile(
                          Column(
                            children: const [
                              SizedBox(height: 25),
                              Text(
                                "Sommario parole:",
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 20.0),
                              ),
                              PieChartWidget(),
                              SizedBox(height: 25),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),*/
                ],
              ),
              newWords.isNotEmpty
                  ? StaggeredGrid.count(
                      crossAxisCount: 1,
                      mainAxisSpacing: 5,
                      children: [
                        _buildTile(
                          Padding(
                            padding: padding,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Nuove parole:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 20.0,
                                    color: CupertinoTheme.of(context)
                                        .primaryContrastingColor,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(7.5),
                                  color: Colors.grey,
                                  height: 1,
                                ),
                                SizedBox(
                                  width: size.width,
                                  height: size.height / 2 - 22.5,
                                  child: ListView.separated(
                                    padding: const EdgeInsets.all(0),
                                    itemCount: newWords.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            model.context,
                                            CupertinoPageRoute(
                                              builder: (context) => WordPage(
                                                newWords.values
                                                    .elementAt(index),
                                              ),
                                            ),
                                          );
                                        },
                                        child: WordItemList(
                                          word:
                                              newWords.values.elementAt(index),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        color: Colors.grey[350],
                                        height: 1,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTile(
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 21),
                                  child: Icon(
                                    Icons.add_rounded,
                                    size: 50,
                                    color: Colors.orange,
                                  ),
                                ),
                                onTap: () => showCupertinoModalBottomSheet(
                                    context: model.context,
                                    builder: (context) => const AddWordPage()),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height / 25,
                        )
                      ],
                    )
                  : const SizedBox(height: 0),
            ],
          ),
        ),
      );
    }

    Widget buildHomeLoading() {
      return SingleChildScrollView(
        child: Padding(
          padding: Global.padding,
          child: StaggeredGrid.count(
            crossAxisCount: 1,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            children: <Widget>[
              SizedBox(
                height: Global.getSize(context).height / 25,
              ),
              _buildTile(
                Padding(
                  padding: const EdgeInsets.all(35.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildShimmer(
                              Container(
                                width: Global.getSize(context).width / 3 + 15,
                                height: 25,
                                decoration: BoxDecoration(
                                  color: CupertinoColors.systemGrey4,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            buildShimmer(
                              Container(
                                width: Global.getSize(context).width / 3,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: CupertinoColors.systemGrey4,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      buildShimmer(
                        Material(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.amber[400],
                          child: Padding(
                            padding: padding,
                            child: Icon(
                              Icons.lightbulb_rounded,
                              size: size.height / 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              StaggeredGrid.count(
                crossAxisCount: 1,
                mainAxisSpacing: 14,
                children: [
                  _buildTile(
                    Padding(
                      padding: padding,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          buildShimmer(
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 10),
                              height: 15,
                              decoration: BoxDecoration(
                                color: CupertinoColors.systemGrey4,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          buildShimmer(
                            Container(
                              margin: const EdgeInsets.all(7.5),
                              color: Colors.grey,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 7.5),
                          buildShimmer(
                            ElevatedButton(
                              onPressed: () => {},
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(0.0),
                                backgroundColor: MaterialStateProperty.all(
                                    CupertinoTheme.of(context)
                                        .scaffoldBackgroundColor),
                                minimumSize: MaterialStateProperty.all(
                                    Size(size.width, 50)),
                              ),
                              child: const SizedBox(),
                            ),
                          ),
                          const SizedBox(height: 22.5),
                          buildShimmer(
                            ElevatedButton(
                              onPressed: () => {},
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(0.0),
                                backgroundColor: MaterialStateProperty.all(
                                    CupertinoTheme.of(context)
                                        .scaffoldBackgroundColor),
                                minimumSize: MaterialStateProperty.all(
                                    Size(size.width, 50)),
                              ),
                              child: const SizedBox(),
                            ),
                          ),
                          const SizedBox(height: 7.5),
                        ],
                      ),
                    ),
                  ),
                  /*Row(
                    children: [
                      Expanded(
                        child: _buildTile(
                          Column(
                            children: const [
                              SizedBox(height: 25),
                              Text(
                                "Sommario parole:",
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 20.0),
                              ),
                              PieChartWidget(),
                              SizedBox(height: 25),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),*/
                ],
              ),
              StaggeredGrid.count(
                crossAxisCount: 1,
                mainAxisSpacing: 5,
                children: [
                  _buildTile(
                    Padding(
                      padding: padding,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          buildShimmer(
                            Container(
                              decoration: BoxDecoration(
                                color: CupertinoTheme.of(context)
                                    .scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 5),
                              height: 15,
                            ),
                          ),
                          buildShimmer(
                            Container(
                              margin: const EdgeInsets.all(7.5),
                              color: Colors.grey,
                              height: 1,
                            ),
                          ),
                          SizedBox(
                            width: size.width,
                            height: size.height / 2 - 22.5,
                            child: ListView.separated(
                              padding: const EdgeInsets.all(0),
                              itemCount: 10,
                              itemBuilder: (context, index) {
                                return buildShimmer(
                                  CupertinoButton(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: CupertinoColors.systemGrey,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      height: 10,
                                    ),
                                    onPressed: () {},
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return buildShimmer(
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    color: Colors.grey[350],
                                    height: 1,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTile(
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 21),
                            child: buildShimmer(
                              const Icon(
                                Icons.add_rounded,
                                size: 50,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                          onTap: () => showCupertinoModalBottomSheet(
                              context: model.context,
                              builder: (context) => const AddWordPage()),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height / 25,
                  )
                ],
              ),
            ],
          ),
        ),
      );
    }

    Future<bool> fetchData() async {
      if (FirebaseGlobal.auth.currentUser != null) {
        await FirestoreRepository.getDailyWord().then((word) async {
          if (word.docs.isNotEmpty) {
            dailyWord = Word.fromSnapshot(
                word.docs.first.data() as Map<String, dynamic>);
          } else {
            dailyWord = null;
          }

          var words = await FirestoreRepository.getAllWords(
              FirestoreRepository.classWordsBook);

          if (words != null && words.docs.isNotEmpty) {
            for (var item in words.docs) {
              Word word =
                  Word.fromSnapshot(item.data() as Map<String, dynamic>);
              newWords.putIfAbsent(word.word!, () => word);
            }
          }
          loaded = true;
          return true;
        });
      }
      return false;
    }

    Widget buildHome() => FutureBuilder(
          future: fetchData().then((value) => value),
          builder: (context, snapshot) {
            return loaded ? buildHomeLoaded() : buildHomeLoading();
          },
        );

    Widget buildVoidHome() {
      return Padding(
        padding: Global.padding,
        child: Align(
          alignment: Alignment.center,
          child: Center(
            child: CupertinoButton.filled(
                child: const Text(
                  "Entra in una classe",
                  style: TextStyle(
                      color: CupertinoColors.white,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () => showCupertinoDialog(
                    context: context,
                    builder: (context) => const JoinBookDialog())),
          ),
        ),
      );
    }

    Future<bool> checkBooks() async {
      if (FirebaseGlobal.auth.currentUser != null) {
        return await FirestoreRepository.getWordsBook().then((value) {
          return value.docs.isNotEmpty ? true : false;
        });
      }
      return false;
    }

    return FutureBuilder(
      future: checkBooks(),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return buildHome();
        } else if (snapshot.data == false) {
          return buildVoidHome();
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildTile(Widget child, {double? round, Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Neumorphic(
          style: NeumorphicStyle(
            lightSource: LightSource.topLeft,
            shape: NeumorphicShape.flat,
            boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.circular(round ?? 12)),
            depth: 4,
            color: CupertinoTheme.of(context).scaffoldBackgroundColor,
            shadowLightColor: CupertinoTheme.of(context)
                .scaffoldBackgroundColor
                .withAlpha(10),
            shadowDarkColor: Colors.grey[400],
          ),
          child: child),
    );
  }
}
