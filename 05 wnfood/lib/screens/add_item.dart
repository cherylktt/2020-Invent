import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:wnfood/screens/inventory.dart';
import 'package:wnfood/screens/take_picture.dart';

class AddItem extends StatefulWidget {

  @override
  AddItemState createState() => AddItemState();
}

class AddItemState extends State<AddItem> {
  ScanResult scanResult;

  String itemName = '';
  String _date = "Set";

  String dropdownCategory = 'Dairy';
  String printCategory = '';
  String dropdownType = 'Butter';
  String printType = '';
  String dropdownStorage = 'Refrigerator';
  String printStorage = '';

  //Dropdown Menu
  List<String> _dropdownCategory = [
    'Dairy',
    'Meat',
    'Drinks',
    'Canned Food',
    'Fruits and Vegs',
    'Snacks',
    'Others'
  ];

  List<String> _dropdownType = [
    'Butter',
    'Cheese',
    'Condensed Milk',
    'Eggs',
    'Milk',
    'Yoghurt',
    'Bottled Drink',
    'Can Drink',
    'Canned Beans',
    'Canned Fruit',
    'Canned Meat',
    'Canned Snacks',
    'Fruits',
    'Vegetables',
    'Beef',
    'Fish',
    'Poultry',
    'Pork',
    'Chocolate',
    'Sweets',
    'Others'
  ];

  List<String> _dropdownStorage = [
    'Refrigerator',
    'Freezer',
    'Pantry',
    'Others'
  ];

  void getDropDownCategory() {
    setState(() {
      printCategory = dropdownCategory;
    });
  }

  void getDropDownType() {
    setState(() {
      printType = dropdownType;
    });
  }

  void getDropDownStorage() {
    setState(() {
      printStorage = dropdownStorage;
    });
  }

  //Scanner
  final _flashOnController = TextEditingController(text: "Flash on");
  final _flashOffController = TextEditingController(text: "Flash off");
  final _cancelController = TextEditingController(text: "Cancel");

