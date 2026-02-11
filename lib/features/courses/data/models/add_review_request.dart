import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_review_request.freezed.dart';
part 'add_review_request.g.dart';

@freezed
abstract class AddReviewRequest with _$AddReviewRequest {
  const factory AddReviewRequest({
    @JsonKey(name: 'lesson_id') required String lessonId,
    String? rating,
    String? comment,
  }) = _AddReviewRequest;

  factory AddReviewRequest.fromJson(Map<String, dynamic> json) =>
      _$AddReviewRequestFromJson(json);

  Map<String, dynamic> toJson();
}
