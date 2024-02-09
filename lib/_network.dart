import 'package:flutter/material.dart';
import 'package:http/http.dart' show get;


class Network extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("GET Request"),
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {
          fetchData();
        }),
      ),
    );
  }
}

void fetchData() async {
  var url = Uri.parse("https://jsonplaceholder.typicode.com/photos");
  var response = await get(url);
  print(response.body);
}

