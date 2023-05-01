// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';

enum CurrentAngleComponent { currentYAngle }

class GetCurrentAngleInfo extends StatelessWidget {
  final CurrentAngleComponent component;

  GetCurrentAngleInfo({required this.component});

  @override
  Widget build(BuildContext context) {
    final DatabaseReference usersRef =
        FirebaseDatabase.instance.ref().child('sensor_data');
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Text('User not signed in');
    }

    return StreamBuilder<DatabaseEvent>(
      stream: usersRef.onValue,
      builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
          final dynamic value = snapshot.data!.snapshot.value;
          Map<dynamic, dynamic> userData = value;

          final String currentYAngle = userData.containsKey('yAngle')
              ? '${userData['yAngle'].toStringAsFixed(2)}\u00B0'
              : '';
          switch (component) {
            case CurrentAngleComponent.currentYAngle:
              return Text(
                currentYAngle,
                style: GoogleFonts.raleway(
                  fontSize: 36,
                  color: Colors.lightGreen[800],
                  fontWeight: FontWeight.bold,
                ),
              );
          }
        } else {
          return Text('User data not found');
        }
      },
    );
  }
}
