import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String id;
  String text;
  bool done;
  String uid;
  Timestamp date;

  Todo({this.date, this.done, this.id, this.text, this.uid});

  Todo.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    text = map["text"];
    done = map["done"];
    uid = map["uid"];
    date = map["date"];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "text": text,
      "done": done,
      "uid": uid,
      "date": date,
    };
  }
}

Todo dummyTodo = Todo(
  date: Timestamp.now(),
  id: "sdhfbvljkfbmh<bdfkv",
  done: false,
  text: "this is a dummy todo",
  uid: "dfhbvqudbfpviqubef",
);
