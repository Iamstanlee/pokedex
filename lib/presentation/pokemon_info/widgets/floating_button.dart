import 'package:pokedex/config/constants.dart';
import 'package:pokedex/data/model/pokemon.dart';
import 'package:pokedex/presentation/bloc/favourite_pokemom_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FloatingButton extends StatelessWidget {
  final bool isPokemonMarkedAsFavourite;
  final Pokemon pokemon;
  const FloatingButton(
    this.pokemon, {
    this.isPokemonMarkedAsFavourite = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        if (isPokemonMarkedAsFavourite) {
          context.read<FavouritePokemonCubit>().removePokemon(pokemon.id);
        } else {
          context.read<FavouritePokemonCubit>().addPokemon(pokemon);
        }
      },
      backgroundColor: isPokemonMarkedAsFavourite
          ? const Color(0xffD5DEFF)
          : AppColors.primaryColor,
      label: isPokemonMarkedAsFavourite
          ? const Text(
              "Remove from favourites",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.primaryColor,
              ),
            )
          : const Text(
              "Mark as favourite",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
    );
  }
}
