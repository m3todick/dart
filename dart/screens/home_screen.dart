import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/todo_bloc.dart';
import 'package:todo_app/models/todo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список дел'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodosLoaded) {
            final todos = state.todos;
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return Dismissible(
                  key: Key(todo.id),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    context.read<TodoBloc>().add(DeleteTodo(todo.id));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Задача "${todo.title}" удалена')),
                    );
                  },
                  child: ListTile(
                    leading: Checkbox(
                      value: todo.isCompleted,
                      onChanged: (value) {
                        context.read<TodoBloc>().add(ToggleTodo(todo.id));
                      },
                    ),
                    title: Text(
                      todo.title,
                      style: TextStyle(
                        decoration: todo.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showEditDialog(context, todo),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddDialog(context),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Добавить задачу'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(hintText: 'Введите задачу'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                if (textController.text.trim().isNotEmpty) {
                  context
                      .read<TodoBloc>()
                      .add(AddTodo(textController.text.trim()));
                  Navigator.pop(context);
                }
              },
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, Todo todo) {
    final textController = TextEditingController(text: todo.title);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Редактировать задачу'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(hintText: 'Введите новый текст'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                if (textController.text.trim().isNotEmpty) {
                  context.read<TodoBloc>().add(
                        UpdateTodo(todo.id, textController.text.trim()),
                      );
                  Navigator.pop(context);
                }
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Фильтровать задачи'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Все задачи'),
                onTap: () {
                  // Реализация фильтрации
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Только выполненные'),
                onTap: () {
                  // Реализация фильтрации
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Только невыполненные'),
                onTap: () {
                  // Реализация фильтрации
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}