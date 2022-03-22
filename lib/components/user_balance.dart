import 'package:devpush/core/app_text_styles.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserBalance extends StatefulWidget {
  const UserBalance({Key key}) : super(key: key);

  @override
  State<UserBalance> createState() => _UserBalanceState();
}

class _UserBalanceState extends State<UserBalance> {
  @override
  Widget build(BuildContext context) {
    var databaseProvider = Provider.of<DatabaseProvider>(context);

    return Text(
      '${databaseProvider.user.devCoins}',
      style: AppTextStyles.label,
    );
  }
}
