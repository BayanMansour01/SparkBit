import 'package:json_annotation/json_annotation.dart';
import '../../../../core/models/user_profile.dart';

part 'authentication_response.g.dart';

@JsonSerializable()
class AuthenticationResponse {
  final UserProfile user;
  @JsonKey(name: 'access_token')
  final String accessToken;

  AuthenticationResponse({required this.user, required this.accessToken});

  factory AuthenticationResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthenticationResponseToJson(this);
}
