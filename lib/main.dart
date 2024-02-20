import 'package:cadastro_tarefas_sharedpreferences_crud/pages/todo_list.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(home: TodoListPage());
}
