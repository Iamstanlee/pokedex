import 'package:pokedex/config/constants.dart';
import 'package:pokedex/config/theme.dart';
import 'package:pokedex/core/widgets/gap.dart';
import 'package:pokedex/data/model/pokemon.dart';
import 'package:pokedex/gen/assets.gen.dart';
import 'package:pokedex/presentation/bloc/state.dart';
import 'package:pokedex/presentation/pokemon/all_pokemon_tab.dart';
import 'package:pokedex/presentation/bloc/favourite_pokemom_cubit.dart';
import 'package:pokedex/core/widgets/image.dart';
import 'package:pokedex/presentation/pokemon/favourite_pokemon_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppScaffoldPage extends StatefulWidget {
  const AppScaffoldPage({Key? key}) : super(key: key);

  @override
  State<AppScaffoldPage> createState() => _AppScaffoldPageState();
}

class _AppScaffoldPageState extends State<AppScaffoldPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: LocalImage(Assets.images.appLogo.path, height: 32),
        ),
        body: Column(
          children: const [
            _TabBarHeader(),
            Expanded(
              child: TabBarView(
                children: [
                  AllPokemonTab(),
                  FavouritePokemonTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabBarHeader extends StatelessWidget {
  const _TabBarHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: ColoredBox(
        color: Colors.white,
        child: TabBar(
          unselectedLabelColor: const Color(0xff6B6B6B),
          labelColor: const Color(0xff161A33),
          indicatorColor: AppColors.primaryColor,
          labelPadding: const EdgeInsets.symmetric(vertical: Insets.xs),
          indicatorWeight: 3,
          tabs: [
            const Tab(
              child: Text(
                'All Pokemons',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            Tab(
              child:
                  BlocBuilder<FavouritePokemonCubit, BlocState<List<Pokemon>>>(
                builder: (context, state) {
                  final count = state.data.length;
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Favourites',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      if (count != 0) ...[
                        const HGap(Insets.xs),
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryColor,
                          ),
                          padding: const EdgeInsets.all(Insets.xs),
                          child: Text(
                            '$count',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ]
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
