import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import './userdetail.dart';

class DataUsers {
  final String id;
  final String name;
  final String email;
  DataUsers({this.id, this.name, this.email});

  factory DataUsers.fromJson(json) {
    return DataUsers(
        id: json['id'].toString(), name: json['name'], email: json['email']);
  }
}

Future<List<DataUsers>> getData() async {
  final response = await http.get('https://jsonplaceholder.typicode.com/users');
  List data = json.decode(response.body);
  List<DataUsers> items = data.map((isi) => DataUsers.fromJson(isi)).toList();
  return items;
}

class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState(users: getData());
}

class _UsersState extends State<Users> {
  Future<List<DataUsers>> users;
  _UsersState({Key key, this.users});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: users,
      builder: (id, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<DataUsers> usersList = snapshot.data;
          return ListView.builder(
            itemBuilder: (id, int index) {
              if (index < usersList.length) {
                return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => UserDetail(id: usersList[index].id))
                      );
                    },
                    child: Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Container(
                        height: 100,
                        child: ListTile(
                          leading: FlutterLogo(
                            size: 50,
                          ),
                          title: Text(
                            usersList[index].name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          subtitle: Text(
                            usersList[index].email,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          isThreeLine: true,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5,
                      margin: EdgeInsets.all(2),
                    ));
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
