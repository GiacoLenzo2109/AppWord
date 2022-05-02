import 'dart:developer';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:app_word/database/firebase_global.dart';
import 'package:app_word/database/repository/firestore_repo.dart';
import 'package:app_word/res/custom_colors.dart';
import 'package:app_word/res/global.dart';
import 'package:app_word/res/theme_class.dart';
import 'package:app_word/ui/screens/email_verification_page.dart';
import 'package:app_word/ui/widgets/text_input_field.dart';
import 'package:app_word/ui/widgets/wave_widget.dart';
import 'package:app_word/viewmodel/sign_in_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  static const route = "/signin";
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPage();
}

class _SignInPage extends State<SignInPage> {
  var checkPassword = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final model = Provider.of<SignInModel>(context);

    bool checkError = false;
    String error = "";

    void logIn(String email, String password) async {
      try {
        await FirebaseGlobal.auth
            .signInWithEmailAndPassword(email: email, password: password);
        if (FirebaseGlobal.auth.currentUser != null) {
          if (FirebaseGlobal.auth.currentUser!.emailVerified) {
            Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
          } else {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => ChangeNotifierProvider(
                  create: (context) => model,
                  builder: (context, _) => const EmailVerificationPage(),
                ),
              ),
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        log(e.code);
        if (e.code == 'user-not-found') {
          checkError = true;
          error = 'Email o password sbagliati!';
        } else if (e.code == 'wrong-password') {
          checkError = true;
          error = 'Password sbagliata, riprova!';
        }
      } catch (e) {
        log(e.toString());
      }
    }

    void signUp(String email, String password) async {
      try {
        if (checkPassword) {
          log("1_ SignUp iniziata");
          await FirebaseGlobal.auth
              .createUserWithEmailAndPassword(email: email, password: password);
          log("2_ Account creato");
          if (FirebaseGlobal.auth.currentUser != null) {
            await FirebaseGlobal.auth.currentUser!.sendEmailVerification();

            log("3_ Email inviata");
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                        create: (context) => model,
                        builder: (context, _) =>
                            const EmailVerificationPage())));
          } else {
            error = "Le password non corrispondono!";
            checkError = true;
          }
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          checkError = true;
          error = 'La password è troppo debole!';
        } else if (e.code == 'email-already-in-use') {
          checkError = true;
          error = 'Mail già utilizzata!';
        }
      } catch (e) {
        log(e.toString());
      }
    }

    CupertinoTextField buildCupertinoTextFieldEmail() {
      return CupertinoTextField(
        placeholder: "Email",
        style: const TextStyle(fontSize: 15),
        obscureText: false,
        keyboardType: TextInputType.emailAddress,
        prefix: const Padding(
            padding: Global.padding, child: Icon(CupertinoIcons.mail_solid)),
        // suffix: CupertinoButton(
        //     child: model.isValidEmail
        //         ? const Icon(CupertinoIcons.checkmark_seal_fill)
        //         : const Icon(null),
        //     onPressed: () {}),
        padding: Global.padding,
        onChanged: (value) =>
            setState(() => {model.email = value, model.validEmail(value)}),
      );
    }

    CupertinoTextField buildCupertinoTextFieldPassword(
        String placeholder,
        int? maxLines,
        bool obscureText,
        IconData? icon,
        IconData? icon2,
        Function(String)? onChanged) {
      return CupertinoTextField(
        placeholder: placeholder,
        style: const TextStyle(fontSize: 15),
        obscureText: model.isVisible ? false : true,
        prefix: const Padding(
            padding: Global.padding, child: Icon(CupertinoIcons.lock_fill)),
        suffix: CupertinoButton(
            child: model.isVisible ? Icon(icon) : Icon(icon2),
            onPressed: () {
              model.isVisible = !model.isVisible;
            }),
        padding: Global.padding,
        onChanged: (value) => setState(() => onChanged!(value)),
      );
    }

    if (FirebaseGlobal.auth.currentUser != null &&
        !FirebaseGlobal.auth.currentUser!.emailVerified) {
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => ChangeNotifierProvider(
                  create: (context) => model,
                  builder: (context, _) => const EmailVerificationPage())));
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CustomColors.mediumBlue,
        middle: Text(
          model.title,
          style: const TextStyle(
              color: CupertinoColors.white, fontWeight: FontWeight.bold),
        ),
        border: null,
      ),
      child: Stack(
        children: <Widget>[
          Container(
            height: size.height,
            color: CustomColors.mediumBlue,
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutQuad,
            top: keyboardOpen ? -size.height / 5.0 : 0.0,
            child: WaveWidget(
              size: size,
              yOffset: size.height / 10.0,
              color: CupertinoTheme.of(context).scaffoldBackgroundColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: DefaultTextStyle(
                    style: const TextStyle(
                        fontSize: 25.0,
                        color: CupertinoColors.black,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.transparent),
                    child: Text(
                      !model.isLogin ? 'Benvenuto!' : 'Bentornato, come va?',
                    ),
                  ),
                ),
                const SizedBox(height: 35.0),
                buildCupertinoTextFieldEmail(),
                const SizedBox(height: 10.0),
                buildCupertinoTextFieldPassword(
                    "Password",
                    1,
                    true,
                    CupertinoIcons.eye_fill,
                    CupertinoIcons.eye_slash_fill, (value) {
                  model.password = value;
                  if (checkError) checkError = false;
                }),
                const SizedBox(height: 10.0),

                //SignUp
                Column(
                  children: [
                    AnimatedScale(
                      duration: const Duration(milliseconds: 250),
                      scale: model.isLogin ? 0 : 1,
                      child: buildCupertinoTextFieldPassword(
                          "Confirm Password",
                          1,
                          true,
                          CupertinoIcons.eye_fill,
                          CupertinoIcons.eye_slash_fill,
                          (value) => {
                                model.password == value
                                    ? checkPassword = true
                                    : checkPassword = false,
                                setState(() {
                                  if (checkError) checkError = false;
                                }),
                              }),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Text(model.isLogin
                            ? "Non sei registrato?"
                            : "Sei già registrato?"),
                        const SizedBox(width: 5.0),
                        TextButton(
                          onPressed: () {
                            model.isLogin = !model.isLogin;
                            model.title =
                                model.isLogin ? "Login" : "Registrazione";
                          },
                          child: Text(
                            !model.isLogin ? "Login" : "SignUp",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: CustomColors.mediumBlue),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Visibility(
                        visible: checkError,
                        child: Text(
                          error,
                          style:
                              const TextStyle(color: CupertinoColors.systemRed),
                        )),
                    const SizedBox(height: 35.0),
                    ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                          CustomColors.mediumBlue,
                        ),
                        fixedSize:
                            MaterialStateProperty.all(Size(size.width, 65)),
                      ),
                      onPressed: () {
                        log("Email: " +
                            model.email +
                            " Password: " +
                            model.password);
                        model.isLogin
                            ? logIn(model.email, model.password)
                            : signUp(model.email, model.password);
                      },
                      child: Text(
                        model.isLogin ? "Login" : "SignUp",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
