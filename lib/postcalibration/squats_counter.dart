// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revivetest2/intro/get_angle_info.dart';

class SquatsCounter extends StatefulWidget {
  const SquatsCounter({Key? key}) : super(key: key);

  @override
  _SquatsCounterState createState() => _SquatsCounterState();
}

class _SquatsCounterState extends State<SquatsCounter> {
  @override
  void initState() {
    super.initState();
    final userUid = FirebaseAuth.instance.currentUser?.uid;
    final DatabaseReference angleDataRef =
        FirebaseDatabase.instance.ref().child('users/$userUid/angle_data');
    angleDataRef.update({
      'squatCounter': 0,
    }).then((_) {
      print(
          'Squat counter initialized at ${angleDataRef.child('squatCounter').path}');
    }).catchError((error) {
      print('Failed to initialize squat counter: $error');
    });
  }

  @override
  void dispose() {
    final userUid = FirebaseAuth.instance.currentUser?.uid;
    final DatabaseReference angleDataRef =
        FirebaseDatabase.instance.ref().child('users/$userUid/angle_data');
    angleDataRef.update({
      'squatBool': false,
    }).then((_) {
      print('Data updated at ${angleDataRef.path}');
    }).catchError((error) {
      print('Failed to update data: $error');
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Squat Counter',
                    style: GoogleFonts.raleway(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: GetAngleInfo(
                  component: AngleComponent.squatCounter,
                  style: GoogleFonts.raleway(
                    fontSize: 64,
                    color: Colors.lightGreen[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
