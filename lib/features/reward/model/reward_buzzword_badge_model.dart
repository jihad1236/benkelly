
class RewardBuzzwordBadge {
  final String category;
  final String buzzword;
  final String country;
  final String city;
  final String site;
  final String era; 

  RewardBuzzwordBadge({
    required this.category,
    required this.buzzword,
    required this.country,
    required this.city,
    required this.site,
    required this.era,
  });

  factory RewardBuzzwordBadge.fromJson(Map<String, dynamic> json) {
    return RewardBuzzwordBadge(
      category: json['category'] as String? ?? '',
      buzzword: json['buzzword'] as String? ?? '',
      country: json['country'] as String? ?? '',
      city: json['city'] as String? ?? '',
      site: json['site'] as String? ?? '',
      era: json['era'] as String? ?? '', 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'buzzword': buzzword,
      'country': country,
      'city': city,
      'site': site,
      'era': int.tryParse(era)?.toString() ?? era, 
    };
  }
}