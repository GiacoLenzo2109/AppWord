import 'package:app_word/database/firebase_global.dart';
import 'package:app_word/res/custom_colors.dart';
import 'package:app_word/res/global.dart';
import 'package:app_word/ui/screens/signin_page.dart';
import 'package:app_word/viewmodel/navbar_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<NavBarModel>(context);
    void signOut() async {
      Navigator.pushNamedAndRemoveUntil(
          model.context, SignInPage.route, (Route<dynamic> route) => false);
      await FirebaseGlobal.auth.signOut();
    }

    return StaggeredGrid.count(
      crossAxisCount: 1,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              height: 100,
            ),
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(
                  CupertinoColors.systemRed,
                ),
                fixedSize: MaterialStateProperty.all(
                    Size(Global.getSize(context).width, 65)),
              ),
              onPressed: () {
                signOut();
              },
              child: const Text(
                "Logout",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
