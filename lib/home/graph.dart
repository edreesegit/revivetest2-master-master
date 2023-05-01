// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revivetest2/intro/get_angle_info.dart';

class UserGraph extends StatelessWidget {
  const UserGraph({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = 36.0;
    final containerWidth = screenWidth - 2 * horizontalPadding;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(36),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Graph',
                style: GoogleFonts.raleway(
                  fontSize: 24,
                  color: Colors.lightGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              Expanded(
                child: Container(
                  width: containerWidth,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Initial Angle:',
                        style: GoogleFonts.raleway(
                          fontSize: 24,
                          color: Colors.lightGreen[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GetAngleInfo(
                        component: AngleComponent.topSquatsYAngle,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Final Angle:',
                        style: GoogleFonts.raleway(
                          fontSize: 24,
                          color: Colors.lightGreen[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GetAngleInfo(
                        component: AngleComponent.bottomSquatsYAngle,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Squats Counter:',
                        style: GoogleFonts.raleway(
                          fontSize: 24,
                          color: Colors.lightGreen[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GetAngleInfo(
                        component: AngleComponent.squatsCounter,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
