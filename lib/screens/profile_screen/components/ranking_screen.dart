import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_images.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:devpush/screens/profile_screen/components/rank_tile.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RankingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var databaseProvider = Provider.of<DatabaseProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppColors.lightGray,
        ),
        centerTitle: true,
        title: Text(
          'Ranque',
          style: AppTextStyles.tabTitle,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 54,
              left: 18,
              right: 18,
              bottom: 18,
            ),
            child: Column(
              children: [
                Container(
                  width: 128,
                  height: 128,
                  child: Image.asset(
                    AppImages.rank,
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                Text(
                  'Ranque dos Usuários',
                  style: GoogleFonts.nunito(
                    color: AppColors.dark,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: databaseProvider.getRankUsers(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.lightGray),
                  ),
                );
              }

              return Column(
                children: [
                  SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            width: double.maxFinite,
                            child: RankTile(
                              imageUrl: document.data()['avatarUrl'],
                              name: document.data()['login'],
                              devPoints: document.data()['devPoints'],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 48,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
