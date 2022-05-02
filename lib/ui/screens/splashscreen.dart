import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SplashScreen extends StatelessWidget {
  static const route = "/splashscreen";

  const SplashScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoScaffold(
        transitionBackgroundColor:
            CupertinoTheme.of(context).scaffoldBackgroundColor,
        body: StaggeredGrid.count(
          crossAxisCount: 1,
          children: [
            Lottie.asset("splashscreen.json"),
          ],
        ));
  }
}
