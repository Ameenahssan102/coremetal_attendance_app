class AuthReq {
  String? clientId;
  String? clientSecret;
  String? grantType;
  String? username;
  String? password;

  AuthReq({
    this.clientId,
    this.clientSecret,
    this.grantType,
    this.username,
    this.password,
  });

  factory AuthReq.fromJson(Map<String, dynamic> json) => AuthReq(
        clientId: json["client_id"],
        clientSecret: json["client_secret"],
        grantType: json["grant_type"],
        username: json["username"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "client_id": clientId,
        "client_secret": clientSecret,
        "grant_type": grantType,
        "username": username,
        "password": password,
      };
}

class AuthRes {
  String? tokenType;
  int? expiresIn;
  String? accessToken;
  String? refreshToken;

  AuthRes({
    this.tokenType,
    this.expiresIn,
    this.accessToken,
    this.refreshToken,
  });

  factory AuthRes.fromJson(Map<String, dynamic> json) => AuthRes(
        tokenType: json["token_type"],
        expiresIn: json["expires_in"],
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
      );

  Map<String, dynamic> toJson() => {
        "token_type": tokenType,
        "expires_in": expiresIn,
        "access_token": accessToken,
        "refresh_token": refreshToken,
      };
}
