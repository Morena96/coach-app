class Token {
  final String accessToken;
  final int expiresAt;

  const Token(this.accessToken, this.expiresAt);

  bool isExpired() => DateTime.now().millisecondsSinceEpoch > expiresAt * 1000;

  @override
  String toString() => '$accessToken $expiresAt';
}
