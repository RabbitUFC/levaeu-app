class PickupPointModel {
  final String id;
  final String name;
  final String district;
  final String? image;

  PickupPointModel({required this.id, required this.name, required this.district, this.image});

  factory PickupPointModel.fromJson(Map<String, dynamic> json) {
    return PickupPointModel(
      id: json["_id"],
      name: json["name"],
      district: json["district"]["name"],
      image: json["image"],
    );
  }

  static List<PickupPointModel> fromJsonList(List list) {
    return list.map((item) => PickupPointModel.fromJson(item)).toList();
  }
}