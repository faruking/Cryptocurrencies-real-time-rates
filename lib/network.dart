import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  BuildContext context;
  String url;
  NetworkHelper(this.url, this.context);
  Future getData() async {
    try {
      http.Response response =
          await http.get(url).timeout(Duration(seconds: 15));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        return data;
      } else {
        return showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                'Error',
                style: TextStyle(color: Colors.red),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text(
                      'Please check your connection and try again',
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } on TimeoutException catch (e) {
      print(e);
    } on Error catch (e) {
      print(e);
    }
  }
}
