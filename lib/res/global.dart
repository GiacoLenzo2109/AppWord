import 'package:app_word/ui/widgets/loading_widget.dart';
import 'package:app_word/viewmodel/sign_in_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:textfield_tags/textfield_tags.dart';

class Global {
  static const List validEmail = ['test@gmail.com'];

  static GlobalKey tabBarKey = GlobalKey(debugLabel: "TabBar");

  static const EdgeInsets padding = EdgeInsets.all(15);

  static Size getSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static Widget buildCupertinoTextWithTitle(
      BuildContext context, String title, String text) {
    return Padding(
      padding: padding,
      child: Neumorphic(
        style: NeumorphicStyle(
          lightSource: LightSource.topLeft,
          shape: NeumorphicShape.flat,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
          depth: 4,
          color: CupertinoTheme.of(context).scaffoldBackgroundColor,
          shadowLightColor:
              CupertinoTheme.of(context).scaffoldBackgroundColor.withAlpha(10),
          shadowDarkColor: Colors.grey[400],
        ),
        child: Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$title:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: CupertinoTheme.of(context).primaryContrastingColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                text,
                style: TextStyle(
                  color: CupertinoTheme.of(context).primaryContrastingColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget buildNeumorphicTile(BuildContext context, Widget child) {
    return Padding(
      padding: padding,
      child: Neumorphic(
        style: NeumorphicStyle(
          lightSource: LightSource.topLeft,
          shape: NeumorphicShape.flat,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
          depth: 4,
          color: CupertinoTheme.of(context).scaffoldBackgroundColor,
          shadowLightColor:
              CupertinoTheme.of(context).scaffoldBackgroundColor.withAlpha(10),
          shadowDarkColor: Colors.grey[400],
        ),
        child: Padding(padding: padding, child: child),
      ),
    );
  }

  static CupertinoTextField buildCupertinoTextField(String placeholder,
      int? maxLines, IconData? icon, Function(String)? onChanged,
      {String? value}) {
    return CupertinoTextField(
      placeholder: value ?? placeholder,
      prefix: Padding(
          padding: Global.padding,
          child: Icon(
            icon,
            size: 20,
          )),
      padding: const EdgeInsets.all(5),
      maxLines: maxLines,
      expands: maxLines == null ? true : false,
      onChanged: onChanged,
    );
  }

  static TextFieldTags buildTextFieldTags(
      String errorPhrase,
      String insertPhrase,
      String? separator,
      TextfieldTagsController _controller,
      IconData? icon) {
    return TextFieldTags(
        textfieldTagsController: _controller,
        textSeparators: separator != null ? [separator] : null,
        letterCase: LetterCase.normal,
        validator: (String tag) {
          if (_controller.getTags!.contains(tag)) {
            return errorPhrase;
          }
          return null;
        },
        inputfieldBuilder: (context, tec, fn, error, onChanged, onSubmitted) {
          return ((context, sc, tags, onTagDelete) {
            return StaggeredGrid.count(
              crossAxisCount: 1,
              children: [
                CupertinoTextField(
                  prefix: Padding(
                      padding: Global.padding,
                      child: Icon(
                        icon,
                        size: 20,
                      )),
                  padding: const EdgeInsets.all(5),
                  maxLines: null,
                  expands: true,
                  controller: tec,
                  focusNode: fn,
                  placeholder: insertPhrase,
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(
                  width: Global.getSize(context).width,
                  child: tags.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxHeight:
                                      Global.getSize(context).height / 5),
                              child: SingleChildScrollView(
                                child: Wrap(
                                  alignment: WrapAlignment.start,
                                  runAlignment: WrapAlignment.end,
                                  children: tags.map((String tag) {
                                    return Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        CupertinoColors
                                                            .activeBlue)),
                                            child: Row(
                                              children: [
                                                Text(
                                                  tag,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                                const SizedBox(width: 10),
                                                const Icon(
                                                  CupertinoIcons.xmark_circle,
                                                  color: CupertinoColors.white,
                                                  size: 25,
                                                ),
                                              ],
                                            ),
                                            onPressed: () {
                                              onTagDelete(tag);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            )
                          ],
                        )
                      : null,
                ),
              ],
            );
          });
        });
  }

  static String capitalize(String value) {
    return value[0].toUpperCase() + value.substring(1);
  }
}
