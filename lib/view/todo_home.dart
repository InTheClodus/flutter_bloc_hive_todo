import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_hive_todo/blocs/todos/todos.dart';
import 'package:flutter_bloc_hive_todo/view/test.dart';
import 'package:flutter_bloc_hive_todo/view/todo_editor_dialog.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:todos_repository/todo_repository_core.dart';

class TodoHome extends StatefulWidget {
  const TodoHome({Key? key}) : super(key: key);

  @override
  _TodoHomeState createState() => _TodoHomeState();
}

class _TodoHomeState extends State<TodoHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("待办事项"),
        actions: [
          IconButton(
              onPressed: () {
                //路由跳转  固定写法  PageA 为目标页面类名
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => TestPage()));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
        heroTag: 'add_todo_button',
        onPressed: () => showTodoEditorDialog(context),
        child: const Icon(MdiIcons.rocketLaunch),
      ),
      body: BlocBuilder<TodosBloc, TodosState>(
        builder: (context, state) {
          if (state is TodosLoadInProgress) {
            return const Text("加载中");
          } else if (state is TodosLoadSuccess) {
            return CustomScrollView(
              slivers: [
                SliverList(
                    delegate: SliverChildListDelegate([
                  const SizedBox(height: 10),
                  ...state.todos.map(
                    (todo) => InkWell(
                      onTap: () {
                        showTodoEditorDialog(context, todo: todo);
                      },
                      child: Slidable(
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          dismissible: DismissiblePane(onDismissed: () {}),
                          children: [
                            SlidableAction(
                              onPressed: (BuildContext context) {},
                              flex: 2,
                              backgroundColor: const Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: '删除',
                            ),
                          ],
                        ),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              flex: 2,
                              onPressed: (BuildContext context) async {},
                              backgroundColor: const Color(0xFF7BC043),
                              foregroundColor: Colors.white,
                              icon: Icons.radio_button_unchecked,
                              label: '完成',
                            ),
                          ],
                        ),
                        child: Card(
                          elevation: 0,
                          child: SizedBox(
                            height: 60,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: todo.done!
                                      ? Stack(
                                          alignment: Alignment.center,
                                          children: const [
                                            Icon(
                                              MdiIcons.check,
                                              color: Colors.amberAccent,
                                              size: 18,
                                            ),
                                            Icon(MdiIcons.circleOutline,
                                                color: Colors.red),
                                          ],
                                        )
                                      : const Icon(MdiIcons.circleOutline,
                                          color: Colors.cyan),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Opacity(
                                        opacity: todo.done! ? 0.4 : 1,
                                        child: Text(
                                          todo.content ?? "空",
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: todo.done!
                                                  ? FontWeight.w100
                                                  : FontWeight.normal,
                                              decoration:
                                                  TextDecoration.lineThrough),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Opacity(
                                        opacity: 0.4,
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.date_range,
                                              size: 12,
                                            ),
                                            SizedBox(width: 4),
                                            Text("'MM-dd-yyyy HH:mm'",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0) +
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: const Icon(Icons.person,
                                      color: Colors.red),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ].toList()))
              ],
            );
          }
          return const Text("加载错误");
        },
      ),
    );
  }
}

void showTodoEditorDialog(BuildContext context, {TodoModel? todo}) {
  final _todo = todo ??
      TodoModel(
          color: MyColor.red,
          category: TodoCategory.personal,
          content: '',
          time: DateTime.now(),
          done: false);

  Navigator.push(
      context,
      PageRouteBuilder(
          fullscreenDialog: true,
          opaque: false,
          barrierDismissible: true,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            if (animation.status == AnimationStatus.reverse) {
              return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child);
            } else {
              return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child);
            }
          },
          pageBuilder: (context, _, __) => TodoEditorDialog(todo: _todo)));
}
