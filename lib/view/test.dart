import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_hive_todo/blocs/test/test_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todos_repository/todo_repository_core.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (context)=>TestBloc()..add(TestLoaded()),
        child: BlocBuilder<TestBloc, TestState>(
          builder: (context, state) {
            if (state is TestLoadInProgress) {
              return const Text("加载中");
            } else if (state is TestLoadSuccess) {
              return ListView(
                children:
                state.advertises.map((e) => Image.network(e.cover!)).toList(),
              );
            }
            return const Text("加载失败");
          },
        ),
      )
    );
  }
}
