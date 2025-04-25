class AuthUserInfo {
  final String id;
  final String email;
  final String authProviderToken;
  final String? name;

  AuthUserInfo({
    required this.id,
    required this.email,
    required this.authProviderToken,
    this.name,
  });
}
