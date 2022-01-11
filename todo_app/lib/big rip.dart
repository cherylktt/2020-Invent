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

  final List<Item> _tasks = <Item>[];
  final Set<Item> _important = Set<Item>();
  final _textStyle = TextStyle(fontSize: 25.0, color: Colors.white);

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>( //add 20 lines from here
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _important.map(
                (Item task) {
              return ListTile(
                  title: Text(
                    task.asLowerCase,
                    style: _textStyle,
                  ),
                  trailing: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  onTap: () {
                    setState(() {
                      _important.remove(task);
                      Navigator.of(context).pop();
                      _pushSaved();
                    });
                  }
              );
            },
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
            body: ListView(children:divided),
          );
        },
      ),
    );
  }

  _onAddItemPressed() {
    _scaffoldKey.currentState.showBottomSheet<Null>((BuildContext context) {
      return new Container(
        decoration:
        new BoxDecoration(color: Colors.grey[900]),
        child: new Padding(
            padding: const EdgeInsets.fromLTRB(32, 32, 32, 32),
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('todo app'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved,),
        ],
      ),
      body: _buildImportant(),
    );
  }

  Widget _buildImportant() {return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemBuilder: /*callback*/ (context, i) {
        if (i.isOdd) return Divider();
        /* one pixel high divider */

        final index = i ~/ 2; /* no. of word pairings */
        if (index >= _important.length) {
          _important
              .addAll(tasks.take(10)); /* + 10 more words */
        }
        return _buildRow(tasks[index]);
      });
  }

  Widget _buildRow(Item task) {
    final bool alreadyImportant = _important.contains(task);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('todo app'),
        ),
        body: Container(
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
                  spacing: 12,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _onDeletedItem(index),
                    ),
                    IconButton(
                        icon: Icon(Icons.favorite),
                        onPressed: () {
                          setState(() {
                            if (alreadyImportant) {
                              _important.remove(task);
                            } else {
                              _important.add(task);
                            }
                          });
                        }
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
        ));
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

Container(
height: (list.length * 40).toDouble(),
padding: const EdgeInsets.all(10),
child: ReorderableListView(
children: list.map((item) {
return getItem(item);
}).toList(),
onReorder: _onReorder,
),
)


