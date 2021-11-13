// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:core';

import 'package:meta/meta.dart';
import 'package:todos_repository/todo_repository_core.dart';
import 'file_storage.dart';
import 'web_client.dart';

class TodosRepositoryFlutter implements TodoRepository {
  final FileStorage fileStorage;
  final WebClient webClient;

  const TodosRepositoryFlutter({
    required this.fileStorage,
    this.webClient = const WebClient(),
  });

  ///首先从文件存储中加载TODO。如果他们不存在或遇到
  ///错误，它试图从Web客户端加载TODO。
  @override
  Future<List<TodoModel>> loadTodos() async {
    try {
      final todos  = await fileStorage.loadTodos();
      if(todos.isEmpty){
        final todos = await webClient.fetchTodos();
        fileStorage.saveTodos(todos);
        return todos;
      }
      return todos;
    } catch (e) {
      final todos = await webClient.fetchTodos();
      fileStorage.saveTodos(todos);
      return todos;
    }
  }

  //将TODO持久化到本地磁盘和web
  @override
  Future saveTodos(List<TodoModel> todos) {
    return Future.wait<dynamic>([
      fileStorage.saveTodos(todos),
      webClient.postTodos(todos),
    ]);
  }

  @override
  Future saveTodo(TodoModel todoModel) {
    return Future.wait<dynamic>([
      fileStorage.saveTodo(todoModel)
    ]);
  }
}
