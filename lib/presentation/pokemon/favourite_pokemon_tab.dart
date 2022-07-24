import 'package:bayzat_pokedex/config/constants.dart';
import 'package:bayzat_pokedex/config/theme.dart';
import 'package:bayzat_pokedex/presentation/bloc/favourite_pokemom_cubit.dart';
import 'package:bayzat_pokedex/presentation/pokemon/widgets/pokemon_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavouritePokemonTab extends StatefulWidget {
  const FavouritePokemonTab({Key? key}) : super(key: key);

  @override
  State<FavouritePokemonTab> createState() => _FavouritePokemonTabState();
}

class _FavouritePokemonTabState extends State<FavouritePokemonTab> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavouritePokemonCubit, FavouritePokemonState>(
      builder: (context, state) {
        final pokemonList = state.favouritePokemonList;
        if (pokemonList.isNotEmpty) {
          return GridView.builder(
            key: const PageStorageKey('favourite_pokemon_tab'),
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(Insets.sm),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisExtent: kMaxGridExtent,
              mainAxisSpacing: Insets.sm,
              crossAxisSpacing: Insets.sm,
            ),
            itemCount: pokemonList.length,
            itemBuilder: (context, index) => PokemonGridItem(
              pokemonList[index],
            ),
          );
        } else {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                "Your favourite pokemons would show here.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
