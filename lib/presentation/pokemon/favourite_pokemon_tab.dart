import 'package:pokedex/config/constants.dart';
import 'package:pokedex/config/theme.dart';
import 'package:pokedex/data/model/pokemon.dart';
import 'package:pokedex/presentation/bloc/favourite_pokemom_cubit.dart';
import 'package:pokedex/presentation/bloc/state.dart';
import 'package:pokedex/presentation/pokemon/widgets/pokemon_grid_item.dart';
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
    return BlocBuilder<FavouritePokemonCubit, BlocState<List<Pokemon>>>(
      builder: (context, state) {
        final pokemons = state.data;
        if (pokemons.isNotEmpty) {
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
            itemCount: pokemons.length,
            itemBuilder: (context, index) => PokemonGridItem(
              pokemons[index],
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
