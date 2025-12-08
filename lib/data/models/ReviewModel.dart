class ReviewModel {
  final String userId;
  final String userName;
  final String comment;
  final double rating;
  final DateTime createdAt;

  ReviewModel({
    required this.userId,
    required this.userName,
    required this.comment,
    required this.rating,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      comment: json['comment'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userName': userName,
        'comment': comment,
        'rating': rating,
        'createdAt': createdAt.toIso8601String(),
      };
}
