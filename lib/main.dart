import 'package:ase456_personal_project/firebase_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'data_service.dart';
import 'dashboard.dart';
import 'form.dart';
import 'search.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schedule tracking app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Schedule tracking app'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    SearchMenu(),
    MyCustomForm()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-do List App'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class SearchMenu extends StatefulWidget {
  @override
  _searchMenu createState() => _searchMenu();
}

class _searchMenu extends State<SearchMenu> {
  bool isCheckedDate = false;
  bool isCheckedTag = false;
  bool isCheckedTask = false;

  final _formKey = GlobalKey<FormState>();
  TodoListItemValidator todoValidator = TodoListItemValidator();
  late String field;
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: "Field",
                labelText: 'Field',
              ),
              onChanged: (value) {
                if (isCheckedDate) field = todoValidator.interpretDate(value);
                field = value;
              },
              validator: (value) {
                if (isCheckedDate == false &&
                    isCheckedTag == false &&
                    isCheckedTask == false) {
                  return "Specify field";
                }

                if (isCheckedDate) return todoValidator.validateDate(value);
                if (value == null || value.isEmpty) {
                  return 'no text';
                }
                return null;
              },
            ),
            Row(
              children: [
                const Text("Search by Date"),
                Checkbox(
                  checkColor: Colors.white,
                  value: isCheckedDate,
                  onChanged: (bool? value) {
                    setState(() {
                      isCheckedDate = value!;
                      isCheckedTag = false;
                      isCheckedTask = false;
                    });
                  },
                )
              ],
            ),
            Row(
              children: [
                const Text("Search by Tag"),
                Checkbox(
                  checkColor: Colors.white,
                  value: isCheckedTag,
                  onChanged: (bool? value) {
                    setState(() {
                      isCheckedTag = value!;
                      isCheckedDate = false;
                      isCheckedTask = false;
                    });
                  },
                )
              ],
            ),
            Row(
              children: [
                const Text("Search by Task"),
                Checkbox(
                  checkColor: Colors.white,
                  value: isCheckedTask,
                  onChanged: (bool? value) {
                    setState(() {
                      isCheckedTask = value!;
                      isCheckedTag = false;
                      isCheckedDate = false;
                    });
                  },
                )
              ],
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (isCheckedDate) {
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (context) => SearchScreen.date(
                                todoValidator.interpretDate(field)),
                          ),
                        )
                        .then((value) => _formKey.currentState?.reset());
                  }
                  if (isCheckedTag) {
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (context) => SearchScreen.tag(field),
                          ),
                        )
                        .then((value) => _formKey.currentState?.reset());
                  }
                  if (isCheckedTask) {
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (context) => SearchScreen.task(field),
                          ),
                        )
                        .then((value) => _formKey.currentState?.reset());
                  }
                }
              },
              child: const Text('Search'),
            ),
          ],
        ));
  }
}
