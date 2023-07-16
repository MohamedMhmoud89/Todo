import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/database/model/task.dart';
import 'package:todo/database/model/user.dart';

class MyDataBase {
  static CollectionReference<User> getUserCollection() {
    return FirebaseFirestore.instance
        .collection(User.collectionName)
        .withConverter<User>(fromFirestore: (snapshot, option) {
      return User.formeFireStore(snapshot.data());
    }, toFirestore: (User, option) {
      return User.toFireStore();
    });
  }

  static CollectionReference<Task> getTasksCollection(String Uid) {
    return getUserCollection()
        .doc(Uid)
        .collection(Task.collectionName)
        .withConverter<Task>(
          fromFirestore: (snapshot, options) =>
              Task.fromFireStore(snapshot.data()),
          toFirestore: (Task, options) => Task.toFireStore(),
        );
  }

  static Future<void> addUser(User user) {
    var collection = getUserCollection();
    return collection.doc(user.id).set(user);
  }

  static Future<User?> readUser(String id) async {
    var collection = getUserCollection();
    var docSnapshot = await collection.doc(id).get();
    return docSnapshot.data();
  }
}
