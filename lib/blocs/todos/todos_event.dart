part of 'todos_bloc.dart';

abstract class TodosEvent extends Equatable {
  const TodosEvent();

  @override
  List<Object> get props => [];
}

/// 待办事项加载中
class TodosLoaded extends TodosEvent {}

///添加一个待办事项
class TodoAdded extends TodosEvent{
  final TodoModel todo;
  const TodoAdded(this.todo);

  @override
  List<Object> get props => [todo];

  @override
  String toString() => 'TodoAdded { todo: $todo }';
}

/// 更新一个待办事项
class TodoUpdated extends TodosEvent{
  final TodoModel todo;
  const TodoUpdated(this.todo);

  @override
  List<Object> get props => [todo];

  @override
  String toString() => 'TodoAdded { todo: $todo }';

}

/// 删除一个待办事项
class TodoDeleted extends TodosEvent{
  final TodoModel todo;
  const TodoDeleted(this.todo);

  @override
  List<Object> get props => [todo];

  @override
  String toString() => 'TodoDeleted { todo: $todo }';
}

/// 情况全部待办事项
class ClearCompleted extends TodosEvent {}

/// 选中全部待办事项
class ToggleAll extends TodosEvent {}