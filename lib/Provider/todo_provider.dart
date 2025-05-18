import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/task_model.dart';


class TodoProvider with ChangeNotifier {
  late Box<Task> _taskBox;

  TodoProvider() {
    _init();
  }

  List<Task> get tasks => _taskBox.values.toList();

  int get completedTaskCount =>
      _taskBox.values.where((task) => task.isCompleted).length;

  Future<void> _init() async {
    _taskBox = Hive.box<Task>('tasks');
    notifyListeners();
  }

  Future<void> addTask(String title) async {
    final task = Task(title: title);
    await _taskBox.add(task);
    notifyListeners();
  }

  Future<void> toggleTask(int index) async {
    final task = _taskBox.getAt(index);
    if (task != null) {
      task.isCompleted = !task.isCompleted;
      await task.save();
      notifyListeners();
    }
  }

  Future<void> removeTask(int index) async {
    await _taskBox.deleteAt(index);
    notifyListeners();
  }
}
