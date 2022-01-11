import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wnfood/screens/add_item.dart';
import 'package:wnfood/screens/inventory.dart';

class HomePage extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Project WnFood',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 30)
                    ),
                    FlatButton(
                      color: Colors.blue[900],
                      onPressed:() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddItem()),
                        );
                      },
                      child: Text(
                        'Add Item',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontStyle: FontStyle.italic
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20)
                    ),
                    FlatButton(
                      color: Colors.blue[900],
                      onPressed:() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Inventory()),
                        );
                      },
                      child: Text(
                        'Inventory',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontStyle: FontStyle.italic
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
      ),
    );
  }
}