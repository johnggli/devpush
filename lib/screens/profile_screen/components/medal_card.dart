import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:devpush/screens/profile_screen/components/empty_medal_card.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MedalCard extends StatelessWidget {
  final String kind;
  final int medalId;
  final String date;

  const MedalCard({
    Key key,
    @required this.kind,
    @required this.medalId,
    @required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var databaseProvider = Provider.of<DatabaseProvider>(context);
    var kindColors = {
      'loginMedals': AppColors.green,
      'quizMedals': AppColors.blue,
      'postMedals': AppColors.pink,
    };

    return Container(
      child: StreamBuilder<DocumentSnapshot>(
        stream: databaseProvider.getMedalById(kind, medalId),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0.0,
                    backgroundColor: Colors.transparent,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                            top: 24,
                            bottom: 12,
                            left: 32,
                            right: 32,
                          ),
                          margin: EdgeInsets.only(top: 28),
                          decoration: new BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10.0,
                                offset: const Offset(0.0, 10.0),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize:
                                MainAxisSize.min, // To make the card compact
                            children: <Widget>[
                              Text(
                                '${snapshot.data['title']}'.toUpperCase(),
                                style: GoogleFonts.nunito(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                '${snapshot.data['desc']}',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.grayText,
                              ),
                              SizedBox(height: 24.0),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: double.maxFinite,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // To close the dialog
                                    },
                                    style: TextButton.styleFrom(
                                      primary: Colors.white,
                                      backgroundColor: AppColors.blue,
                                    ),
                                    child: Text(
                                      'fechar'.toUpperCase(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.154,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 4,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.width * 0.15,
                              width: MediaQuery.of(context).size.width * 0.15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: kindColors[kind],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.154,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 4,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.width * 0.15,
                              width: MediaQuery.of(context).size.width * 0.15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.width * 0.154,
                        width: MediaQuery.of(context).size.width * 0.154,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.width * 0.12,
                              width: MediaQuery.of(context).size.width * 0.12,
                              child: ClipOval(
                                child: FancyShimmerImage(
                                  shimmerBaseColor: Colors.grey[300],
                                  shimmerHighlightColor: Colors.grey[100],
                                  imageUrl: '${snapshot.data['img']}',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.width * 0.154,
                        width: MediaQuery.of(context).size.width * 0.154,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            width: MediaQuery.of(context).size.width * 0.02,
                            color: kindColors[kind],
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    '${snapshot.data['title']}'.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(
                      fontSize: MediaQuery.of(context).size.width * 0.026,
                      height: 1,
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                    '$date'.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(
                      fontSize: MediaQuery.of(context).size.width * 0.026,
                      // height: 1,
                      color: AppColors.lightGray,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }
          return EmptyMedalCard();
        },
      ),
    );
  }
}
