import 'dart:async';

import 'package:todos_repository/todo_repository_core.dart';

class WebClient {
  final Duration delay;

  const WebClient([this.delay = const Duration(milliseconds: 3000)]);

  /// Mock that "fetches" some Todos from a "web service" after a short delay
  Future<List<TodoModel>> fetchTodos() async {
    return Future.delayed(
        delay,
        () => [
          TodoModel(
              category: TodoCategory.personal,
              color: MyColor.purple,
              content: '去散步',
              done: false,
              time: DateTime.now().subtract(const Duration(days: 1))),
          TodoModel(
              category: TodoCategory.shopping,
              color: MyColor.orange,
              content: '去工作',
              done: false,
              time: DateTime.now().subtract(const Duration(days: 2))),
          TodoModel(
              category: TodoCategory.work,
              color: MyColor.blueGrey,
              content: '去运动',
              done: true,
              time: DateTime.now().subtract(const Duration(days: 3)))
            ]);
  }

  /// Mock that returns true or false for success or failure. In this case,
  /// it will "Always Succeed"
  Future<bool> postTodos(List<TodoModel> todos) async {
    return Future.value(true);
  }
  Future<bool> deleteTodo(TodoModel todo) async {
    return Future.value(true);
  }
}
