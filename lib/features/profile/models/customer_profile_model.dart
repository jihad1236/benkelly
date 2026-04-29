class CustomerProfileModel {
  final int? id;
  final String name;
  final String? image;
  final String? phoneNumber;
  final int? user;

  CustomerProfileModel({
    this.id,
    required this.name,
    this.image,
    this.phoneNumber,
    this.user,
  });

  factory CustomerProfileModel.fromJson(Map<String, dynamic> json) {
    return CustomerProfileModel(
      id: json['id'] is int
          ? json['id']
          : (json['id'] != null ? int.tryParse(json['id'].toString()) : null),
      name: json['name']?.toString() ?? '',
      image: json['image'] != null ? json['image'].toString() : null,
      phoneNumber: json['phone_number'] != null
          ? json['phone_number'].toString()
          : null,
      user: json['user'] is int
          ? json['user']
          : (json['user'] != null
                ? int.tryParse(json['user'].toString())
                : null),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image': image,
    'phone_number': phoneNumber,
    'user': user,
  };
}
