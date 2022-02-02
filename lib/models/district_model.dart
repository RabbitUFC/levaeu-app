class DistrictModel {
  final String id;
  final String name;

  DistrictModel({required this.id, required this.name});

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      id: json["_id"],
      name: json["name"],
    );
  }

  static List<DistrictModel> fromJsonList(List list) {
    return list.map((item) => DistrictModel.fromJson(item)).toList();
  }
}