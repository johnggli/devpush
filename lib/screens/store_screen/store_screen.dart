import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:flutter/material.dart';

class StoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      ),
      body: ListView(
        children: [
          Text('Hello World!'),
        ],
      ),
    );
  }
}
