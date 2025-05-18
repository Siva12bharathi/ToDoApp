import 'package:flutter/material.dart';

class TodoProvider with ChangeNotifier {
  List<TodoItem> _tasks = [];

  List<TodoItem> get tasks => _tasks;

  int get completedTaskCount => _tasks.where((task) => task.isCompleted).length;

  void addTask(String title) {
    _tasks.add(TodoItem(title: title));
    notifyListeners(); // Notify UI to update
  }

  void toggleTask(int index) {
    _tasks[index].isCompleted = !_tasks[index].isCompleted;
    notifyListeners(); // Notify UI to update
  }

  void removeTask(int index) {
    _tasks.removeAt(index);
    notifyListeners(); // Notify UI to update
  }
}

class TodoItem {
  String title;
  bool isCompleted;

  TodoItem({required this.title, this.isCompleted = false});
}
