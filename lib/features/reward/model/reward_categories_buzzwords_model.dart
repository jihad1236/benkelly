
class RewardCategoriesBuzzword {
  final String category;
  final List<Buzzword> buzzwords;

  RewardCategoriesBuzzword({
    required this.category,
    required this.buzzwords,
  });

  factory RewardCategoriesBuzzword.fromJson(Map<String, dynamic> json) {
    final buzzwordsList = json['buzzwords'] as List?;
    return RewardCategoriesBuzzword(
      category: json['category'] as String? ?? '',
      buzzwords: buzzwordsList
          ?.map((item) => Buzzword.fromJson(item as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}

class Buzzword {
  final String name;
  final String badge;

  Buzzword({
    required this.name,
    required this.badge,
  });

  factory Buzzword.fromJson(Map<String, dynamic> json) {
    return Buzzword(
      name: json['name'] as String? ?? '',
      badge: json['badge'] as String? ?? '',
    );
  }
}