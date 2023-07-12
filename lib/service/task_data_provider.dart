import 'package:flutter/material.dart';

class TaskDataProvider extends ChangeNotifier {
  Map<int, bool> taskLoadingMap = {};

  void setTaskLoading(int taskId, bool isLoading) {
    taskLoadingMap[taskId] = isLoading;
    notifyListeners();
  }

  bool isTaskLoading(int taskId) {
    return taskLoadingMap[taskId] ?? false;
  }
}
