import 'package:apptitude/web_page.dart';
import 'package:flutter/material.dart';
import 'Firebase/add_category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:webview_flutter/webview_flutter.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  dynamic data;
  Stream cards;
  List <CategoryTile> categories =[];

TextEditingController ctrl = TextEditingController();

  createAlertBox(BuildContext ctx){
    return showDialog(
        context: ctx,
         builder: (ctx){
          return AlertDialog(
            title: Text('Add category',style: TextStyle(color: Color(0xFF1D1E33),fontSize: 30,)),

            backgroundColor: Color(0xFFEB1555) ,
            content: TextField(
              style: TextStyle(color: Colors.white),
              controller: ctrl,
              maxLines: null,
            ),
            actions: <Widget>[

              FlatButton(
                child: Text('Yes',style: TextStyle(color: Colors.white)),
                onPressed: () async{
                  print(ctrl.text);
                 await AddCategories.addCategory(ctrl.text);
                 Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child:Text('No',style: TextStyle(color: Colors.white)),
                onPressed: (){
                  Navigator.pop(ctx);
                },
              ),
            ],
          );
         }
    );
  }


  @override
  Widget build(BuildContext context) {
    setState(() {

    });
    return  Scaffold(
      backgroundColor: Color(0xFF0A0E21),
      body:CategoryStream(),
      floatingActionButton: FloatingActionButton(
        backgroundColor:  Color(0xFFEB1555) ,
        onPressed: () {
           createAlertBox(context);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add,size: 40),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class CategoryStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('Users/vQ8CMAJZo4at0MmZKhFaGLPRwo93/Categories').snapshots(),
        // ignore: missing_return
        builder: (context,snapshot){
          List <CategoryTile> categories =[];
          if(snapshot.hasData){
            final cats = snapshot.data.documents;
            for(var cat in cats){
              String name;
              name = cat.data['name'];
              CategoryTile instance = CategoryTile(title:name);
              categories.add(instance);
            }
            return ListView.builder(
              itemBuilder: (ctx,index) =>CategoryTile(
                title:categories[index].title,
              ) ,
              itemCount: categories.length,
            );
          }else
            return CircularProgressIndicator();
        }
    );
  }
}

webSearch(BuildContext context){
  Navigator.pushNamed(context, '/Websearch');
}

class CategoryTile extends StatelessWidget {
  CategoryTile({this.title});
  String title;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: Card(
            color: Color(0xFF1D1E33),
            child: Center(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title,style: TextStyle(fontSize: 50,color: Colors.white)),
             )
            ),
          ),
          actions: [
            IconSlideAction(
              caption: 'Search',
              color: Color(0xFFEB1555),
              icon: Icons.web,
              onTap:() {
                 Navigator.pushNamed(context, '/Websearch',arguments: {'param':title});
              }
            ),
          ],
        ),
      ),
    );
  }
}

