import 'dart:convert';
// import 'package:devpush/models/contribution_model.dart';
import 'package:http/http.dart' as http;
import 'package:devpush/secret_keys.dart';
// import 'package:html/parser.dart' show parse;

class GithubService {
  final String query =
      'client_id=$GITHUB_CLIENT_ID&client_secret=$GITHUB_CLIENT_SECRET';

  Future<Map<String, Object>> getGithubUserDetails(int userId) async {
    var apiGithubUrl = Uri.https('api.github.com', '/user/$userId?$query');
    final http.Response data = await http.get(apiGithubUrl);

    return jsonDecode(data.body);
  }

  Future<void> getContributionsOfDate(int userId, String date) async {
    var apiGithubUrl = Uri.https('api.github.com', '/user/$userId/repos');
    final http.Response data = await http.get(apiGithubUrl);

    var list = jsonDecode(data.body);
    for (var i = 0; i < list.length; i++) {
      var repo = list[i];
      print(repo['commits_url']);
    }

    // return jsonDecode(data.body);
  }

  // Future<int> getContributions(String login, String date) async {
  //   var url = Uri.https('github.com', '/$login?from=$date');
  //   var res = await http.get(url);
  //   var document = parse(res.body);
  //   var rectNodes = document
  //       .querySelector('.js-calendar-graph-svg')
  //       .querySelectorAll('rect');
  //   var yearContributions = rectNodes.map((rectNode) {
  //     return Contribution(
  //       color: rectNode.attributes['fill'],
  //       count: int.tryParse(rectNode.attributes['data-count']),
  //       date: rectNode.attributes['data-date'],
  //     );
  //   }).toList();

  //   var dateIndex = yearContributions
  //       .indexWhere((contribution) => contribution.date == date);
  //   return yearContributions[dateIndex].count;
  // }
}
