part of 'todos_bloc.dart';

abstract class TodosState extends Equatable {
  const TodosState();

  @override
  List<Object> get props => [];
}

/// 待办事项加载中
class TodosLoadInProgress extends TodosState {}

/// 待办事项加载完成
class TodosLoadSuccess extends TodosState {
  /// 待办事项集合
  final List<TodoModel> todos;

  const TodosLoadSuccess({this.todos = const []});

  @override
  List<Object> get props => [todos];

  @override
  String toString() => 'TodosLoadSuccess { todos: $todos }';
}

/// 待办事项加载失败
class TodosLoadFailure extends TodosState {}

/// 添加待办失败
class TodoAddFailure extends TodosState{}