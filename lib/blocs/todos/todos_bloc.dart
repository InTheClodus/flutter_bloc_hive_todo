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
    on<TodoDeleted>(_onDelTodo);
    on<TodoUpdated>(_onUpdateTodo);
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
  void _onDelTodo(TodoDeleted event, Emitter<TodosState> emit) async {
    if (state is TodosLoadSuccess) {
      final updateTodos = (state as TodosLoadSuccess)
          .todos
          .where((todo) => todo.content != event.todo.content)
          .toList();
      emit(TodosLoadSuccess(todos: updateTodos));
      _deleteTodo(event.todo);
    }
  }

  /// 修改待办事项
  void _onUpdateTodo(TodoUpdated event, Emitter<TodosState> emit){
    if (state is TodosLoadSuccess) {
      final List<TodoModel> updatedTodos =
      (state as TodosLoadSuccess).todos.map((todo) {
        return todo.key == event.todo.key ? event.todo : todo;
      }).toList();
      emit(TodosLoadSuccess(todos: updatedTodos));
      TodoModel todo = event.todo;
      todo.done = !todo.done!;
      print(todo.key);
      _saveTodo(event.todo);
    }
  }

  /// 将todo事项持久化
  Future _saveTodo(TodoModel todo) {
    return todosRepository.saveTodo(todo);
  }

  Future _deleteTodo(TodoModel todo) {
    return todosRepository.deleteTodo(todo);
  }
}
