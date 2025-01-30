import 'dart:io';
import 'task.dart';
import 'package:hive/hive.dart';
import 'todos.dart';

void main() async {
  //Hive box
  Hive.init('save');
  Hive.registerAdapter(TaskAdapter());
  Box box = await Hive.openBox('myBox');
  String listKey = 'dataList';
  List saveBox = box.get(listKey, defaultValue: [])!;
  List<Task> newList = saveBox.cast<Task>();
  Todos todos = Todos(newList);

  print('Welcome in Todos App!');

  bool isWorking = true;

  while (isWorking) {
    List<String> sprint = [
      'Please select an option',
      '1. Add a new task',
      '2. Remove a task',
      '3. View all tasks',
      '4. Mark a task as completed',
      '5. Update task title',
      '6. Save data',
      '7. Delete data',
      '8. Exit'
    ];
    for (String msg in sprint) {
      print(msg);
    }
    stdout.write('Select from 1 to ${sprint.length - 1}:');

    String? option = stdin.readLineSync();

    print('');
    switch (option) {
      case '1':
        stdout.write('Enter a task title: ');
        String? taskTitle = stdin.readLineSync();
        if (taskTitle != null) {
          todos.addTask(taskTitle);
        }
        break;
      case '2':
        stdout.write('Enter a task Id: ');
        String? taskId = stdin.readLineSync();
        todos.tryToRemoveTask(taskId);
        break;
      case '3':
        print('The new tasks');
        todos.viewTodos();
        print('*****************');
        break;
      case '4':
        stdout.write('Enter a task ID: ');
        String? taskIdString = stdin.readLineSync();
        int taskId = int.tryParse(taskIdString ?? '') ?? 0;
        if (taskId != 0) {
          todos.markTaskAsCompleted(taskId);
        }
        break;
      case '5':
        stdout.write('Enter a task ID: ');
        String? taskIdString = stdin.readLineSync();
        int taskId = int.tryParse(taskIdString ?? '') ?? 0;
        stdout.write('Enter a new title: ');
        String? newTitle = stdin.readLineSync();
        if (taskId != 0 && newTitle != null) {
          todos.updateTask(taskId, newTitle);
        }
        break;
      case '6':
        await box.put(listKey, todos.myList);
        break;
      case '7':
        await box.delete(listKey);
        todos.clearTask();
        print('Deleted');
        break;
      case '8':
        isWorking = false;
        break;
    }
  }
}
