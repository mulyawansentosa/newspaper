import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class DataNews {
  final String id;
  final String title;
  final String body;

  DataNews({this.id, this.title, this.body});

  factory DataNews.fromJson(json) {
    return DataNews(
        id: json['id'].toString(), title: json['title'], body: json['body']);
  }
}

Future<List<DataNews>> getData() async {
  final response = await http.get('https://jsonplaceholder.typicode.com/posts');
  List data = json.decode(response.body);
  List<DataNews> items = data.map((i) => DataNews.fromJson(i)).toList();
  return items;
  /*
    print('Satu');
    print(items.elementAt(1).id);
    print(items.elementAt(1).title);
    print(items.elementAt(1).body);
    print('Dua');
    */
}

class News extends StatefulWidget {
//  final DataNews result = new getData();
  @override
  _NewsState createState() => _NewsState(post: getData());
}

class _NewsState extends State<News> {
  Future<List<DataNews>> post;
  _NewsState({Key key, this.post});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: post, // Fetch the data
        builder: (_, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            // If your List got fetched, them show each DataNews using a ListView
            List<DataNews> newsList = snapshot.data;
            return ListView.builder(
              itemBuilder: (_, int index) {
                if (index < newsList.length) {
                  return Row(
                    children: <Widget>[
                      Flexible(
                          flex: 1,
                          child: Container(
                              margin: EdgeInsets.all(5),
                              child: Card(
                                  child: Column(
                                children: <Widget>[
                                  Card(
                                    semanticContainer: true,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: Image.network(
                                      'https://placeimg.com/640/480/any',
                                      fit: BoxFit.fill,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 5,
                                    margin: EdgeInsets.all(10),
                                  ),
                                  Center(
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Center(
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: Text(
                                                newsList[index].title,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: Text(
                                                newsList[index].body,
                                                style: TextStyle(),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )))),
                    ],
                  );
                }
              },
            );
          } else {
            // If you have no data, show a progress indicator
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
