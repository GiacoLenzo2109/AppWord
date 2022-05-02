import 'dart:developer';

import 'package:app_word/database/firebase_global.dart';
import 'package:app_word/res/custom_colors.dart';
import 'package:app_word/res/global.dart';
import 'package:app_word/ui/screens/add_word_page.dart';
import 'package:app_word/ui/screens/book_page.dart';
import 'package:app_word/ui/screens/home_page.dart';
import 'package:app_word/ui/screens/search_page.dart';
import 'package:app_word/ui/screens/settings_page.dart';
import 'package:app_word/viewmodel/navbar_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class MainBottomClass extends StatefulWidget {
  const MainBottomClass({Key? key}) : super(key: key);

  @override
  _MainBottomClassState createState() => _MainBottomClassState();
}

class _MainBottomClassState extends State<MainBottomClass> {
  //list of widgets to call ontap
  late List<Widget> pages = [];
  final widgetTitle = ["Home", "Rubrica", "Cerca", "Impostazioni"];
  bool check = false;
  bool init = false;

  Widget? leadingValue;
  Widget? trailingValue;

  var _sliding = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<NavBarModel>(context);

    void setLeading(Widget? leading) {
      leadingValue = leading;
      model.setLeadingValue(leading);
    }

    void setTrailing(Widget? trailing) {
      trailingValue = trailing;
      model.setTrailingValue(trailing);
    }

    Future.delayed(Duration.zero, () {
      if (mounted) {
        setState(() {
          if (model.checkWordBook) {
            (Global.tabBarKey.currentWidget as CupertinoTabBar).onTap!(1);
            model.openWordBook(false);
          }

          model.setContext(context);

          switch (_sliding) {
            case 1:
              if (!init) {
                init = true;
                setLeading(const Text("Modifica",
                    style: TextStyle(
                        color: CupertinoColors.activeBlue, fontSize: 17)));

                setTrailing(const Icon(
                  CupertinoIcons.add,
                  size: 20,
                  color: CupertinoColors.activeBlue,
                ));
              } else {
                if (!check && model.isTappedLeading) {
                  check = !check;
                  setLeading(const Text("Fatto",
                      style: TextStyle(
                          color: CupertinoColors.activeBlue, fontSize: 17)));
                  setTrailing(const Icon(
                    CupertinoIcons.trash,
                    size: 20,
                    color: CupertinoColors.systemRed,
                  ));
                } else if (check & !model.isTappedLeading) {
                  check = !check;
                  log("1");
                  setLeading(const Text("Modifica",
                      style: TextStyle(
                          color: CupertinoColors.activeBlue, fontSize: 17)));

                  setTrailing(const Icon(
                    CupertinoIcons.add,
                    size: 20,
                    color: CupertinoColors.activeBlue,
                  ));
                }
              }
              break;
            default:
              setLeading(const Text(""));
              setTrailing(const Text(""));
              break;
          }
        });
      } //your code goes here
    });

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        border: null,
        backgroundColor:
            CupertinoTheme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
        leading: GestureDetector(
            child: Align(
              alignment: Alignment.centerLeft,
              child: leadingValue,
            ),
            onTap: () => {
                  model.setTappedLeading(),
                }),
        trailing: GestureDetector(
          child: trailingValue,
          onTap: model.actionTrailing,
        ),
        middle: Text(widgetTitle[_sliding]),
      ),
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          key: Global.tabBarKey,
          backgroundColor: CupertinoTheme.of(context)
              .scaffoldBackgroundColor
              .withOpacity(0.75),
          border: null,
          activeColor: CupertinoColors.activeBlue,
          currentIndex: _sliding,
          onTap: (index) {
            _sliding = index;
            init = check = false;
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.book),
              label: 'Rubrica',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.search),
              label: 'Cerca',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings),
              label: 'Impostazioni',
            ),
          ],
        ),
        tabBuilder: (_, index) {
          if (FirebaseGlobal.auth.currentUser != null &&
              FirebaseGlobal.auth.currentUser!.emailVerified) {
            pages = const [
              HomePage(),
              BookPage(),
              SearchPage(),
              SettingsPage()
            ];
          }
          return CupertinoTabView(
            builder: (context) {
              return CupertinoPageScaffold(
                child: Padding(
                  padding: Global.padding,
                  child: IndexedStack(
                    index: index,
                    children: pages,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text(widgetTitle.elementAt(selectedIndex)),
  //     ),
  //     body: Center(
  //       child: widgetOptions.elementAt(selectedIndex),
  //     ),
  //     bottomNavigationBar: BottomNavigationBar(
  //       elevation: 0,
  //       backgroundColor: Colors.transparent,
  //       type: BottomNavigationBarType.fixed,
  //       selectedItemColor: CustomColors.mediumBlue,
  //       unselectedItemColor: Theme.of(context).primaryColorDark,
  //       showUnselectedLabels: false,
  //       showSelectedLabels: false,
  //       currentIndex: selectedIndex,
  //       onTap: onItemTapped,
  //       items: const <BottomNavigationBarItem>[
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.home_rounded),
  //           label: 'Home',
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.book_rounded),
  //           label: 'Rubriche',
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.search_rounded),
  //           label: 'Cerca',
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.settings_rounded),
  //           label: 'Impostazioni',
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
