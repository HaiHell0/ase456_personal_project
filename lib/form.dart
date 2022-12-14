import 'package:ase456_personal_project/firebase_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'data_service.dart';
import 'dashboard.dart';

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  late String date;
  late String from;
  late String to;
  late String tag;
  late String task;

  @override
  Widget build(BuildContext context) {
    DatabaseService service = DatabaseService();
    TodoListItemValidator todoValidator = TodoListItemValidator();

    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: "Date",
                labelText: 'Date',
              ),
              onChanged: (value) {
                date = todoValidator.interpretDate(value);
              },
              validator: (value) {
                return todoValidator.validateDate(value);
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: "From",
                labelText: 'From',
              ),
              onChanged: (value) {
                from = todoValidator.interpretTime(value);
              },
              validator: (value) {
                return todoValidator.validateTime(value);
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: "To",
                labelText: 'To',
              ),
              onChanged: (value) {
                to = todoValidator.interpretTime(value);
              },
              validator: (value) {
                return todoValidator.validateTime(value);
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: "Tag",
                labelText: 'Tag',
              ),
              onChanged: (value) {
                tag = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'no text';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: "Task",
                labelText: 'Task',
              ),
              onChanged: (value) {
                task = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'no text';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
                child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('SendingData tofireStore')));
                  TodoListItem todoListItemData =
                      TodoListItem(date, from, to, task, tag);
                  service.addTodoListItem(todoListItemData);
                }
              },
              child: const Text('Submit'),
            ))
          ],
        ));
  }
}
