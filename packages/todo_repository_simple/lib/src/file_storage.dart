import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todos_repository/todo_repository_core.dart';

class FileStorage {
  const FileStorage();

  /// 加载待办事项
  Future<List<TodoModel>> loadTodos() async {
    final todoBox = await Hive.openBox<TodoModel>("todos");
    List<TodoModel> todos = [];
    todos.addAll(todoBox.values.map((e) => e).toList());
    return todos;
  }

  /// 保存全部待办事项
  Future saveTodos(List<TodoModel> todos) async {
    final settingsBox = await Hive.openBox<bool>('settings');
    final todosBox = await Hive.openBox<TodoModel>('todos');
    await todosBox.addAll(todos);
    await settingsBox.put('initialized', true);
  }

  /// 保存一条待办事项
  Future saveTodo(TodoModel todoModel) async {
    if (todoModel.isInBox) {
      final key = todoModel.key;
      Hive.box<TodoModel>('todos').put(key, todoModel);
    } else {
      await Hive.box<TodoModel>('todos').add(todoModel);
    }
  }


  Future deleteTodo(TodoModel todoModel) async {
    Hive.box<TodoModel>("todos").delete(todoModel.key);
  }
}
