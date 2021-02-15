import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'fire.dart';
import 'signin_screen.dart';
import 'todo_class.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<FirebaseApp>(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return StreamBuilder<User>(
              stream: todoFirebase.auth.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return MyHomePage(
                    title: 'Flutter Demo Home Page',
                  );
                else if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text(snapshot.error.toString()),
                    ),
                  );
                }
                return SignInScreen();
              },
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text(snapshot.error.toString()),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Todo todo;

  @override
  void initState() {
    super.initState();
    todo = Todo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<List<Todo>>(
        stream: todoFirebase.todoStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0) {
              return Center(
                child: Text("There's no Todo."),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(5),
                      child: ListTile(
                        title: Text(snapshot.data[index].text),
                        subtitle:
                            Text(snapshot.data[index].date.toDate().toString()),
                        trailing: snapshot.data[index].done
                            ? Icon(
                                Icons.check,
                                color: Colors.green,
                              )
                            : Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                        onTap: () {
                          Todo todo2 = snapshot.data[index];
                          todo2.done = !todo2.done;
                          todoFirebase.checkTodo(todo2);
                        },
                        onLongPress: () {
                          todoFirebase.deleteTodo(snapshot.data[index]);
                        },
                      ),
                    ),
                  );
                },
              );
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                    top: 8,
                    left: 8,
                    right: 8,
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value) {
                        todo.text = value;
                      },
                    ),
                    OutlinedButton(
                      child: Text("Submit"),
                      onPressed: () {
                        todo.done = false;
                        todo.date = Timestamp.now();
                        todoFirebase.addTodo(todo);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
