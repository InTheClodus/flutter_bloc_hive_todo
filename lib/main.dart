import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_hive_todo/test_api.dart';
import 'package:flutter_bloc_hive_todo/view/todo_home.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:networ_common/http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_repository_simple/todo_repository_simple.dart';
import 'package:todos_repository/todo_repository_core.dart';

import 'blocs/todos/todos_bloc.dart';

void main() async{
  await _hiveSetup();
  Https().init(baseUrl: "http://1.15.188.149:8080/member/");
  TestApi.getScienceArticle();
  runApp(
    BlocProvider(
      create: (context) {
        return TodosBloc(
          const TodosRepositoryFlutter(
            fileStorage: FileStorage(),
          ),
        )..add(TodosLoaded());
      },
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        title: "待办事项",
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        home: TodoHome());
  }
}

Future<void> _hiveSetup() async {
  await Hive.initFlutter();

  Hive.registerAdapter(TodoCategoryAdapter());
  Hive.registerAdapter(MyColorAdapter());
  Hive.registerAdapter(TodoModelAdapter());
  final settingsBox = await Hive.openBox<bool>('settings');
  settingsBox.get('initialized', defaultValue: false);
  await Hive.openBox<TodoModel>('todos');

}
