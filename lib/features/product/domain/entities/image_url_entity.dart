import 'package:flutter/foundation.dart';

/// Pure domain entity representing image URLs at multiple resolutions.
@immutable
class ImageUrlEntity {
  final String thumbnail;
  final String medium;
  final String original;

  const ImageUrlEntity({
    required this.thumbnail,
    required this.medium,
    required this.original,
  });

  ImageUrlEntity copyWith({
    String? thumbnail,
    String? medium,
    String? original,
  }) {
    return ImageUrlEntity(
      thumbnail: thumbnail ?? this.thumbnail,
      medium: medium ?? this.medium,
      original: original ?? this.original,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageUrlEntity &&
          runtimeType == other.runtimeType &&
          thumbnail == other.thumbnail &&
          medium == other.medium &&
          original == other.original;

  @override
  int get hashCode => thumbnail.hashCode ^ medium.hashCode ^ original.hashCode;

  @override
  String toString() =>
      'ImageUrlEntity(thumbnail: $thumbnail, medium: $medium, original: $original)';
}
