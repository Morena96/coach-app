import 'package:domain/features/auth/entities/token.dart';

class TokenModel extends Token {
  const TokenModel(super.accessToken, super.expiresAt);

  factory TokenModel.fromJson(Map<String, dynamic> json) => TokenModel(
        json['access_token'] as String,
        json['expires_at'] as int,
      );

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'expires_at': expiresAt,
      };
}
