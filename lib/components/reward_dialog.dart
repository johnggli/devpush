import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_images.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RewardDialog extends StatelessWidget {
  final int devPoints, devCoins;

  const RewardDialog({
    Key key,
    @required this.devPoints,
    @required this.devCoins,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                Container(
                  width: 128,
                  height: 128,
                  child: Image.asset(
                    AppImages.openGift,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "Parabéns!",
                  style: AppTextStyles.title,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.0),
                Text(
                  'Você ganhou:',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.grayText,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Chip(
                      labelPadding:
                          EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      avatar: CircleAvatar(
                        backgroundColor: AppColors.blue,
                        child: Icon(
                          Icons.bolt,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      label: Text(
                        '$devPoints',
                        style: AppTextStyles.blackText,
                      ),
                      backgroundColor: Colors.white,
                      // elevation: 6.0,
                      shadowColor: Colors.grey[60],
                      padding: EdgeInsets.all(6),
                    ),
                    Chip(
                      labelPadding:
                          EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      avatar: CircleAvatar(
                        backgroundColor: Colors.yellow[500],
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.yellow[700],
                          ),
                          child: Icon(
                            Icons.code,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                      label: Text(
                        '$devCoins',
                        style: AppTextStyles.blackText,
                      ),
                      backgroundColor: Colors.white,
                      // elevation: 6.0,
                      shadowColor: Colors.grey[60],
                      padding: EdgeInsets.all(6),
                    ),
                  ],
                ),
                // SizedBox(height: 24.0),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.maxFinite,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // To close the dialog
                      },
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: AppColors.blue,
                      ),
                      child: Text(
                        'Continuar',
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
    );
  }
}
