// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UserGraph extends StatefulWidget {
  @override
  _UserGraphState createState() => _UserGraphState();
}

class _UserGraphState extends State<UserGraph> {
  final DatabaseReference userAngleDataRef =
      FirebaseDatabase.instance.ref().child('users');
  final userUid = FirebaseAuth.instance.currentUser?.uid;

  Map<String, dynamic> _angleDataMap = {};

  @override
  void initState() {
    super.initState();
    _fetchAngleData();
  }

  void _fetchAngleData() {
    userAngleDataRef
        .child('$userUid/KneeExtensionSession')
        .once()
        .then((DatabaseEvent snapshot) {
      Map<dynamic, dynamic>? sessionData =
          snapshot.snapshot.value as Map<dynamic, dynamic>?;
      Map<String, dynamic> angleDataMap = {};
      if (sessionData != null) {
        sessionData.forEach((sessionId, sessionDataMap) {
          sessionDataMap.forEach((key, value) {
            angleDataMap[key] ??= {};
            angleDataMap[key][sessionId] = value;
          });
        });
      }
      setState(() {
        _angleDataMap = angleDataMap;
      });
    }).catchError((error) {
      // Handle error
      print('Error retrieving angle data: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userUid == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('User Graph'),
        ),
        body: Center(
          child: Text('Please sign in first to view user data.'),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('User Graph'),
      ),
      body: Container(
        color: Colors.grey[300],
        child: ListView.builder(
          itemCount: _angleDataMap.length,
          itemBuilder: (BuildContext context, int index) {
            String key = _angleDataMap.keys.elementAt(index);
            Map<String, dynamic> sessionData =
                Map<String, dynamic>.from(_angleDataMap[key]!);
            List<Widget> sessionWidgets = sessionData.keys.map((sessionId) {
              String value = sessionData[sessionId].toString();
              return Text(
                '$sessionId: $value',
                style: TextStyle(
                  color: Colors.green,
                ),
              );
            }).toList();
            return Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    key,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  ...sessionWidgets,
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
