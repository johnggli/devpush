import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:devpush/screens/store_screen/components/visit_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreScreen extends StatelessWidget {
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
              label: Text(
                '${databaseProvider.user.devCoins}',
                style: AppTextStyles.label,
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
        padding: EdgeInsets.all(18),
        physics: ClampingScrollPhysics(),
        children: [
          VisitCard(),
          VisitCard(),
          VisitCard(),
        ],
      ),
    );
  }
}
