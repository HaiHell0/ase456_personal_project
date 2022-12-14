import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TodoListItem {
  final String date;
  final String from;
  final String to;
  final String task;
  final String tag;
  String? id;

  TodoListItem(this.date, this.from, this.to, this.task, this.tag);

  DateTime stringToDateTime(String date) {
    return DateTime.parse(date);
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'from': from,
      'to': to,
      'task': task,
      'tag': tag,
    };
  }

  TodoListItem.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        date = doc.data()!["date"],
        from = doc.data()!["from"],
        to = doc.data()!["to"],
        task = doc.data()!["task"],
        tag = doc.data()!["tag"];
}

class TodoListItemValidator {
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  interpretDate(String date) {
    if (date.toLowerCase() == "today") {
      return dateFormat.format(DateTime.now());
    } else if (DateTime.tryParse(date) != null) {
      return DateTime.parse(date);
    }
  }

  interpretTime(String time) {
    if (time.contains("AM")) {
      return time.replaceAll("AM", "");
    }
    if (time.contains("PM")) {
      time = time.replaceAll("PM", "");
      List<String> timeList = time.split(":");
      timeList[0] = (int.parse(timeList[0]) + 12).toString();
      return "${timeList[0]}:${timeList[1]}";
    } else {
      return time;
    }
  }

  String? validateDate(String? date) {
    if (date == null || date.isEmpty) {
      return "Needs Text";
    } else if (date.toLowerCase() != "today" &&
        DateTime.tryParse(date) == null) {
      return "Invalid Date format";
    }
    return null;
  }

  String? validateTime(String? from) {
    if (from == null || from.isEmpty) {
      return "Needs Time";
    }
    if (!from.contains(":") || from.contains(" ")) {
      return "Invalid time format";
    }

    return null;
  }
}
