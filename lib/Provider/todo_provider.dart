import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/task_model.dart';


class TodoProvider with ChangeNotifier {
  late Box<Task> _taskBox;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('tasks');

  TodoProvider() {
    _init();
  }

  Future<void> _init() async {
    _taskBox = Hive.box<Task>('tasks');
    await _syncFromFirebase();
    notifyListeners();
  }

  List<Task> get tasks => _taskBox.values.toList();

  int get completedTaskCount =>
      tasks.where((task) => task.isCompleted).length;

  Future<void> addTask(String title) async {
    final task = Task(title: title);
    final key = await _taskBox.add(task);
    await _dbRef.child(key.toString()).set({
      'title': title,
      'isCompleted': false,
    });
    notifyListeners();
  }

  Future<void> toggleTask(int index) async {
    final task = _taskBox.getAt(index);
    if (task != null) {
      task.isCompleted = !task.isCompleted;
      await task.save();
      await _dbRef.child(index.toString()).update({
        'isCompleted': task.isCompleted,
      });
      notifyListeners();
    }
  }

  Future<void> removeTask(int index) async {
    await _taskBox.deleteAt(index);
    await _dbRef.child(index.toString()).remove();
    notifyListeners();
  }

  Future<void> _syncFromFirebase() async {
    final snapshot = await _dbRef.get();
    if (snapshot.exists) {
      _taskBox.clear();
      final Map<dynamic, dynamic> tasksMap = snapshot.value as Map;
      for (var entry in tasksMap.entries) {
        final task = Task(
          title: entry.value['title'],
          isCompleted: entry.value['isCompleted'],
        );
        await _taskBox.add(task);
      }
    }
  }
}
