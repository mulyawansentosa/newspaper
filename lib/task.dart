import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class DataTask {
  final String id;
  final String title;
  final bool completed;
  DataTask({this.id, this.title, this.completed});
  factory DataTask.fromJson(json) {
    return DataTask(
        id: json['id'].toString(),
        title: json['title'],
        completed: json['completed']);
  }
}

Future<List<DataTask>> getData() async {
  final response = await http.get('https://jsonplaceholder.typicode.com/todos');
  List data = json.decode(response.body);
  List<DataTask> items = data.map((i) => DataTask.fromJson(i)).toList();
  return items;
}

class Task extends StatefulWidget {
  @override
  _TaskState createState() => _TaskState(task: getData());
}

class _TaskState extends State<Task> {
  Future<List<DataTask>> task;
  _TaskState({Key key, this.task});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: task,
      builder: (id, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<DataTask> taskList = snapshot.data;
          return ListView.builder(
            itemBuilder: (id, int index) {
              if (index < taskList.length) {
                return Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Container(
                    height: 100,
                    child: ListTile(
                      leading: FlutterLogo(
                        size: 50,
                      ),
                      title: Text(
                        taskList[index].title,
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.all(2),
                );
              }
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ));
  }
}
