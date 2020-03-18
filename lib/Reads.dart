import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Reads extends StatefulWidget {
  @override
  _ReadsState createState() => _ReadsState();
}

class _ReadsState extends State<Reads> {
  List<ReadModel> readModelData = List();

  @override
  void initState() {
    super.initState();
    readData();
  }
  

  //call to Firestore
  Future<Void> readData() async {
    Firestore firestore = Firestore.instance;
    CollectionReference collectionReference = firestore.collection('CRUD');
    await collectionReference.snapshots().listen((response) {
      List<DocumentSnapshot> snapshots = response.documents;
      for (var snapshots in snapshots) {
        print('Name = ${snapshots.data['name']}');

        ReadModel readModel = ReadModel.frommap(snapshots.data);
        setState(() {
          readModelData.add(readModel);
        });
      }
    });
  }

  Widget listtoread(int index) {
    return Container(
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 15.0,
            ),
            Text(
              'Name : ${readModelData[index].name}',
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              'something : ${readModelData[index].name2}',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(
              height: 15.0,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Read'),
        ),
        body: Container(
          child: ListView.builder(
            itemCount: readModelData.length,
            itemBuilder: (BuildContext buildContext, int index) {
              return listtoread(index);
            },
          ),
        ));
  }
}

class ReadModel {
  String name, name2;

  ReadModel.frommap(Map<String, dynamic> map) {
    name = map['name'];
    name2 = map['name2'];
  }
}
