import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_helper.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  addTodoListItem(TodoListItem todoListItemData) async {
    await _db.collection("todolist").add(todoListItemData.toMap());
  }

  updateTodoListItem(TodoListItem todoListItemData) async {
    await _db
        .collection("todolist")
        .doc(todoListItemData.id)
        .update(todoListItemData.toMap());
  }

  Future<void> deleteTodoListItem(String documentId) async {
    await _db.collection("todolist").doc(documentId).delete();
  }

  Future<List<TodoListItem>> retrieveTodoListItems() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("todolist").get();
    return snapshot.docs
        .map((docSnapshot) => TodoListItem.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<TodoListItem>> retrieveTodoListItemsByField(field, filter) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("todolist").where(field, whereIn: [filter]).get();
    return snapshot.docs
        .map((docSnapshot) => TodoListItem.fromDocumentSnapshot(docSnapshot))
        .toList();
  }
}
