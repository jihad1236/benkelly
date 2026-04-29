
class RewardCollectionLooksUpResponse {
  final String message;

  RewardCollectionLooksUpResponse({required this.message});

  factory RewardCollectionLooksUpResponse.fromJson(Map<String, dynamic> json) {
    return RewardCollectionLooksUpResponse(
      message: json['message'] ?? '',
    );
  }
}