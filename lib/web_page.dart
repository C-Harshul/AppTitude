import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
class WebSearch extends StatefulWidget {
  WebSearch({this.searchParam});
  String searchParam ;

  @override
  _WebSearchState createState() => _WebSearchState();
}

class _WebSearchState extends State<WebSearch> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
   Map temp = ModalRoute.of(context).settings.arguments;
   print(temp['param']);
    return Scaffold(
      body:WebView(
        initialUrl: 'https://www.google.com/search?q=${temp['param']}',
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){

        },
      ),
    );
  }
}
