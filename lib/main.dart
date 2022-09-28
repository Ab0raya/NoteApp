import 'package:flutter/material.dart';
import 'package:note/IntroductionScreen.dart';
import 'package:note/sqldb.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AddNote.dart';
import 'home.dart';
import 'package:flutter/services.dart';

int? isViewed ;

void main() async{
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent,));
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isViewed = prefs.getInt("onboard");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
            debugShowCheckedModeBanner: false,
            home:isViewed!=0?  Introduction():home(),
            routes: {"add notes": (context) => AddNotes()},
          );

  }
}
