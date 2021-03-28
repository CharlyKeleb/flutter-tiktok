import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok/utils/config.dart';
import 'package:flutter_tiktok/utils/const.dart';
import 'package:flutter_tiktok/utils/provider/provider.dart';
import 'package:flutter_tiktok/view/auth/auth_chooser.dart';
import 'package:flutter_tiktok/view/screens/mainscreen.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_tiktok/view/screens/mainscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Config.initFirebase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Constants.appName,
        theme: Constants.darkTheme,
        home: buildHome(),
      ),
    );
  }

  buildHome() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.hasData) {
          return MainScreen();
        } else
          return AuthChooser();
      },
    );
  }
}
