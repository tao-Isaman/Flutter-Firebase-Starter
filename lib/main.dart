import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

main(){
  runApp(Starter());
}
class Starter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StarterApp',
      home: MyCustomForm(),
    );
  }
}




class MyCustomForm extends StatefulWidget {
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}
class _MyCustomFormState extends State<MyCustomForm> {
  final name = TextEditingController();
  final something = TextEditingController();
  
  @override
  void dispose() {
    name.dispose();
    something.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final  db = Firestore.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Firebase Starter'),
        backgroundColor: Color.fromRGBO(255, 34, 0, 0.6)
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
         child: Column(    
          children: <Widget>[
            TextField(
            controller: name,
            decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'name',
            fillColor: Colors.grey[300],
            filled: true ,
             ),
            ),
            TextField(
            controller: something,
            decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'something',
            fillColor: Colors.grey[300],
            filled: true ,
             ),
            ),
            RaisedButton(
                onPressed:(){
                  Product pd = Product();
                  pd.id = "1234";
                  pd.name = name.text ;
                  pd.price = something.text;
                  createData(pd);
                  print(pd.id);
                  print(pd.name);
                  print(pd.price);
                },
                child: Text('Create',
                  style: TextStyle(color:Colors.black ),
                ),
                color: Colors.green,
              ),
              StreamBuilder<QuerySnapshot>(
            stream: db.collection('CRUD').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(children: snapshot.data.documents.map((doc) => buildItem(doc)).toList());
              } else {
                return SizedBox();
              }
            },
          )
          ],
        ),
        
      ),
      
    );
  }

  Card buildItem(DocumentSnapshot doc){
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'name: ${doc.data['name']}', 
              style: TextStyle(fontSize: 12),
            ),
            Text(
              'something: ${doc.data['name2']}', 
              style: TextStyle(fontSize: 12),
              
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SizedBox(width: 8),
                FlatButton(
                  onPressed: () => deleteData(doc),
                  child: Text('Delete'),
                ),
              ],
            )

        ],),
      ),
    );
  }
}


class Product {
  String id;
  String price;
  String name;
  String img;
  Product({this.id, this.price, this.name,this.img});
  Product.fromMap(Map snapshot,String id) :
        id = id ?? '',
        price = snapshot['price'] ?? '',
        name = snapshot['name'] ?? '',
        img = snapshot['img'] ?? '';
  toJson() {
    return {
      "price": price,
      "name": name,
      "img": img,
    };


  }
}
  void createData(object) async {
    final  db = Firestore.instance;
   // _formKey.currentState.save();
      Map<String ,String> data = <String , String> {
      "name" : object.name ,
      "name2": object.price
    };  
    print(object.name);
    print(object.price);
    print(object.id);
    DocumentReference ref = await db.collection('CRUD').add(data);
       print(ref.documentID);


    // documentReference.setData(data).whenComplete((){
    //   print("Add is Ok !");
    // }).catchError((e) => print(e));
    
  }
  void deleteData(DocumentSnapshot doc) async {
    final  db = Firestore.instance;
    await db.collection('CRUD').document(doc.documentID).delete();
  }


 













