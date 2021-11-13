import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_repository_simple/todo_repository_simple.dart';
import 'package:todos_repository/todo_repository_core.dart';

part 'todos_event.dart';

part 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  /// 待办事项方法
  final TodosRepositoryFlutter todosRepository;

  TodosBloc(this.todosRepository) : super(TodosLoadInProgress()) {
    on<TodosEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<TodosLoaded>(_onLoaded);
    on<TodoAdded>(_onAddTodo);
  }

  /// 加载待办事项
  void _onLoaded(TodosEvent event, Emitter<TodosState> emit) async {
    try {
      /// 获得初始默认待办事项
      final todos = await todosRepository.loadTodos();
      emit(TodosLoadSuccess(
        todos: todos,
      ));
    } catch (e) {
      emit(TodosLoadFailure());
    }
  }

  /// 添加待办事项
  void _onAddTodo(TodoAdded event, Emitter<TodosState> emit) async {
    try {
      if (state is TodosLoadSuccess) {
        emit(TodosLoadSuccess(
            todos: List.from((state as TodosLoadSuccess).todos)
              ..add(event.todo)));
        _saveTodo(event.todo);
      }
    } catch (e) {
      emit(TodoAddFailure());
    }
  }

  /// 删除待办事项
  void _onDelTodo(TodosEvent event, Emitter<TodosState> emit) async {}

  /// 修改待办事项
  void _onUpdateTodo(TodosEvent event, Emitter<TodosState> emit) async {}

  /// 将todo事项持久化
  Future _saveTodo(TodoModel todo) {
    return todosRepository.saveTodo(todo);
  }
}
