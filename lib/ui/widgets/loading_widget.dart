import 'package:app_word/res/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Global.getSize(context).width / 5),
      child: Container(
        width: 60,
        height: 60,
        padding: Global.padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: CupertinoTheme.of(context).scaffoldBackgroundColor,
        ),
        child: Lottie.asset("assets/loading.json", height: 10),
      ),
    );
  }
}
