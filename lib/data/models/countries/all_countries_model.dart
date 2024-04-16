class AllCountriesModel {
  AllCountriesModel({
    required this.emoji,
    required this.name,
    required this.capital,
    required this.code,
    required this.phone,
  });

  final String code;
  final String name;
  final String emoji;
  final String capital;
  final String phone;

  factory AllCountriesModel.fromJson(Map<String, dynamic> json) {
    return AllCountriesModel(
      emoji: json["emoji"] as String? ?? "",
      name: json["name"] as String? ?? "",
      capital: json["capital"] as String? ?? "",
      code: json["code"] as String? ?? "",
      phone: json["phone"] as String? ?? "",
    );
  }
}
