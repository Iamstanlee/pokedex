import 'package:pokedex/config/constants.dart';
import 'package:pokedex/config/theme.dart';
import 'package:pokedex/core/widgets/loading_indicator.dart';
import 'package:pokedex/data/model/pokemon.dart';
import 'package:pokedex/presentation/bloc/pokemon_cubit.dart';
import 'package:pokedex/presentation/bloc/state.dart';
import 'package:pokedex/presentation/pokemon/widgets/pokemon_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllPokemonTab extends StatefulWidget {
  const AllPokemonTab({Key? key}) : super(key: key);

  @override
  State<AllPokemonTab> createState() => _AllPokemonTabState();
}

class _AllPokemonTabState extends State<AllPokemonTab> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() => paginate());
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void paginate() {
    if ((scrollController.position.pixels >=
        scrollController.position.maxScrollExtent + 100)) {
      context.read<PokemonCubit>().getMorePokemons();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonCubit, BlocState<List<Pokemon>>>(
      builder: (context, state) {
        final pokemons = state.data;

        if (pokemons.isNotEmpty) {
          return GridView.builder(
            key: const PageStorageKey('all_pokemon_tab'),
            controller: scrollController,
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
        }

        if (state.isError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.getError(),
                  textAlign: TextAlign.center,
                ),
                TextButton(
                  onPressed: () => context.read<PokemonCubit>().getPokemons(),
                  child: const Text(
                    'RETRY',
                    style: TextStyle(color: AppColors.primaryColor),
                  ),
                ),
              ],
            ),
          );
        }

        return const LoadingIndicator();
      },
    );
  }
}
