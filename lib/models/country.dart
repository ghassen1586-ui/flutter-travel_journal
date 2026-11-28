class Country {
  const Country({
    required this.name,
    required this.capital,
    required this.population,
  });

  final String name;
  final String capital;
  final int population;

  factory Country.fromJson(Map<String, dynamic> json) {
    final capitals = json['capital'] as List<dynamic>?; // capital is a LIST
    return Country(
      name: (json['name'] as Map<String, dynamic>)['common'] as String,
      capital: (capitals != null && capitals.isNotEmpty)
          ? capitals.first as String
          : 'N/A',
      population: (json['population'] as num).toInt(),
    );
  }
}