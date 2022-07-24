import 'package:bayzat_pokedex/config/constants.dart';
import 'package:bayzat_pokedex/core/app.dart';
import 'package:bayzat_pokedex/core/manager/http_manager.dart';
import 'package:bayzat_pokedex/data/model/pokemon.dart';
import 'package:bayzat_pokedex/data/pokemon_local_datasource.dart';
import 'package:bayzat_pokedex/data/pokemon_remote_datasource.dart';
import 'package:bayzat_pokedex/repository/favourite_pokemon_repository.dart';
import 'package:bayzat_pokedex/repository/pokemon_repository.dart';
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