  var _aspectTolerance = 0.00;
  var _numberOfCameras = 0;
  var _selectedCamera = -1;
  var _useAutoFocus = true;
  var _autoEnableFlash = false;

  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);

  List<BarcodeFormat> selectedFormats = [..._possibleFormats];

  //Camera
  String _path = null;

  void _showPhotoLibrary() async {
    final file = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _path = file.path;
    });

  }

  void _showCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TakePicturePage(camera: camera)));
    setState(() {
      _path = result;
    });
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              height: 150,
              child: Column(children: <Widget>[
                ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _showCamera();
                    },
                    leading: Icon(Icons.photo_camera),
                    title: Text("Take a picture from camera")
                ),
                ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _showPhotoLibrary();
                    },
                    leading: Icon(Icons.photo_library),
                    title: Text("Choose from photo library")
                )
              ])
          );
        }
    );
  }
  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      _numberOfCameras = await BarcodeScanner.numberOfCameras;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    var contentList = <Widget>[
      if (scanResult != null)
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 12)
              ),
              Column(children: <Widget>[
                _path == null ? Image.asset("images/place-holder.png"): Image.file(File(_path)),
                  Center(
                    child: FlatButton(
                      onPressed:() {
                        _showOptions(context);
                      },
                      child: Text(
                        "Take Picture",
                        style: TextStyle(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.blue[900],
                            width: 1,
                            style: BorderStyle.solid
                        ),
                        borderRadius: BorderRadius.circular(50),
                      )
                    ),
                  ),
                ],
              ),
              Card(
                margin: EdgeInsets.fromLTRB(20, 12, 20, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Barcode Number"),
                      Padding(padding: EdgeInsets.only(left: 30)),
                      Text(scanResult.rawContent ?? ""),
                    ],
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.fromLTRB(20, 12, 20, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Text(
                          "Item Name"
                      ),
                      Padding(padding: EdgeInsets.only(left: 30)),
                      Container(
                        width: 200,
                        height: 50,
                        child: TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder()
                            ),
                            onChanged: (itemText) {
                              itemName = itemText;
                            }
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.fromLTRB(20, 12, 20, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Text(
                          "Product Category"
                      ),
                      Padding(padding: EdgeInsets.only(left: 30)),
                      DropdownButton<String>(
                        value: dropdownCategory,
                        onChanged: (String newCategory) {
                          setState(() {
                            dropdownCategory = newCategory;
                          });
                        },
                        items: _dropdownCategory.map<DropdownMenuItem<String>>((String category) {
                          return DropdownMenuItem<String> (
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.fromLTRB(20, 12, 20, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Text(
                          "Product Type"
                      ),
                      Padding(padding: EdgeInsets.only(left: 30)),
                      DropdownButton<String>(
                        value: dropdownType,
                        onChanged: (String newType) {
                          setState(() {
                            dropdownType = newType;
                          });
                        },
                        items: _dropdownType.map<DropdownMenuItem<String>>((String type) {
                          return DropdownMenuItem<String> (
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.fromLTRB(20, 12, 20, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Text(
                          "Storage"
                      ),
                      Padding(padding: EdgeInsets.only(left: 30)),
                      DropdownButton<String>(
                        value: dropdownStorage,
                        onChanged: (String newStorage) {
                          setState(() {
                            dropdownStorage = newStorage;
                          });
                        },
                        items: _dropdownStorage.map<DropdownMenuItem<String>>((String storage) {
                          return DropdownMenuItem<String> (
                            value: storage,
                            child: Text(storage),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.fromLTRB(20, 12, 20, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Text(
                          "Expiry Date"
                      ),
                      Padding(padding: EdgeInsets.only(left: 30)),
                      Container(
                        child: Column(
                          children: <Widget> [
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              elevation: 4.0,
                              onPressed: () {
                                DatePicker.showDatePicker(context,
                                    theme: DatePickerTheme(
                                      containerHeight: 210.0,
                                    ),
                                    showTitleActions: true,
                                    minTime: DateTime(2000, 1, 1),
                                    maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                                      print('confirm $date');
                                      _date = '${date.year} - ${date.month} - ${date.day}';
                                      setState(() {});
                                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 30.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.date_range,
                                                size: 15.0,
                                                color: Colors.black,
                                              ),
                                              Text(
                                                " $_date",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15.0),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 12)
              ),
              Center(
                child: FlatButton(
                  onPressed:() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Inventory()),
                    );
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.green,
                      width: 1,
                      style: BorderStyle.solid
                    ),
                    borderRadius: BorderRadius.circular(50),
                  )
                ),
              ),
            ],
          ),
        ),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('New Product'),
          backgroundColor: Colors.blue[900],
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.camera),
              tooltip: "Scan",
              onPressed: scan,
            )
          ],
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: contentList,
        ),
      ),
    );
  }

  Future scan() async {
    try {
      var options = ScanOptions(
        strings: {
          "cancel": _cancelController.text,
          "flash_on": _flashOnController.text,
          "flash_off": _flashOffController.text,
        },
        restrictFormat: selectedFormats,
        useCamera: _selectedCamera,
        autoEnableFlash: _autoEnableFlash,
        android: AndroidOptions(
          aspectTolerance: _aspectTolerance,
          useAutoFocus: _useAutoFocus,
        ),
      );

      var result = await BarcodeScanner.scan(options: options);

      setState(() => scanResult = result);
    } on PlatformException catch (e) {
      var result = ScanResult(
        type: ResultType.Error,
        format: BarcodeFormat.unknown,
      );

      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          result.rawContent = 'The user did not grant the camera permission!';
        });
      } else {
        result.rawContent = 'Unknown error: $e';
      }
      setState(() {
        scanResult = result;
      });
    }
  }

  /*void _insert() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnName : itemName,
      DatabaseHelper.columnCategory: dropdownCategory,
      DatabaseHelper.columnType: dropdownType,
      DatabaseHelper.columnStorage: dropdownStorage,
      DatabaseHelper.columnDate: _date
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }*/
}