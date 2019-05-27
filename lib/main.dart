import 'package:flutter/material.dart';
import 'package:newspaper/news.dart';
import 'package:newspaper/album.dart';
import 'package:newspaper/task.dart';
import 'package:newspaper/users.dart';


void main() => runApp(Newspaper());

class Newspaper extends StatefulWidget {
  @override
  _NewspaperState createState() => _NewspaperState();
}

class _NewspaperState extends State<Newspaper> {
  int _index = 0;
  String title = 'Nespaper';
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    News(),
    Album(),
    Task(),
    Users()
  ];

  void _click(int index) {
    setState(() {
      _index = index;
      if(index == 0){
        title ='Newspaper';
      }else if(index == 1){
        title = 'Album';
      }else if(index == 2){
        title = 'Task';
      }else{
        title = 'Users';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
              },
            ),
          ],
        ),
        body: Center(
          child: _widgetOptions.elementAt(_index),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.new_releases),
              title: Text('News'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.photo_album),
              title: Text('Album'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.update),
              title: Text('Task'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_pin),
              title: Text('Users'),
            ),
          ],
          currentIndex: _index,
          selectedItemColor: Colors.amber[800],
          onTap: _click,
          type: BottomNavigationBarType.fixed,          
        ),
      ),
    );
  }
}