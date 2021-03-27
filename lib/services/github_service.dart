import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:devpush/secret_keys.dart';

class GithubService {
  final String query =
      'client_id=$GITHUB_CLIENT_ID&client_secret=$GITHUB_CLIENT_SECRET';

  Future<Map<String, Object>> getGithubUserDetails(int userId) async {
    var apiGithubUrl = Uri.https('api.github.com', '/user/$userId?$query');
    final http.Response data = await http.get(apiGithubUrl);

    return jsonDecode(data.body);
  }

  Future<void> getContributionsOfDate(String login, String date) async {
    var url = Uri.https('api.github.com', '/graphql');

    // Map<String, dynamic> jsonMap = {
    //   'query': '''query {
    //         user(login: "$login") {
    //           name
    //           contributionsCollection {
    //             contributionCalendar {
    //               colors
    //               totalContributions
    //               weeks {
    //                 contributionDays {
    //                   color
    //                   contributionCount
    //                   date
    //                   weekday
    //                 }
    //                 firstDay
    //               }
    //             }
    //           }
    //         }
    //       }'''
    // };

    Map<String, dynamic> jsonMap = {
      'query': '''query {
                user(login: "$login") {
                  contributionsCollection(from:"${date}T00:00:00Z", to:"${date}T00:00:00Z") {
                    contributionCalendar{
                      totalContributions
                    }
                  }
                }
              }'''
    };
    String body = json.encode(jsonMap);

    final http.Response response = await http.post(
      url,
      body: body,
      headers: <String, String>{'Authorization': 'Bearer $GITHUB_TOKEN'},
    );

    print('Response body: ${jsonDecode(response.body)}');
  }
}
