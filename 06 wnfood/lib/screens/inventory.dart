import 'package:flutter/material.dart';
import 'package:wnfood/database/item_info.dart';
import 'package:wnfood/screens/add_item.dart';
import 'package:wnfood/database/item_brain.dart';

class Inventory extends StatefulWidget {
  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {

  List<ItemName> itemName = [
    ItemName('POKKA Jasmine Green Tea 500ml'),
    ItemName('Magnolia Chocolate Flavoured Milk 1L'),
    ItemName('Tomato Queen Red Honey (Thailand)'),
    ItemName('Sours Assort Gummy')
  ];

  List<ItemCategory> itemCategory = [
    ItemCategory('Drinks'),
    ItemCategory('Dairy'),
    ItemCategory('Fruits and Vegs'),
    ItemCategory('Snacks')
  ];

  List<ItemType> itemType = [
    ItemType('Bottled'),
    ItemType('Milk'),
    ItemType('Vegetables'),
    ItemType('Sweets')
  ];

  List<ItemStorage> itemStorage = [
    ItemStorage('Pantry'),
    ItemStorage('Refrigerator'),
    ItemStorage('Pantry'),
    ItemStorage('Pantry')
  ];

  List<ItemDate> itemDate = [
    ItemDate(6),
    ItemDate(7),
    ItemDate(14),
    ItemDate(365)
  ];

  _onDeletedItem(item) {
    itemName.removeAt(item);
    setState(() {
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Inventory'),
          backgroundColor: Colors.blue[900],
        ),
        body: _InventoryView(context),
        floatingActionButton: FloatingActionButton(
          onPressed:(){
            Navigator.push(
              context,
              MaterialPageRoute(builder:(context) => AddItem()),
            );
          },
          child: Icon(Icons.add),
        ),
    );
  }

  Widget _InventoryView(BuildContext context){
    return ListView.builder(
      itemCount: itemName.length,
      padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
      itemBuilder: (context, index) {
        return Card(
          color: itemDate[index].number < 7 ? Colors.red : Colors.green,
          child: ListTile(
            title: Text(
                '${itemName[index].title}',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                )
            ),
            subtitle: Text(
                '${itemCategory[index].title}' + ' (' + '${itemType[index].title}' + ') in the ' + '${itemStorage[index].title}' + '. Expires in ' + '${itemDate[index].number}' + ' days',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black
                )
            ),
            trailing: Wrap(
                spacing: 12.0,
                children: <Widget> [
                  IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.black,
                    iconSize: 25,
                    onPressed: () => _onDeletedItem(index),
                  ),
                  IconButton(
                    icon: Icon(Icons.border_color),
                    color: Colors.black,
                    iconSize: 25
                  )
                ]
            ),
          ),
        );
      }
    );
  }
}
