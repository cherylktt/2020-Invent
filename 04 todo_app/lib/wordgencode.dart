import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'startup name gen',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue[900],
        accentColor: Colors.black,
      ),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final List<WordPair> _suggestions = <WordPair>[];
  final Set<WordPair> _saved = Set<WordPair>();
  final _textStyle = TextStyle(
      fontSize: 20.0, fontStyle: FontStyle.italic, color: Colors.blue[600]);
  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>( //add 20 lines from here
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
                (WordPair pair) {
              return ListTile(
                  title: Text(
                    pair.asLowerCase,
                    style: _textStyle,
                  ),
                  trailing: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  onTap: () {
                    setState(() {
                      _saved.remove(pair);
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
              title: Text('saved suggestions'),
            ),
            body: ListView(children:divided),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('startup name gen'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed:_pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: /*callback*/ (context, i) {
          if (i.isOdd) return Divider();
          /* one pixel high divider */

          final index = i ~/ 2; /* no. of word pairings */
          if (index >= _suggestions.length) {
            _suggestions
                .addAll(generateWordPairs().take(10)); /* + 10 more words */
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);
    return ListTile(
        title: Text(
          pair.asLowerCase,
          style: _textStyle,
        ),
        trailing: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.blue[600] : Colors.white,
        ),
        onTap: () {
          setState(() {
            if (alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        }
    );
  }
}
