import 'package:devpush/models/user_model.dart';
import 'package:devpush/services/github_service.dart';
import 'package:flutter/widgets.dart';

final GithubService githubService = GithubService();

class GithubProvider extends ChangeNotifier {
  // private
  UserModel _user;

  // getters
  UserModel get user {
    return _user;
  }

  // functions
  Future<void> setUser(int userId) async {
    _user =
        UserModel.fromJson(await githubService.getGithubUserDetails(userId));
    notifyListeners();
  }

  Future<void> getContributionsOfDate(String date) async {
    await githubService.getContributionsOfDate(_user.login, date);
  }
}
