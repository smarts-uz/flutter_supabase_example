class CityModel {
  int id;
  String createdAt;
  String name;

  CityModel({
    required this.id,
    required this.createdAt,
    required this.name,
  });

  factory CityModel.fromJson(
    int id,
    String createdAt,
    String name,
  ) {
    return CityModel(
      id: id,
      createdAt: createdAt,
      name: name,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "created_at": createdAt,
      "name": name,
    };
  }
}
