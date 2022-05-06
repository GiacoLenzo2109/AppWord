import 'package:app_word/database/firebase_global.dart';
import 'package:app_word/main_bottom.dart';
import 'package:app_word/res/theme_class.dart';
import 'package:app_word/ui/screens/add_word_page.dart';
import 'package:app_word/ui/screens/email_verification_page.dart';
import 'package:app_word/ui/screens/home_page.dart';
import 'package:app_word/ui/screens/signin_page.dart';
import 'package:app_word/ui/screens/search_filter_page.dart';
import 'package:app_word/ui/screens/splashscreen.dart';
import 'package:app_word/viewmodel/navbar_model.dart';
import 'package:app_word/viewmodel/search_filter_model.dart';
import 'package:app_word/viewmodel/sign_in_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NavBarModel(),
      child: CupertinoApp(
        initialRoute: "/",
        routes: {
          SplashScreen.route: (context) => const SplashScreen(),
          "/": (context) => FirebaseGlobal.auth.currentUser != null
              ? FirebaseGlobal.auth.currentUser!.emailVerified
                  ? const MainBottomClass()
                  : ChangeNotifierProvider(
                      create: (context) => SignInModel(),
                      builder: (context, _) => const EmailVerificationPage(),
                    )
              : ChangeNotifierProvider(
                  create: (_) => SignInModel(),
                  builder: (context, _) => const SignInPage(),
                ),
          SignInPage.route: (context) => ChangeNotifierProvider(
                create: (_) => SignInModel(),
                builder: (context, _) => const SignInPage(),
              ),
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeClass.lightThemeCupertino,
        //home: const MainBottomClass(),
      ),
    );
  }
}
