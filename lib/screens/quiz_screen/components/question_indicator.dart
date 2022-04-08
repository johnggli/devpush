import 'package:devpush/components/progress_bar.dart';
import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestionIndicator extends StatelessWidget {
  final int length;
  const QuestionIndicator({
    Key key,
    @required this.length,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var databaseProvider = Provider.of<DatabaseProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Questão ${databaseProvider.currentPage}',
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
            height: 16,
          ),
          ProgressBar(
            value: databaseProvider.currentPage / length,
            color: AppColors.green,
            height: 6,
          ),
        ],
      ),
    );
  }
}
