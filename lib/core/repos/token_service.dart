// // 🎯 Dart imports:
// import 'dart:convert';

// // 📦 Package imports:
// import 'package:http/http.dart' as http;

// class TokenResponse {
//   final String token;
//   final String apiKey;

//   const TokenResponse(this.token, this.apiKey);

//   factory TokenResponse.fromJson(Map<String, dynamic> json) =>
//       TokenResponse(json['token'], json['apiKey']);
// }

// class TokenService {
//   const TokenService();

//   Future<TokenResponse> loadToken({
//     required String userId,
//     Duration? expiresIn,
//   }) async {
//     final queryParameters = <String, dynamic>{
//       'environment': 'pronto',
//       'user_id': userId,
//     };
//     if (expiresIn != null) {
//       queryParameters['exp'] = expiresIn.inSeconds.toString();
//     }

//     final uri = Uri(
//       scheme: 'https',
//       host: 'pronto.getstream.io',
//       path: '/api/auth/create-token',
//       queryParameters: queryParameters,
//     );

//     final response = await http.get(uri);
//     final body = json.decode(response.body) as Map<String, dynamic>;
//     return TokenResponse.fromJson(body);
//   }
// }
// 🎯 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:http/http.dart' as http;

class TokenResponse {
  final String token;
  final String apiKey;

  const TokenResponse(this.token, this.apiKey);

  factory TokenResponse.fromJson(Map<String, dynamic> json) =>
      TokenResponse(json['token'], json['apiKey']);
}

class TokenService {
  const TokenService();

  Future<TokenResponse> loadToken({
    required String userId,
    Duration? expiresIn,
  }) async {
    final functions = FirebaseFunctions.instance;
    final callable = functions.httpsCallable('generateStreamChatToken');
    final response = await callable.call(<String, dynamic>{
      'uid': userId,
    });
    final jsonResponseVal = {
      'token': response.data['token'],
      'apiKey': 'n63pcc3ue78p'
    };
    print(jsonResponseVal['token']);
    return TokenResponse.fromJson(jsonResponseVal);
  }
}
