import 'package:devpush/components/progress_bar.dart';
import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:flutter/material.dart';

class QuestionIndicator extends StatelessWidget {
  final int currentPage;
  final int length;
  const QuestionIndicator({
    Key key,
    @required this.currentPage,
    @required this.length,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Questão $currentPage',
                style: AppTextStyles.body,
              ),
              Text(
                'de $length',
                style: AppTextStyles.body,
              ),
            ],
          ),
          SizedBox(
            // height: 16,
            height: 6,
          ),
          ProgressBar(
            value: currentPage / length,
            color: AppColors.green,
            height: 5,
          ),
        ],
      ),
    );
  }
}
