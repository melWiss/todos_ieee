import 'dart:developer';

import 'todo_class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoFirebase {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// this function let's you sign in with google.
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Stream<List<Todo>> todoStream() async* {
    try {
      var ref = firestore
          .collection("todos")
          .where("uid", isEqualTo: auth.currentUser.uid)
          .snapshots();
      await for (var todosData in ref) {
        List<Todo> todos = [];
        todosData.docs.forEach((element) {
          todos.add(Todo.fromMap(element.data()));
        });
        yield todos;
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future checkTodo(Todo todo) async {
    try {
      var ref = firestore.collection("todos").doc(todo.id);
      await ref.update(todo.toMap());
    } catch (e) {
      throw e.toString();
    }
  }

  Future addTodo(Todo todo) async {
    try {
      var ref = firestore.collection("todos").doc();
      todo.id = ref.id;
      todo.uid = auth.currentUser.uid;
      await ref.set(todo.toMap());
    } catch (e) {
      throw e.toString();
    }
  }

  Future deleteTodo(Todo todo) async {
    try {
      var ref = firestore.collection("todos").doc(todo.id);
      await ref.delete();
    } catch (e) {
      throw e.toString();
    }
  }
}

TodoFirebase todoFirebase = TodoFirebase();
