class CollectionModel {
  final int? id;
  final String imagePath;
  final String title;
  final String location;

  CollectionModel({
    this.id,
    required this.imagePath,
    required this.title,
    required this.location,
  });

  factory CollectionModel.fromJson(Map<String, dynamic> json) {
    final image = json['image'];
    final city = json['city'] ?? '';
    final country = json['country'] ?? '';
    final dynamic rawId = json['id'];
    final int? id = rawId is int
        ? rawId
        : (rawId != null ? int.tryParse(rawId.toString()) : null);

    return CollectionModel(
      id: id,
      imagePath: image != null ? image.toString() : '',
      title: json['name'] ?? json['title'] ?? '',
      location:
          ((city.isNotEmpty || country.isNotEmpty)
                  ? ('$city${city.isNotEmpty && country.isNotEmpty ? ', ' : ''}$country')
                  : (json['location'] ?? ''))
              .toString(),
    );
  }
}
