import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:devpush/components/quiz_card.dart';
import 'package:devpush/screens/store_screen/components/visit_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VisitCardListScreen extends StatefulWidget {
  const VisitCardListScreen({
    Key key,
  }) : super(key: key);

  @override
  _VisitCardListScreenState createState() => _VisitCardListScreenState();
}

class _VisitCardListScreenState extends State<VisitCardListScreen> {
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
          'Cartões de Visita',
          style: AppTextStyles.tabTitle,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: databaseProvider.getVisitCards(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.blue),
              ),
            );
          }

          return ListView(
            physics: ClampingScrollPhysics(),
            children: [
              SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        width: double.maxFinite,
                        child: VisitCard(
                          visitCardId: document.id,
                          title: document.data()['title'],
                          image: document.data()['image'],
                          value: document.data()['value'],
                          onTap: (value) {
                            onSelected(value);
                          },
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
    );
  }
}
