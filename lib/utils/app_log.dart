import 'dart:developer';

class AppLog {
  AppLog(String s);


  //print log
  //static void printLog(mgs) => log(mgs ?? "");
  static void printLog(mgs){
   // print(mgs ?? "");
    log(mgs ?? "");
  }
  //static void printLog(mgs) => log("");

}