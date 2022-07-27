import 'package:pokedex/config/constants.dart';
import 'package:pokedex/core/app.dart';
import 'package:pokedex/core/manager/http_manager.dart';
import 'package:pokedex/data/model/pokemon.dart';
import 'package:pokedex/data/pokemon_local_datasource.dart';
import 'package:pokedex/data/pokemon_remote_datasource.dart';
import 'package:pokedex/repository/favourite_pokemon_repository.dart';
import 'package:pokedex/repository/pokemon_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PokemonAdapter());
  Hive.registerAdapter(PokemonNameAndUrlDatumAdapter());
  Hive.registerAdapter(PokemonStatAdapter());
  Hive.registerAdapter(PokemonTypeAdapter());

  final favouriteDb = await Hive.openBox<Pokemon>(LocalDbKeys.favouriteDb);
  final dio = Dio();
  final http = HttpManager(dio: dio);

  final pokemonRepository = PokemonRepository(
    PokedexRemoteDataSource(http),
  );

  final favouritePokemonRepository = FavouritePokemonRepository(
    PokedexLocalDataSource(favouriteDb),
  );

  runApp(
    PokedexApp(
      pokemonRepository: pokemonRepository,
      favouritePokemonRepository: favouritePokemonRepository,
    ),
  );
}
