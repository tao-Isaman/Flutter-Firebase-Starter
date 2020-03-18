import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateDataFromFireStore extends StatefulWidget {
  @override
  _UpdateDataFromFireStoreState createState() =>
      _UpdateDataFromFireStoreState();
}

class _UpdateDataFromFireStoreState extends State<UpdateDataFromFireStore> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  DocumentSnapshot _currentDocument;

  _updateData() async {
    await db
        .collection('CRUD')
        .document(_currentDocument.documentID)
        .updateData(
      {'name': _controller.text, 'name2': _controller2.text},
    );
  }

  final db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update Data"),
        backgroundColor: Color.fromARGB(200, 252, 59, 10),),
      body: ListView(
        padding: EdgeInsets.all(12.0),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: 'Enter name'),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: TextField(
              controller: _controller2,
              decoration: InputDecoration(hintText: 'Enter name2'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              child: Text('Update'),
              color: Colors.red,
              onPressed: _updateData,
            ),
          ),
          SizedBox(height: 20.0),
          StreamBuilder<QuerySnapshot>(
              stream: db.collection('CRUD').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: snapshot.data.documents.map((doc) {
                      return Card(
                        color: Color.fromARGB(200, 250, 169, 142),
                          child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start
                                ,children: <Widget>[
                                Text(
                                  'Name : ${doc.data['name']}' ,
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  'Something : ${doc.data['name2']}',
                                  style: TextStyle(fontSize: 18),
                                ),
                                
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                    
                                      RaisedButton(
                                        child: Text("Edit"),
                                        color: Colors.red,
                                        onPressed: () async {
                                          setState(() {
                                            _currentDocument = doc;
                                            _controller.text = doc.data['name'];
                                            _controller2.text =
                                                doc.data['name2'];
                                          });
                                        },
                                      )
                                    ]),
                              ])),);
                    }).toList(),
                  );
                } else {
                  return SizedBox();
                }
              }),
        ],
      ),
    );
  }
}
