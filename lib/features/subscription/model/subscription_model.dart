class SubscriptionTierModel {
  final int id;

  final String apiId;

  final String name;
  final String? description;
  final List<String> features;
  final String? imageUrl;
  final Map<String, String>? metadata;
  final int? trialDays;

  final double priceAmount;
  final String priceCurrency;
  final String priceInterval;
  final int priceIntervalCount;
  final String? priceId;

  SubscriptionTierModel({
    required this.id,
    required this.apiId,
    required this.name,
    this.description,
    required this.features,
    this.imageUrl,
    required this.priceAmount,
    required this.priceCurrency,
    required this.priceInterval,
    required this.priceIntervalCount,
    this.priceId,
    this.trialDays,
    this.metadata,
  });

  String get priceDisplay {
    final symbol = _currencySymbol(priceCurrency);
    final amount = (priceAmount % 1 == 0)
        ? priceAmount.toInt().toString()
        : priceAmount.toString();
    return '$symbol$amount';
  }

  static String _currencySymbol(String code) {
    switch (code.toLowerCase()) {
      case 'usd':
        return '\$';
      case 'eur':
        return '€';
      default:
        return ''; 
    }
  }

  factory SubscriptionTierModel.fromApiJson(
    Map<String, dynamic> json,
    int index,
  ) {
    final price = json['price'] as Map<String, dynamic>?;
    final md = (json['metadata'] as Map<String, dynamic>?)?.map(
      (k, v) => MapEntry(k.toString(), v?.toString() ?? ''),
    );
    return SubscriptionTierModel(
      id: index,
      apiId: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      features:
          (json['features'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      imageUrl: json['image']?.toString(),
      priceAmount: (price != null && price['amount'] != null)
          ? (price['amount'] is num
                ? (price['amount'] as num).toDouble()
                : double.tryParse(price['amount'].toString()) ?? 0.0)
          : 0.0,
      priceCurrency: price?['currency']?.toString() ?? '',
      priceInterval: price?['interval']?.toString() ?? '',
      priceIntervalCount: price?['interval_count'] is int
          ? price!['interval_count'] as int
          : int.tryParse(price?['interval_count']?.toString() ?? '1') ?? 1,
      priceId: price?['price_id']?.toString(),
      trialDays: json['trial_days'] is int
          ? json['trial_days'] as int
          : (json['trial_days'] != null
                ? int.tryParse(json['trial_days'].toString())
                : null),
      metadata: md,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': apiId,
    'name': name,
    'description': description,
    'features': features,
    'image': imageUrl,
    'price': {
      'amount': priceAmount,
      'currency': priceCurrency,
      'interval': priceInterval,
      'interval_count': priceIntervalCount,
      'price_id': priceId,
    },
    'trial_days': trialDays,
    'metadata': metadata,
  };
}

extension SubscriptionMetadataX on SubscriptionTierModel {
  bool _yes(String? v) => v != null && v.toLowerCase() == 'yes';

  bool get hasOfflineMode =>
      _yes(metadata?['offline_mode'] ?? metadata?['Offline_mode']);
  bool get hasAiTours => _yes(metadata?['ai_tours']);
  bool get hasCaptureIdentify => _yes(metadata?['capture_identify']);
  bool get hasLeaderboards => _yes(metadata?['leaderboards']);
  bool get hasUnlimitedSaves => _yes(metadata?['unlimited_saves']);
}
