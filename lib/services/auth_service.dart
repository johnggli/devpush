import 'dart:convert';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;
import 'package:devpush/secret_keys.dart';

class AuthService {
  final FlutterAppAuth appAuth = FlutterAppAuth();

  Map<String, Object> parseIdToken(String idToken) {
    final List<String> parts = idToken.split('.');
    assert(parts.length == 3);

    return jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
  }

  Future<Map<String, Object>> getUserDetails(String accessToken) async {
    var url =
        Uri.https(AUTH0_DOMAIN, '/userinfo'); // https://$AUTH0_DOMAIN/userinfo
    final http.Response response = await http.get(
      url,
      headers: <String, String>{'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user details');
    }
  }

  Future<AuthorizationTokenResponse> getAuthTokenResponse() async {
    return appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(AUTH0_CLIENT_ID, AUTH0_REDIRECT_URI,
          issuer: 'https://$AUTH0_DOMAIN',
          scopes: <String>['openid', 'profile', 'offline_access'],
          promptValues: ['login']),
    );
  }

  Future<TokenResponse> getTokenResponse(String storedRefreshToken) async {
    final response = await appAuth.token(TokenRequest(
      AUTH0_CLIENT_ID,
      AUTH0_REDIRECT_URI,
      issuer: AUTH0_ISSUER,
      refreshToken: storedRefreshToken,
    ));
    return response;
  }
}
