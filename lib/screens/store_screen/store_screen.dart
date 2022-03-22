import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:devpush/screens/store_screen/components/visit_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreScreen extends StatefulWidget {
  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  void onSelected(Widget detail) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => detail),
    );
  }

  @override
  Widget build(BuildContext context) {
    var databaseProvider =
        Provider.of<DatabaseProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppColors.lightGray,
        ),
        centerTitle: true,
        title: Text(
          'Loja',
          style: AppTextStyles.tabTitle,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 18),
            child: Chip(
              labelPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
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
              label: ValueListenableBuilder<int>(
                valueListenable: databaseProvider.userDevCoins,
                builder: (context, value, _) => Text(
                  '$value',
                  style: AppTextStyles.label,
                ),
              ),
              backgroundColor: AppColors.lightGray,
              // elevation: 6.0,
              shadowColor: Colors.grey[60],
              padding: EdgeInsets.all(6),
            ),
          ),
        ],
      ),
      body: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cartões de visita',
                  style: AppTextStyles.section,
                ),
                TextButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => QuizListScreen(),
                    //   ),
                    // );
                  },
                  child: Text(
                    'Ver tudo',
                    style: AppTextStyles.blueText,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4),
          Container(
            width: double.infinity,
            height: 136,
            child: StreamBuilder<QuerySnapshot>(
              stream: databaseProvider.getVisitCards(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

                return ListView(
                  scrollDirection: Axis.horizontal,
                  physics: ClampingScrollPhysics(),
                  children: [
                    SizedBox(
                      width: 18,
                    ),
                    Row(
                      children: snapshot.data.docs
                          .map((DocumentSnapshot document) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: VisitCard(
                                visitCardId: document.id,
                                title: document.data()['title'],
                                image: document.data()['image'],
                                value: document.data()['value'],
                                onTap: (value) {
                                  onSelected(value);
                                },
                              ),
                            );
                          })
                          .take(5)
                          .toList(),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
