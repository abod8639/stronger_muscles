import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/features/product/domain/entities/image_url_entity.dart';

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

  ImageUrlEntity toEntity() => ImageUrlEntity(
        thumbnail: thumbnail,
        medium: medium,
        original: original,
      );

  static ImageUrl fromEntity(ImageUrlEntity entity) => ImageUrl(
        thumbnail: entity.thumbnail,
        medium: entity.medium,
        original: entity.original,
      );
}
