import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'image_url_model.freezed.dart';
part 'image_url_model.g.dart';

@freezed
@HiveType(typeId: 12, adapterName: 'ImageUrlAdapter')
class ImageUrl with _$ImageUrl {
  const factory ImageUrl({
    @HiveField(0) @JsonKey(name: 'thumbnail') required String thumbnail,
    @HiveField(1) @JsonKey(name: 'medium') required String medium,
    @HiveField(2) @JsonKey(name: 'original') required String original,
  }) = _ImageUrl;

  const ImageUrl._();

  factory ImageUrl.fromJson(Map<String, dynamic> json) =>
      _$ImageUrlFromJson(json);
}
