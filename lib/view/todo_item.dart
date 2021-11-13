import 'package:flutter/material.dart';
import 'package:todos_repository/todo_repository_core.dart';

class TodoItem extends StatelessWidget {
  final DismissDirectionCallback onDismissed;
  final GestureTapCallback onTap;
  final ValueChanged<bool> onCheckboxChanged;
  final TodoModel todo;

  const TodoItem({
    Key? key,
    required this.onDismissed,
    required this.onTap,
    required this.onCheckboxChanged,
    required this.todo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: onDismissed,
      key: Key("__TodoItem__"),
      child: ListTile(
        onTap: onTap,
        leading: Checkbox(
          value: todo.done, onChanged: (bool? value) {  },
          // onChanged: onCheckboxChanged,
        ),
        title: Hero(
          tag: '${todo.category}__heroTag',
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              todo.content??"空",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ),
        subtitle: Text(
          "${todo.time}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
    );
  }
}
