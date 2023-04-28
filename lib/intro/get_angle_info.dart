// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';

enum AngleComponent { squatCounter, kneeExtensionsCounter, heelSlidesCounter }

class GetAngleInfo extends StatelessWidget {
  final AngleComponent component;

  GetAngleInfo({required this.component, required TextStyle style});

  @override
  Widget build(BuildContext context) {
    final userUid = FirebaseAuth.instance.currentUser?.uid;
    final DatabaseReference usersRef =
        FirebaseDatabase.instance.ref().child('users/$userUid/angle_data');
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
          final String squatCounter = userData.containsKey('squatCounter')
              ? userData['squatCounter'].toString()
              : '';

          final String kneeExtensionsCounter =
              userData.containsKey('kneeExtensionsCounter')
                  ? userData['kneeExtensionsCounter']
                  : '';

          final String heelSlidesCounter =
              userData.containsKey('heelSlidesCounter')
                  ? userData['heelSlidesCounter']
                  : '';

          switch (component) {
            case AngleComponent.squatCounter:
              return Text(
                squatCounter,
                style: GoogleFonts.raleway(
                  fontSize: 128,
                  color: Colors.lightGreen[800],
                  fontWeight: FontWeight.bold,
                ),
              );
            case AngleComponent.kneeExtensionsCounter:
              return Text(
                kneeExtensionsCounter,
                style: GoogleFonts.raleway(
                  fontSize: 16,
                  color: Colors.lightGreen[800],
                  fontWeight: FontWeight.bold,
                ),
              );
            case AngleComponent.heelSlidesCounter:
              return Text(
                heelSlidesCounter,
                style: GoogleFonts.raleway(
                  fontSize: 16,
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
