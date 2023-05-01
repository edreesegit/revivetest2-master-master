// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';

enum AngleComponent {
  squatsCounter,
  kneeExtensionsCounter,
  heelSlidesCounter,
  bottomSquatsYAngle,
  topSquatsYAngle,
  bottomKneeExtensionsYAngle,
  topKneeExtensionsYAngle,
  bottomHeelSlidesYAngle,
  topHeelSlidesYAngle
}

class GetAngleInfo extends StatelessWidget {
  final AngleComponent component;

  GetAngleInfo({required this.component});

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
          final String squatsCounter = userData.containsKey('squatsCounter')
              ? userData['squatsCounter'].toString()
              : '';

          final String kneeExtensionsCounter =
              userData.containsKey('kneeExtensionsCounter')
                  ? userData['kneeExtensionsCounter'].toString()
                  : '';

          final String heelSlidesCounter =
              userData.containsKey('heelSlidesCounter')
                  ? userData['heelSlidesCounter'].toString()
                  : '';

          final String bottomSquatsYAngle =
              userData.containsKey('bottomSquatsYAngle')
                  ? '${userData['bottomSquatsYAngle'].toStringAsFixed(2)}\u00B0'
                  : '';

          final String topSquatsYAngle = userData.containsKey('topSquatsYAngle')
              ? '${userData['topSquatsYAngle'].toStringAsFixed(2)}\u00B0'
              : '';

          final String bottomHeelSlidesYAngle = userData
                  .containsKey('bottomHeelSlidesYAngle')
              ? '${userData['bottomHeelSlidesYAngle'].toStringAsFixed(2)}\u00B0'
              : '';

          final String topHeelSlidesYAngle = userData
                  .containsKey('topHeelSlidesYAngle')
              ? '${userData['topHeelSlidesYAngle'].toStringAsFixed(2)}\u00B0'
              : '';

          final String bottomKneeExtensionsYAngle = userData
                  .containsKey('bottomKneeExtensionsYAngle')
              ? '${userData['bottomKneeExtensionsYAngle'].toStringAsFixed(2)}\u00B0'
              : '';

          final String topKneeExtensionsYAngle = userData
                  .containsKey('topKneeExtensionsYAngle')
              ? '${userData['topKneeExtensionsYAngle'].toStringAsFixed(2)}\u00B0'
              : '';

          switch (component) {
            case AngleComponent.squatsCounter:
              return Text(
                squatsCounter,
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
                  fontSize: 128,
                  color: Colors.lightGreen[800],
                  fontWeight: FontWeight.bold,
                ),
              );
            case AngleComponent.heelSlidesCounter:
              return Text(
                heelSlidesCounter,
                style: GoogleFonts.raleway(
                  fontSize: 128,
                  color: Colors.lightGreen[800],
                  fontWeight: FontWeight.bold,
                ),
              );
            case AngleComponent.bottomSquatsYAngle:
              return Text(
                bottomSquatsYAngle,
                style: GoogleFonts.raleway(
                  fontSize: 36,
                  color: Colors.lightGreen[800],
                  fontWeight: FontWeight.bold,
                ),
              );
            case AngleComponent.topSquatsYAngle:
              return Text(
                topSquatsYAngle,
                style: GoogleFonts.raleway(
                  fontSize: 36,
                  color: Colors.lightGreen[800],
                  fontWeight: FontWeight.bold,
                ),
              );
            case AngleComponent.bottomKneeExtensionsYAngle:
              return Text(
                bottomKneeExtensionsYAngle,
                style: GoogleFonts.raleway(
                  fontSize: 36,
                  color: Colors.lightGreen[800],
                  fontWeight: FontWeight.bold,
                ),
              );
            case AngleComponent.topKneeExtensionsYAngle:
              return Text(
                topKneeExtensionsYAngle,
                style: GoogleFonts.raleway(
                  fontSize: 36,
                  color: Colors.lightGreen[800],
                  fontWeight: FontWeight.bold,
                ),
              );
            case AngleComponent.bottomHeelSlidesYAngle:
              return Text(
                bottomHeelSlidesYAngle,
                style: GoogleFonts.raleway(
                  fontSize: 36,
                  color: Colors.lightGreen[800],
                  fontWeight: FontWeight.bold,
                ),
              );
            case AngleComponent.topHeelSlidesYAngle:
              return Text(
                topHeelSlidesYAngle,
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
