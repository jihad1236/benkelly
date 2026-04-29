
class RewardWalkingTourCompletedResponse {
  final String message;

  RewardWalkingTourCompletedResponse({required this.message});

  factory RewardWalkingTourCompletedResponse.fromJson(Map<String, dynamic> json) {
    return RewardWalkingTourCompletedResponse(
      message: json['message'] ?? '',
    );
  }
}