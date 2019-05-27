import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class DataPhotos {
  final String id;
  final String url;
  final String title;
  DataPhotos({this.id, this.url, this.title});

  factory DataPhotos.fromJson(json) {
    return DataPhotos(
        id: json['id'].toString(), url: json['url'], title: json['title']);
  }
}

Future<List<DataPhotos>> getData(id) async {
  final response =
      await http.get('https://jsonplaceholder.typicode.com/photos?album=${id}');
  List data = json.decode(response.body);
  List<DataPhotos> items = data.map((isi) => DataPhotos.fromJson(isi)).toList();
  return items;
}

class Photos extends StatefulWidget {
  final id;
  Photos({Key key, this.id}) : super(key: key);
  @override
  _PhotosState createState() => _PhotosState(photos: getData(id));
}

class _PhotosState extends State<Photos> {
  Future<List<DataPhotos>> photos;
  _PhotosState({Key key, this.photos});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Photo'),
        ),
        body: FutureBuilder(
            future: photos,
            builder: (id, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                List<DataPhotos> photosList = snapshot.data;
                return Container(
                  child: StaggeredGridView.countBuilder(
                    addRepaintBoundaries: true,
                    crossAxisCount: 4,
                    itemCount: photosList.length,
                    itemBuilder: (BuildContext id, int index) {
                      return Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Stack(children: <Widget>[
                          Image.network(
                            photosList[index].url,
                            fit: BoxFit.fill,
                          ),
                        ]),
                        elevation: 2,
                      );
                    },
                    staggeredTileBuilder: (int index) =>
                        new StaggeredTile.count(2, index.isEven ? 2 : 1),
                    mainAxisSpacing: 0.0,
                    crossAxisSpacing: 0.0,
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
