import 'package:flutter/material.dart';

import 'dart:math' as math;

import 'package:google_fonts/google_fonts.dart';

class AchievementsCard extends StatefulWidget {
  final Color color;
  final IconData icon;
  final int level;

  const AchievementsCard({
    Key key,
    @required this.color,
    @required this.icon,
    @required this.level,
  }) : super(key: key);

  @override
  _AchievementsCardState createState() => _AchievementsCardState();
}

class _AchievementsCardState extends State<AchievementsCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 72,
      height: MediaQuery.of(context).size.width * 0.2,
      width: MediaQuery.of(context).size.width * 0.2,
      // color: Colors.red,
      child: Stack(
        children: [
          Center(
            child: Container(
              // height: 54,
              height: MediaQuery.of(context).size.width * 0.15,
              width: MediaQuery.of(context).size.width * 0.15,
              child: Transform.rotate(
                angle: 45 * math.pi / 180,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), //16
                    color: widget.color,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.width * 0.1,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Icon(
                widget.icon,
                color: widget.color,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: MediaQuery.of(context).size.width * 0.014,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.06,
              height: MediaQuery.of(context).size.width * 0.06,
              decoration: BoxDecoration(
                // border: Border.all(
                //     color: Colors.white,
                //     width: MediaQuery.of(context).size.width * 0.008),
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.048,
                      height: MediaQuery.of(context).size.width * 0.048,
                      decoration: BoxDecoration(
                        // border: Border.all(
                        //     color: Colors.white,
                        //     width: MediaQuery.of(context).size.width * 0.008),
                        shape: BoxShape.circle,
                        color: widget.color,
                      ),
                      child: Center(
                        child: Text(
                          '${widget.level}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
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
    );
  }
}
