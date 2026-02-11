import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/models/base_response.dart';
import '../../../../core/models/user_profile.dart';

import '../../../../core/network/models/data_wrapper.dart';

part 'profile_remote_datasource.g.dart';

@RestApi()
abstract class ProfileRemoteDataSource {
  factory ProfileRemoteDataSource(Dio dio, {String baseUrl}) =
      _ProfileRemoteDataSource;

  @GET(ApiEndpoints.studentProfile)
  Future<BaseResponse<DataWrapper<UserProfile>>> getProfile();

  @POST(ApiEndpoints.profileUpdate)
  @MultiPart()
  Future<BaseResponse<DataWrapper<UserProfile>>> updateProfile({
    @Part(name: 'name') String? name,
    @Part(name: 'avatar') MultipartFile? avatar,
  });
}
