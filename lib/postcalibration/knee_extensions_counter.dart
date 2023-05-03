// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revivetest2/intro/get_angle_info.dart';
import 'package:revivetest2/intro/get_current_angle_info.dart';
import 'package:revivetest2/intro/home_navigator.dart';

class KneeExtensionsCounter extends StatefulWidget {
  const KneeExtensionsCounter({Key? key}) : super(key: key);

  @override
  State<KneeExtensionsCounter> createState() => _KneeExtensionsCounterState();
}

class _KneeExtensionsCounterState extends State<KneeExtensionsCounter> {
  @override
  void initState() {
    super.initState();
    final userUid = FirebaseAuth.instance.currentUser?.uid;

    final DatabaseReference angleDataRef =
        FirebaseDatabase.instance.ref().child('users/$userUid/angle_data');

    angleDataRef.update({
      'KneeExtensionsCounter': 0,
    }).then((_) {
      print(
          'KneeExtensions counter initialized at ${angleDataRef.child('kneeExtensionsCounter').path}');
    }).catchError((error) {
      print('Failed to initialize kneeExtensions counter: $error');
    });
  }

  @override
  void dispose() {
    final userUid = FirebaseAuth.instance.currentUser?.uid;
    final DatabaseReference angleDataRef =
        FirebaseDatabase.instance.ref().child('users/$userUid/angle_data');
    angleDataRef.update({
      'kneeExtensionsBool': false,
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    'Knee Extensions Counter',
                    style: GoogleFonts.raleway(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(2),
              child: Column(
                children: [
                  Column(
                    children: [
                      Text(
                        'Initial Knee Extension Angle:',
                        style: GoogleFonts.raleway(
                          fontSize: 24,
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      GetAngleInfo(
                          component: AngleComponent.topKneeExtensionsYAngle),
                    ],
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      Text(
                        'Final Knee Extension Angle:',
                        style: GoogleFonts.raleway(
                          fontSize: 24,
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      GetAngleInfo(
                        component: AngleComponent.bottomKneeExtensionsYAngle,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      Text(
                        'Current Angle:',
                        style: GoogleFonts.raleway(
                          fontSize: 24,
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      GetCurrentAngleInfo(
                        component: CurrentAngleComponent.currentYAngle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 1, right: 1, bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total Knee Extensions:',
                      style: GoogleFonts.raleway(
                        fontSize: 24,
                        color: Colors.lightGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GetAngleInfo(
                        component: AngleComponent.kneeExtensionsCounter),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          _groupKneeExtensionsData();
                          await showSessionSuccessDialog();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => HomeNavigator(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen,
                          padding: EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          minimumSize: Size(double.infinity, 0),
                        ),
                        child: Text(
                          'End Session',
                          style: GoogleFonts.raleway(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future showSessionSuccessDialog() async {
    final userUid = FirebaseAuth.instance.currentUser?.uid;
    final DatabaseReference angleDataRef =
        FirebaseDatabase.instance.ref().child('users/$userUid/angle_data');
    await angleDataRef.update({
      'kneeExtensionsBool': false,
    });
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey[200],
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(
                      'Great Job!',
                      style: GoogleFonts.raleway(
                        decoration: TextDecoration.none,
                        color: Colors.lightGreen[800],
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Congratulations on completing a session! Check out the Graphs Page to view more details...',
                      style: GoogleFonts.raleway(
                        decoration: TextDecoration.none,
                        color: Colors.lightGreen[800],
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // dismiss the dialog box
                      },
                      style: ElevatedButton.styleFrom(
                        textStyle: GoogleFonts.raleway(
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
                        'OK',
                        style: GoogleFonts.raleway(
                          decoration: TextDecoration.none,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ]),
                ),
              ));
        });
  }

  final DatabaseReference userAngleDataRef =
      FirebaseDatabase.instance.ref().child('users');
  final userUid = FirebaseAuth.instance.currentUser?.uid;
  int _sessionCounter = 0;

  void _groupKneeExtensionsData() {
    // Generate a unique identifier for the session
    String sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    userAngleDataRef
        .child('$userUid')
        .child('angle_data')
        .once()
        .then((DatabaseEvent snapshot) {
      Map<dynamic, dynamic>? angleDataMap =
          snapshot.snapshot.value as Map<dynamic, dynamic>?;
      angleDataMap?.forEach((key, value) {
        // Determine which group the key belongs to
        String groupKey = '';
        if (key.contains('KneeExtensionsYAngle') ||
            key.contains('kneeExtensionsCounter')) {
          groupKey = 'Knee Extensions Data';

          // Add the key-value pair to the appropriate group
          if (groupKey.isNotEmpty) {
            // Set the key-value pair to the appropriate child node with the unique session ID
            if (groupKey == 'Knee Extensions Data') {
              userAngleDataRef
                  .child(
                      '$userUid/KneeExtensionSession/Session $sessionId/$key')
                  .set(value);
            }
          }
        }
      });

      // Update the state with the grouped angle data map
      setState(() {});
    }).catchError((error) {
      // Handle error
      print('Error retrieving angle data: $error');
    });
  }
}
