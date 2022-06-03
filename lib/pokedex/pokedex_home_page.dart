import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'pokemon_item_model.dart';

class PokedexHomePage extends StatelessWidget {
  const PokedexHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder(
        future: getPokemons(),
        builder:
            (BuildContext context, AsyncSnapshot<List<PokemonItem>> snapshot) {
          if (snapshot.hasData) {
            List<PokemonItem> pokemons = snapshot.data!;
            return ListView(
              children: pokemons
                  .map(
                    (PokemonItem pokemon) => ListTile(
                      title: Text(pokemon.name),
                      subtitle: Text(pokemon.url),
                    ),
                  )
                  .toList(),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

// Leer https://docs.flutter.dev/cookbook/networking/fetch-data

Future<List<PokemonItem>> getPokemons() async {
  final queryParameters = {
    'limit': '20',
    'offset': '0',
  };
  final url = Uri.https('pokeapi.co', '/api/v2/pokemon/', queryParameters);
  final response = await http.get(url);

  if (response.statusCode == 200) {
    List<dynamic> body = convert.jsonDecode(response.body)['results'];
    List<PokemonItem> pokemons = body
        .map(
          (dynamic item) => PokemonItem.fromJson(item),
        )
        .toList();
    return pokemons;
  } else {
    throw 'Request failed with status ${response.statusCode}';
  }
}
