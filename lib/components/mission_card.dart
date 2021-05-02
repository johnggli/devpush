import 'package:devpush/components/progress_bar.dart';
import 'package:flutter/material.dart';

import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/models/mission_model.dart';

class MissionCard extends StatefulWidget {
  final MissionModel mission;
  final int currentProgress;
  final VoidCallback onTap;
  const MissionCard({
    Key key,
    @required this.mission,
    @required this.currentProgress,
    @required this.onTap,
  }) : super(key: key);

  @override
  _MissionCardState createState() => _MissionCardState();
}

class _MissionCardState extends State<MissionCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.fromBorderSide(
            BorderSide(
              color: AppColors.light,
            ),
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.green,
                  ),
                  child: Icon(
                    Icons.auto_stories,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Nível ${widget.mission.level}',
                  style: AppTextStyles.greenText,
                ),
              ],
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sábio',
                    style: AppTextStyles.subHead,
                  ),
                  widget.mission.reward > 0
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            height: 36,
                            width: double.maxFinite,
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(AppColors.green),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                // side: MaterialStateProperty.all(BorderSide(color: borderColor)),
                              ),
                              onPressed: widget.onTap,
                              child: Text(
                                'Receber',
                                style: AppTextStyles.buttonText,
                              ),
                            ),
                          ),
                        )
                      : widget.mission.isCompleted
                          ? Row(
                              children: [
                                Text(
                                  'Completado',
                                  style: AppTextStyles.grayText,
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Icon(
                                  Icons.check,
                                  size: 16,
                                  color: AppColors.green,
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Alcance o level ${widget.mission.currentGoal}.',
                                  style: AppTextStyles.grayText,
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Stack(
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 1,
                                        ),
                                        ProgressBar(
                                          value: widget.currentProgress /
                                              widget.mission.currentGoal,
                                          color: AppColors.green,
                                          height: 14,
                                        ),
                                      ],
                                    ),
                                    Center(
                                      child: Text(
                                        '${widget.currentProgress}/${widget.mission.currentGoal}',
                                        style: AppTextStyles.whiteText,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
