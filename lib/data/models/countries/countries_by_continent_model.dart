class CountriesByContinentModel {
  CountriesByContinentModel({
    required this.emoji,
    required this.name,
    required this.capital,
    required this.code,
    required this.phone,
    required this.continentName,
  });

  final String code;
  final String name;
  final String emoji;
  final String capital;
  final String phone;
  final String continentName;

  factory CountriesByContinentModel.fromJson(Map<String, dynamic> json) {
    return CountriesByContinentModel(
      continentName: json["continent"]["name"] as String? ?? "",
      emoji: json["emoji"] as String? ?? "",
      name: json["name"] as String? ?? "",
      capital: json["capital"] as String? ?? "",
      code: json["code"] as String? ?? "",
      phone: json["phone"] as String? ?? "",
    );
  }
}
