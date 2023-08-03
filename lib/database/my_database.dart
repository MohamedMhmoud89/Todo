import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/database/model/task.dart';
import 'package:todo/database/model/user.dart';

class MyDataBase {
  static CollectionReference<User> getUserCollection() {
    return FirebaseFirestore.instance
        .collection(User.collectionName)
        .withConverter<User>(fromFirestore: (snapshot, option) {
      return User.formeFireStore(snapshot.data());
    }, toFirestore: (user, option) {
      return user.toFireStore();
    });
  }

  static CollectionReference<Task> getTasksCollection(String uid) {
    return getUserCollection()
        .doc(uid)
        .collection(Task.collectionName)
        .withConverter<Task>(
          fromFirestore: (snapshot, options) =>
              Task.fromFireStore(snapshot.data()),
          toFirestore: (task, options) => task.toFireStore(),
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

  static Future<void> addTask(String uid, Task task) {
    var newTaskDoc = getTasksCollection(uid).doc();

    task.id = newTaskDoc.id;
    return newTaskDoc.set(task);
  }

  static Future<QuerySnapshot<Task>> getTasks(String uId) {
    return getTasksCollection(uId).get();
  }

  static Stream<QuerySnapshot<Task>> getTasksRealTimeUpdate(
      String uId, int date) {
    return getTasksCollection(uId).where('date', isEqualTo: date).snapshots();
  }

  static Future<void> deleteTask(String uId, String taskId) {
    return getTasksCollection(uId).doc(taskId).delete();
  }

  static Future<void> updateTask(String uid, Task task) {
    return getTasksCollection(uid).doc(task.id).update(task.toFireStore());
  }
// static Future<void> editTask(String uid, String taskId, Task task) {
//   return getTasksCollection(uid).doc(taskId).update(
//    task.toFireStore()
//   );
// }
}
