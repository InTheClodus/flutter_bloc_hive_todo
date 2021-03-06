import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_hive_todo/blocs/todos/todos.dart';
import 'package:flutter_bloc_hive_todo/date_util.dart';
import 'package:flutter_bloc_hive_todo/test_api.dart';
import 'package:flutter_bloc_hive_todo/view/test.dart';
import 'package:flutter_bloc_hive_todo/view/todo_editor_dialog.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
        heroTag: 'add_todo_button',
        onPressed: () => showTodoEditorDialog(context),
        child: const Icon(MdiIcons.rocketLaunch),
      ),
      body:  BlocBuilder<TodosBloc, TodosState>(
        builder: (context, state) {
          if (state is TodosLoadInProgress) {
            BotToast.showLoading();
            return Container();
          } else if (state is TodosLoadSuccess) {
            Future.delayed(const Duration(seconds: 2), () {
              BotToast.closeAllLoading();
            });
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 120.0,
                  pinned: true,
                  floating: true,
                  centerTitle: true,
                  backgroundColor: Colors.teal,
                  automaticallyImplyLeading: false,
                  actions: [
                    IconButton(
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                const TestPage(),
                              ));
                          // final aa =await TestApi.getScienceArticle();
                          // print("_-------->>>${aa.data!.map((e) => e.cover).toList()}");
                        },
                        icon: Icon(Icons.add))
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      centerTitle: true,
                      title: SizedBox(
                        width: 250.0,
                        child: TypewriterAnimatedTextKit(
                          isRepeatingAnimation: false,
                          speed: const Duration(milliseconds: 50),
                          text: const ['??????'],
                          textStyle:
                          GoogleFonts.ubuntu(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      background: Image.asset(
                        'assets/images/background.jpg',
                        fit: BoxFit.fill,
                        height: 100,
                        colorBlendMode: BlendMode.color,
                        color: Colors.red,
                      )),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 10),
                      ...state.todos.map(
                            (todo) => InkWell(
                          onTap: () {
                            showTodoEditorDialog(context, todo: todo);
                          },
                          child: Slidable(
                            key: const ValueKey(0),
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  flex: 2,
                                  onPressed: (BuildContext context) async {
                                    BlocProvider.of<TodosBloc>(context).add(
                                      TodoDeleted(todo),
                                    );
                                  },
                                  backgroundColor: const Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete_forever_sharp,
                                  label: '??????',
                                ),
                                SlidableAction(
                                  flex: 2,
                                  onPressed: (BuildContext context) async {
                                    BlocProvider.of<TodosBloc>(context).add(
                                      TodoUpdated(todo),
                                    );
                                  },
                                  backgroundColor: const Color(0xFF7BC043),
                                  foregroundColor: Colors.white,
                                  icon: Icons.radio_button_unchecked,
                                  label: '??????',
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
                                              todo.content ?? "???",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: todo.done!
                                                      ? FontWeight.w100
                                                      : FontWeight.normal,
                                                  decoration: todo.done!
                                                      ? TextDecoration.lineThrough
                                                      : TextDecoration.none),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Opacity(
                                            opacity: 0.4,
                                            child: Row(
                                              children:  [
                                                const Icon(
                                                  Icons.date_range,
                                                  size: 12,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(DateUtil.formatDate(todo.time!,format: "yyyy/MM/dd"),
                                                    style: const TextStyle(
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
          return const Text("????????????");
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
