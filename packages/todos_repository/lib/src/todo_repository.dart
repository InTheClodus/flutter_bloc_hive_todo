

import '../todo_repository_core.dart';

abstract class TodoRepository {

  /// 加载待办事项
  Future<List<TodoModel>> loadTodos();
  /// 保存待办事项
  Future saveTodos(List<TodoModel> todos);
  /// 添加一个待办事项
  Future saveTodo(TodoModel todoModel);
}