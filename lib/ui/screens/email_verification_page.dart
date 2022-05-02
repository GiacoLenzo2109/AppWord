import 'dart:async';
import 'dart:developer';

import 'package:app_word/database/firebase_global.dart';
import 'package:app_word/res/custom_colors.dart';
import 'package:app_word/res/global.dart';
import 'package:app_word/ui/screens/signin_page.dart';
import 'package:app_word/viewmodel/sign_in_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class EmailVerificationPage extends StatefulWidget {
  static const route = "/email_verification";

  const EmailVerificationPage({Key? key}) : super(key: key);

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  late SignInModel model;

  @override
  Widget build(BuildContext context) {
    model = Provider.of<SignInModel>(context);

    void reloadUser() async {
      FirebaseGlobal.auth.currentUser!.reload().whenComplete(() => model
          .setVerifiedEmail(FirebaseGlobal.auth.currentUser!.emailVerified));
      log("Email verificata: " + model.isEmailVerified.toString());
    }

    Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      reloadUser();
      if (model.isEmailVerified) timer.cancel();
    });

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoTheme.of(context).scaffoldBackgroundColor,
        border: null,
      ),
      child: Padding(
        padding: Global.padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StaggeredGrid.count(
              mainAxisSpacing: 10,
              crossAxisCount: 1,
              children: [
                Lottie.asset(
                  'assets/email_sending.json',
                  height: Global.getSize(context).height / 2.5,
                  repeat: true,
                ),
                const Text(
                  "Verifica account tramite il link inviato a ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.black),
                ),
                Text(
                  FirebaseGlobal.auth.currentUser!.email.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.activeBlue),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Non hai ricevuto la mail?"),
                    CupertinoButton(
                        child: const Text("Invia mail"),
                        onPressed: () => FirebaseGlobal.auth.currentUser!
                            .sendEmailVerification()),
                  ],
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CupertinoButton(
                      color: !model.isEmailVerified
                          ? CupertinoColors.systemGrey3
                          : CupertinoColors.activeGreen,
                      pressedOpacity: 0.75,
                      child: const Text(
                        "Fatto",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: CupertinoColors.white,
                            fontSize: 18),
                      ),
                      onPressed: () async {
                        !model.isEmailVerified
                            ? await FirebaseGlobal.auth.currentUser!
                                .sendEmailVerification()
                            : Navigator.pushNamedAndRemoveUntil(
                                context, "/", (route) => false);
                      }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
