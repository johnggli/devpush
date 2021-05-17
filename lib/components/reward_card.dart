import 'package:devpush/core/app_text_styles.dart';
import 'package:flutter/material.dart';

class RewardCard extends StatefulWidget {
  final Icon icon;
  final Color color;
  final int value;
  final String tooltip;

  const RewardCard({
    Key key,
    @required this.icon,
    @required this.color,
    @required this.value,
    @required this.tooltip,
  }) : super(key: key);

  @override
  _RewardCardState createState() => _RewardCardState();
}

class _RewardCardState extends State<RewardCard> {
  GlobalKey _toolTipKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final dynamic tooltip = _toolTipKey.currentState;
        tooltip.ensureTooltipVisible();
      },
      child: Tooltip(
        key: _toolTipKey,
        message: widget.tooltip,
        child: Container(
          height: 54,
          width: 54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: widget.color,
          ),
          child: Stack(
            children: [
              Center(
                child: widget.icon,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Opacity(
                  opacity: 0.3,
                  child: Container(
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  '${widget.value}',
                  style: AppTextStyles.whiteText,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
