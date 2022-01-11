import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/item.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'todo app',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue[900],
        accentColor: Colors.black,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _textEditingController = TextEditingController();

  List<Item> tasks = [
    Item('get groceries'),
    Item('prepare dinner'),
    Item('do laundry'),
  ];

  final Set<Item> _starred = Set<Item>();
  final _textStyle = TextStyle(fontSize: 25.0, color: Colors.white);

  _onAddItemPressed() {
    _scaffoldKey.currentState.showBottomSheet<Null>((BuildContext context) {
      return new Container(
        decoration:
        new BoxDecoration(color: Colors.grey[900]),
        child: new Padding(
            padding: const EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 32.0),
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: 'add a task',
              ),
              onSubmitted: _onSubmit,
            )
        ),
      );
    });
  }

  _onSubmit(String s) {
    if (s.isNotEmpty) {
      tasks.add(Item(s));
      _textEditingController.clear();
      setState(() {
      });
    }
  }

  _onDeletedItem(item) {
    tasks.removeAt(item);
    setState(() {
    });
  }

  _onStarredItem(item) {
    final bool alreadyStarred = _starred.contains(item);
    setState(() {
      if (alreadyStarred) {
        IconButton(icon: Icon(Icons.star), color: Colors.red);
        _starred.remove(item);
      } else {
        IconButton(icon: Icon(Icons.star), color: Colors.white);
        _starred.add(item);
      }
    });
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _starred.map(
                  (Item item) {
                return ListTile(
                    title: Text(
                      item.asLowerCase,
                      style: _textStyle,
                    ),
                    trailing: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    onTap: () {
                      setState(() {
                        _starred.remove(item);
                        Navigator.of(context).pop();
                        _pushSaved();
                      });
                    }
                );
              }
          );
          final List<Widget> divided = ListTile
              .divideTiles(
            context: context, tiles: tiles,
          )
              .toList();
          return Scaffold(
            appBar: AppBar(
              title: Text('important tasks'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text('todo app'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.list), onPressed: _pushSaved,)
          ]
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ReorderableListView(
          onReorder: (oldIndex, newIndex) {
            setState(() {
              _updateMyItems(oldIndex, newIndex);
            });
          },
          children: List.generate(tasks.length, (index) {
            return ListTile(
              key: ValueKey(tasks),
              title: Text(
                '${tasks[index].title}',
                style: _textStyle,
              ),
              trailing: Wrap(
                spacing: 12.0,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _onDeletedItem(index),
                  ),
                  IconButton(
                    icon: Icon(Icons.star),
                    onPressed: () => _onStarredItem(index),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onAddItemPressed(),
        tooltip: 'increment',
        child: Icon(Icons.add),
      ),
    );
  }

  void _updateMyItems(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }

      var item = tasks.removeAt(oldIndex);
      tasks.insert(newIndex, item);
    });
  }
}



