import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  final numbers = FibonacciNumbers();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'fibonacci list',
      theme: ThemeData(
        primaryColor: Colors.blue[900],
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('fibonacci list'),
        ),
        body: FibonacciListView(numbers),
      ),
    ),
  );
}

class FibonacciNumbers {
  final cache = {0: BigInt.from(1), 1:BigInt.from(1)};
  BigInt get (int i) {
    if (!cache.containsKey(i)) {
      cache[i] = get (i-1) + get(i-2);
    }
    return cache [i];
  }
}

class FibonacciListView extends StatelessWidget {
  final FibonacciNumbers numbers;

  FibonacciListView(this.numbers);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: /*callback*/ (context, i) {
        return ListTile(
          leading: Text(
              '$i. ',
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )
          ),
          title: Text(
            '${numbers.get(i)}',
            style: TextStyle(
              fontSize: 25,
              color: Colors.blue[300],
              fontStyle: FontStyle.italic,
            )
          ),
          onTap: () {
              // set up the button
              Widget okButton = FlatButton(
                child: Text("OK"),
                textColor: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              );

              // set up the AlertDialog
              AlertDialog alert = AlertDialog(
                title: Text(
                  '${numbers.get(i)} is ' '#$i in the fibonacci sequence!',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  )
                ),
                backgroundColor: Colors.blue[900],
                shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
                actions: <Widget>[
                  okButton,
                ],
              );

              // show the dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            }
        );
      },
    );
  }
}

