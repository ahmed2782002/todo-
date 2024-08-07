import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_do/core/provider/prefs_helper.dart';

import '../firebase/firebase_utils.dart';
import '../firebase/task.dart';

class ListProvider extends ChangeNotifier {
  List<Task> tasksList = [];
  DateTime selectDate = DateTime.now();

  void getAllTasksFromFireStore() async {
    QuerySnapshot<Task> querySnapshot =
        await FirebaseUtils.getTaskCollection().get();
    tasksList = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();
    //filtering data
    tasksList = tasksList.where((task) {
      if (task.dateTime?.day == selectDate.day &&
          task.dateTime?.month == selectDate.month &&
          task.dateTime?.year == selectDate.year) {
        return true;
      }
      return false;
    }).toList();

    tasksList.sort((Task task1, Task task2) {
      return task1.dateTime!.compareTo(task2.dateTime!);
    });
    notifyListeners();
  }

  void changeDate(DateTime newDate) {
    selectDate = newDate;
    getAllTasksFromFireStore();
    notifyListeners();
  }

  void updateTask(Task task) async {
    CollectionReference todoCollection = FirebaseUtils.getTaskCollection();
    todoCollection.doc(task.id).update(task.toFireStore()).then((value) {
      notifyListeners();
    });
  }

  ThemeMode currentTheme = ThemeMode.light;
  String currentLocale = "en";

  void init() async {
    String mode = PrefsHelper.getMode();
    if (mode == "dark") {
      changeTheme(ThemeMode.dark);
    } else {
      changeTheme(ThemeMode.light);
    }
    String? newLang = PrefsHelper.getLanguage();
    changeLocal(newLang ?? "en");
  }

// Obtain shared preferences.

// the function using Manage application theme changes
  void changeTheme(ThemeMode newTheme) {
    if (newTheme == ThemeMode.dark) {
      PrefsHelper.saveTheme("dark");
    } else {
      PrefsHelper.saveTheme("light");
    }
    currentTheme = newTheme;
    notifyListeners();
  }

  //change background the application
  // String getBackgroundImage() {
  //   return currentTheme == ThemeMode.dark
  //       ? "assets/images/background_dart.png"
  //       : "assets/images/background_light.png";
  // }

//change Splash  the application
  String splashScreen() {
    return currentTheme == ThemeMode.dark
        ? "assets/images/splash_screen_dark.png"
        : "assets/images/splash_screen.png";
  }

  // change the mode if is dark then done else light and
  // the action take in settings by use ? "light":"dark"
  bool isDarkEnabled() {
    return currentTheme == ThemeMode.dark;
  }

  // the function using Manage application languages  changes

  void changeLocal(String newLocale) {
    currentLocale = newLocale;
    PrefsHelper.saveLanguage(newLocale);
    notifyListeners();
  }
}
