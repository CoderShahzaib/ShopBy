class Categories {
  Categories({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
    required this.creationAt,
    required this.updatedAt,
  });

  final int? id;
  final String? name;
  final String? slug;
  final String? image;
  final DateTime? creationAt;
  final DateTime? updatedAt;

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      id: json["id"],
      name: json["name"],
      slug: json["slug"],
      image: json["image"],
      creationAt: DateTime.tryParse(json["creationAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }
}
