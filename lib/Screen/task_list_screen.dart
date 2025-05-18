import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/todo_provider.dart';


class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Task List Screen")),
      body: Consumer<TodoProvider>(
        builder: (context, provider, child) {
          return provider.tasks.isEmpty
              ? Center(child: Text("No tasks available"))
              : ListView.builder(
            itemCount: provider.tasks.length,
            itemBuilder: (context, index) {
              final task = provider.tasks[index];
              return ListTile(
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                leading: Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) => provider.toggleTask(index),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => provider.removeTask(index),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
