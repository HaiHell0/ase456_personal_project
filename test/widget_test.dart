import 'package:ase456_personal_project/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ase456_personal_project/main.dart';
import 'package:ase456_personal_project/firebase_helper.dart';
import 'package:ase456_personal_project/data_service.dart';

void main() {
  test('ToDoListItem Works', () {
    TodoListItem testTodo =
        TodoListItem('today', '10:40', '10:41', "JAVA", "TAG");
    expect(testTodo.toMap(), {
      'date': 'today',
      'from': '10:40',
      'to': '10:41',
      'task': "JAVA",
      'tag': "TAG"
    });
  });
  test('TodoListItemValidator works', () {
    TodoListItemValidator testTodo = TodoListItemValidator();
    expect(testTodo.validateDate("ToDaY"), null);
    expect(testTodo.validateTime("10:40AM"), null);
    expect(testTodo.validateTime("10:40PM"), null);
    expect(testTodo.validateTo("10:40", "10:41"), null);
    expect(
        testTodo.validateTo("10:40", "10:39"), "To must be larger than from");
    expect(testTodo.validateTime("ss:ss"), "Invalid time");
    expect(testTodo.validateTime("100:100"), "Hours or Minutes to big");
    expect(testTodo.validateTime(null), "Needs Time");
    expect(testTodo.validateTime(""), "Needs Time");
  });
/*   test('Data_service works', () async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    DatabaseService testData = DatabaseService();
    TodoListItem testTodo =
        TodoListItem('today', '10:40', '10:41', "JAVA", "asdfasdf");
    testData.addTodoListItem(testTodo);
    List<TodoListItem> test1 =
        await testData.retrieveTodoListItemsByField('tag', "asdfasdf");
    expect(test1[0].tag, "asdfasdf");
    testData.deleteTodoListItem(test1[0].id!);
    List<TodoListItem> test2 =
        await testData.retrieveTodoListItemsByField('tag', "asdfasdf");
    expect(test2.length, 0);
  }); */
}
