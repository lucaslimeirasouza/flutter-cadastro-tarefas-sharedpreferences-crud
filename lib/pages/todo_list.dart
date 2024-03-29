import 'package:cadastro_tarefas_sharedpreferences_crud/repository/todo_repository.dart';
import 'package:cadastro_tarefas_sharedpreferences_crud/widgets/todo_list_item.dart';
import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final emailController = TextEditingController();
  final repository = TodoRepository();

  List<Todo> todos = [];

  String? errorMessage;

  @override
  void initState() {
    super.initState();

    repository.getTodoList().then((value) => setState(() => todos = value));
  }

  void onDelete(Todo todo) {
    final currentIndex = todos.indexOf(todo);
    setState(() => todos.remove(todo));
    repository.saveTodoList(todos);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'A tarefa ${todo.title} foi excluída',
          style: const TextStyle(
            color: Colors.black54,
          ),
        ),
        backgroundColor: Colors.white,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          onPressed: () {
            setState(() => todos.insert(currentIndex, todo));
            repository.saveTodoList(todos);
          },
          label: 'Desfazer',
        ),
      ),
    );
  }

  void showDeleteAllTodosDialogConfirmation() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
          title: const Text('Limpar tudo?'),
          content: const Text('Deseja realmente apagar todas as tarefas?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() => todos.clear());
                repository.saveTodoList(todos);
              },
              child: const Text(
                'Limpar tudo',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: 'Adicione uma tarefa',
                            errorText: errorMessage,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (emailController.text.isEmpty) {
                            setState(() => errorMessage = 'Título inválido');
                            return;
                          }

                          final newTodo = Todo(
                            title: emailController.text,
                            dateTime: DateTime.now(),
                          );

                          errorMessage = null;
                          setState(() => todos.add(newTodo));

                          emailController.clear();
                          repository.saveTodoList(todos);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.purple,
                          padding: const EdgeInsets.all(15),
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: todos
                          .map(
                            (e) => TodoListItem(
                              todo: e,
                              onDelete: onDelete,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(children: [
                    Expanded(
                      child: Text(
                        'Você possui ${todos.length} tarefas restantes',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: showDeleteAllTodosDialogConfirmation,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.purple,
                        padding: const EdgeInsets.all(15),
                      ),
                      child: const Text('Limpar tudo'),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ),
      );
}
