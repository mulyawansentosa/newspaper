import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() => runApp(UserDetail());

class DataUserDetail {
  final int id;
  final String username;
  final String name;
  final String email;
  final String phone;
  final String website;

  DataUserDetail(
      {this.id,
      this.username,
      this.name,
      this.email,
      this.phone,
      this.website});

  factory DataUserDetail.fromJson(json) {
    return DataUserDetail(
        id: json['id'],
        username: json['username'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        website: json['website']);
  }
}


Future<List<DataUserDetail>> getData(id) async {
  final response = await http.get('https://jsonplaceholder.typicode.com/users?id=${id}');
  List data = json.decode(response.body);
  List<DataUserDetail> items = data.map((isi) => DataUserDetail.fromJson(isi)).toList();
  print(items);
  return items;
}

class UserDetail extends StatefulWidget {
  final id;
  UserDetail({Key key, this.id}) : super(key: key);
  @override
  _UserDetailState createState() => _UserDetailState(data: getData(id));
}

class _UserDetailState extends State<UserDetail> {
  Future<List<DataUserDetail>> data;
  _UserDetailState({Key key, this.data});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('User Detail'),
        ),
        body: FutureBuilder(
          future: data,
          builder: (id, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List<DataUserDetail> itemDetail = snapshot.data;
              return ListView(
                children: <Widget>[
                  Container(
                      child: Column(
                    children: <Widget>[
                      Center(
                        child: Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: FlutterLogo(size: 200),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          elevation: 5,
                          margin: EdgeInsets.all(50),
                        ),
                      ),
                      Center(
                        child: Container(
                          child: Text(
                            itemDetail[0].name,
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          child: Text(
                            itemDetail[0].username,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          child: Text(
                            itemDetail[0].email,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          child: Text(
                            itemDetail[0].phone,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          child: Text(
                            itemDetail[0].website,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ))
                ],
              );
            } else {
              return Center(
                child: LinearProgressIndicator(),
              );
            }
          },
        ));
  }
}
