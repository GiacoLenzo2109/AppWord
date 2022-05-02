import 'package:app_word/res/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ErrorDialogWidget extends StatefulWidget {
  final String text;

  const ErrorDialogWidget(this.text, {Key? key}) : super(key: key);

  @override
  State<ErrorDialogWidget> createState() => _ErrorDialogWidgetState();
}

class _ErrorDialogWidgetState extends State<ErrorDialogWidget> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () => Navigator.pop(context));

    return Padding(
      padding: Global.padding,
      child: Center(
        child: Container(
          padding: Global.padding,
          decoration: BoxDecoration(
            color: CupertinoTheme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
              padding: Global.padding,
              child: StaggeredGrid.count(
                crossAxisCount: 1,
                mainAxisSpacing: 15,
                children: [
                  const Icon(
                    CupertinoIcons.xmark_circle,
                    color: CupertinoColors.systemRed,
                    size: 35,
                  ),
                  Text(
                    widget.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: CupertinoColors.systemRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
