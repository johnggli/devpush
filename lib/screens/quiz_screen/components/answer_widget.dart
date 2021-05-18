import 'package:devpush/core/app_colors.dart';
import 'package:devpush/core/app_text_styles.dart';
import 'package:flutter/material.dart';

class AnswerWidget extends StatelessWidget {
  final String option;
  final String correctOption;
  final bool isSelected;
  final bool disabled;
  // final VoidCallback onTap;
  final ValueChanged<bool> onTap;

  const AnswerWidget({
    Key key,
    @required this.option,
    @required this.correctOption,
    this.isSelected = false,
    @required this.onTap,
    this.disabled = false,
  }) : super(key: key);

  bool get _isRight => option == correctOption;

  Color get _selectedColorRight =>
      _isRight ? AppColors.darkGreen : AppColors.darkRed;

  Color get _selectedBorderRight =>
      _isRight ? AppColors.lightGreen : AppColors.lightRed;

  Color get _selectedColorCardRight =>
      _isRight ? AppColors.lightGreen : AppColors.lightRed;

  Color get _selectedBorderCardRight =>
      _isRight ? AppColors.green : AppColors.red;

  TextStyle get _selectedTextStyleRight =>
      _isRight ? AppTextStyles.bodyDarkGreen : AppTextStyles.bodyDarkRed;

  IconData get _selectedIconRight => _isRight ? Icons.check : Icons.close;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: IgnorePointer(
        ignoring: disabled,
        child: GestureDetector(
          // onTap: onTap,
          onTap: () {
            onTap(_isRight);
          },
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? _selectedColorCardRight : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.fromBorderSide(
                BorderSide(
                    color: isSelected
                        ? _selectedBorderCardRight
                        : AppColors.border),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    option,
                    style: isSelected
                        ? _selectedTextStyleRight
                        : AppTextStyles.body,
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isSelected ? _selectedColorRight : Colors.white,
                    borderRadius: BorderRadius.circular(500),
                    border: Border.fromBorderSide(
                      BorderSide(
                          color: isSelected
                              ? _selectedBorderRight
                              : AppColors.border),
                    ),
                  ),
                  child: isSelected
                      ? Icon(
                          _selectedIconRight,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
