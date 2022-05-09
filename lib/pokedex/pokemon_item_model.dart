class PokemonItem {
  final String name;
  final String url;

  PokemonItem({
    required this.name,
    required this.url,
  });

  factory PokemonItem.fromJson(Map<String, dynamic> json) {
    return PokemonItem(
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }
}
