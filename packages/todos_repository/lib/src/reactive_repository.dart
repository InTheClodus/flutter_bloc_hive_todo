// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:core';

import 'package:todos_repository/src/todo_model.dart';


abstract class ReactiveTodosRepository {

  /// 添加新的待办
  Future<void> addNewTodo(TodoModel todo);
  /// 删除待办事项
  Future<void> deleteTodo(List<String> idList);
  /// 获取全部待办事项
  Stream<List<TodoModel>> todos();
  /// 更新待办事项
  Future<void> updateTodo(TodoModel todo);
}
