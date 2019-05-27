import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import './photos.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class DataAlbum {
  final String id;
  final String title;
  DataAlbum({this.id, this.title});

  factory DataAlbum.fromJson(json) {
    return DataAlbum(id: json['id'].toString(), title: json['title']);
  }
}

Future<List<DataAlbum>> getData() async {
  final response =
      await http.get('https://jsonplaceholder.typicode.com/albums');
  List data = json.decode(response.body);
  List<DataAlbum> items = data.map((isi) => DataAlbum.fromJson(isi)).toList();
  return items;
}

class Album extends StatefulWidget {
  @override
  _AlbumState createState() => _AlbumState(album: getData());
}

class _AlbumState extends State<Album> {
  Future<List<DataAlbum>> album;
  _AlbumState({Key key, this.album});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: album,
            builder: (id, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                List<DataAlbum> albumList = snapshot.data;
                return Container(
                  child: StaggeredGridView.countBuilder(
                    addRepaintBoundaries: true,
                    crossAxisCount: 4,
                    itemCount: albumList.length,
                    itemBuilder: (BuildContext id, int index) {
                      return GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Photos(id: albumList[index].id))
                          );
                        },
                          child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Stack(children: <Widget>[
                          Image.network(
                            'https://placeimg.com/640/480/any',
                            fit: BoxFit.fill,
                          ),
                          Center(
                              child: Text(
                            albumList[index].title,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          )),
                        ]),
                        elevation: 2,
                      ));
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
