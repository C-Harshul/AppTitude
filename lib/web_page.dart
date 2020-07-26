import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'Firebase/add_category.dart';
class WebSearch extends StatefulWidget {
  WebSearch({this.searchParam});
  String searchParam ;
  String  currentUrl;
  @override
  _WebSearchState createState() => _WebSearchState();
}

class _WebSearchState extends State<WebSearch> {
  String currentUrl;
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  StreamSubscription<String> _onUrlChanged;

  @override
  void initState() {
    super.initState();

    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          widget.currentUrl =  url;
          //print(widget.currentUrl);
        });
        //print("Current URL: $url");
      }
    });
  }

  @override
  void dispose() {
    _onUrlChanged.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
   Map temp = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: WebviewScaffold(
      key: scaffoldKey,
      url: 'https://www.google.com/search?q=${temp['param']}',
      hidden: true,
      //appBar: AppBar(title: Text("Current Url")),
    ),

      appBar: AppBar(
        backgroundColor: Color(0xFF0A0E21),
        actions: [
          IconButton(
            onPressed: (){
            //print(widget.currentUrl);
            AddCategories.updateCategoryData(temp['param'],widget.currentUrl);
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
    );
  }
}
