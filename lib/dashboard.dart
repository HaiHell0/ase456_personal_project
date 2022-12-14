import 'package:ase456_personal_project/firebase_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'data_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DatabaseService service = DatabaseService();
  Future<List<TodoListItem>>? todolist;
  List<TodoListItem>? retrievedtodoList;
  @override
  void initState() {
    super.initState();
    _initRetrieval();
  }

  Future<void> _initRetrieval() async {
    todolist = service.retrieveTodoListItems();
    retrievedtodoList = await service.retrieveTodoListItems();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: todolist,
          builder: (BuildContext context,
              AsyncSnapshot<List<TodoListItem>> snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return ListView.separated(
                  itemCount: retrievedtodoList!.length,
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                  itemBuilder: (context, index) {
                    return Dismissible(
                      onDismissed: ((direction) async {
                        await service.deleteTodoListItem(
                            retrievedtodoList![index].id.toString());
                      }),
                      background: Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(16.0)),
                        padding: const EdgeInsets.only(right: 28.0),
                        alignment: AlignmentDirectional.centerEnd,
                        child: const Text(
                          "DELETE",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      direction: DismissDirection.endToStart,
                      resizeDuration: const Duration(milliseconds: 200),
                      key: UniqueKey(),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(16.0)),
                        child: ListTile(
                          //edit on tap?
                          onTap: () {},
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          title: Text(retrievedtodoList![index].task),
                          subtitle: Column(children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                                "Tag: ${retrievedtodoList![index].tag}, Date: ${retrievedtodoList![index].date}"),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                                "From: ${retrievedtodoList![index].from}, To: ${retrievedtodoList![index].to}")
                          ]),
                          trailing: const Icon(Icons.arrow_right_sharp),
                        ),
                      ),
                    );
                  });
            } else if (snapshot.connectionState == ConnectionState.done &&
                retrievedtodoList!.isEmpty) {
              return Center(
                child: ListView(
                  children: const <Widget>[
                    Align(
                        alignment: AlignmentDirectional.center,
                        child: Text('No data available')),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
