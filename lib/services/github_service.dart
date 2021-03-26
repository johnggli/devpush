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

  // Future<void> getContributionsOfDate(String login, String date) async {
  //   var apiGithubUrl = Uri.https('api.github.com', '/users/$login/repos');
  //   final http.Response data = await http.get(apiGithubUrl);

  //   var list = jsonDecode(data.body);

  //   var dateContributionsCount = 0;
  //   for (var i = 0; i < list.length; i++) {
  //     var repoName = list[i]['name'];

  //     var repoCommits = await http
  //         .get(Uri.https('api.github.com', '/repos/$login/$repoName/commits'));

  //     var repoCommitsList = jsonDecode(repoCommits.body);

  //     for (var j = 0; j < repoCommitsList.length; j++) {
  //       if (repoCommitsList[j]['commit']['author']['date']
  //           .toString()
  //           .contains(date)) {
  //         dateContributionsCount++;
  //       }
  //     }
  //   }

  //   print(dateContributionsCount);

  //   // return jsonDecode(data.body);
  // }

  Future<void> getContributionsOfDate(String login, String date) async {
    var url = Uri.https('api.github.com', '/graphql');

    Map<String, dynamic> jsonMap = {
      'query': '''query {
            user(login: "$login") {
              name
              contributionsCollection {
                contributionCalendar {
                  colors
                  totalContributions
                  weeks {
                    contributionDays {
                      color
                      contributionCount
                      date
                      weekday
                    }
                    firstDay
                  }
                }
              }
            }
          }'''
    };
    String body = json.encode(jsonMap);

    print(body);

    final http.Response response = await http.post(
      url,
      body: body,
      // headers: <String, String>{'Authorization': 'Bearer $accessToken'},
      headers: <String, String>{
        'Authorization': 'Bearer da0d6029aeb043d256f82dff85218422d37f1480'
      },
    );

    print('Response body: ${jsonDecode(response.body)}');
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
