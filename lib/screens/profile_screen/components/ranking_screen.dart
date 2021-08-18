import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_images.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/models/user_model.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:devpush/screens/profile_screen/components/rank_tile.dart';
import 'package:devpush/screens/profile_screen/profile_screen.dart';
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
              top: 42,
              left: 18,
              right: 18,
              bottom: 18,
            ),
            child: Column(
              children: [
                Container(
                  width: 96,
                  height: 96,
                  child: Image.asset(
                    AppImages.rank,
                  ),
                ),
                SizedBox(
                  height: 12,
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
          SizedBox(
            height: 8,
          ),
          FutureBuilder<QuerySnapshot>(
            future: databaseProvider.getRankUsers(),
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
                  Column(
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            UserModel user =
                                UserModel.fromJson(document.data());

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                  user: user,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 9),
                            width: double.maxFinite,
                            child: RankTile(
                              imageUrl: document.data()['avatarUrl'],
                              name: document.data()['login'],
                              devPoints: document.data()['devPoints'],
                              position: document.data()['rank'],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 42,
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
