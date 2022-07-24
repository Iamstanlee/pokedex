import 'package:bayzat_pokedex/config/constants.dart';
import 'package:bayzat_pokedex/config/theme.dart';
import 'package:bayzat_pokedex/presentation/app_scaffold.dart';
import 'package:bayzat_pokedex/presentation/bloc/favourite_pokemom_cubit.dart';
import 'package:bayzat_pokedex/presentation/bloc/pokemon_cubit.dart';
import 'package:bayzat_pokedex/repository/favourite_pokemon_repository.dart';
import 'package:bayzat_pokedex/repository/pokemon_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PokedexApp extends StatelessWidget {
  final PokemonRepository pokemonRepository;
  final FavouritePokemonRepository favouritePokemonRepository;

  const PokedexApp({
    required this.pokemonRepository,
    required this.favouritePokemonRepository,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PokemonCubit>(
          create: (context) => PokemonCubit(
            pokemonRepository: pokemonRepository,
          )..getPokemonList(),
        ),
        BlocProvider<FavouritePokemonCubit>(
          create: (context) => FavouritePokemonCubit(
            pokemonRepository: favouritePokemonRepository,
          )..getFavouritePokemonList(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: kAppName,
        theme: lightThemeData,
        home: const AppScaffoldPage(),
      ),
    );
  }
}
