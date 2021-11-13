
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todos_repository/todo_repository_core.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ValueListenableBuilder<Box<TodoModel>>(
          valueListenable: Hive.box<TodoModel>('todos').listenable(),
          builder: (context, box, _) {
            final todos = box.values.toList();
            return ListView.builder(itemBuilder: (context,index){
              return Text(todos[index].content!);
            },itemCount: todos.length,);
          }),
    );
  }
}
