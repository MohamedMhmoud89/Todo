import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/database/model/task.dart';
import 'package:todo/database/model/user.dart' as MyUser;
import 'package:todo/database/my_database.dart';

class AuthProvider extends ChangeNotifier {
  MyUser.User? currentUser;

  void updateUser(MyUser.User loggedInUser) {
    currentUser = loggedInUser;
    notifyListeners();
  }

  bool isUserLoggedInBefore() {
    return FirebaseAuth.instance.currentUser != null;
  }

  Future<void> autoLogin() async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return;
    currentUser = await MyDataBase.readUser(firebaseUser.uid ?? "");
    return;
  }

  void logout() {
    FirebaseAuth.instance.signOut();
    currentUser = null;
  }

  void EditTask(Task task) {
    MyDataBase.updateTask(currentUser!.id!, task).then((value) {
      notifyListeners();
    });
  }
}
