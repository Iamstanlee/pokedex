import 'package:bayzat_pokedex/config/constants.dart';
import 'package:bayzat_pokedex/config/theme.dart';
import 'package:bayzat_pokedex/core/utils/extension/context.dart';
import 'package:bayzat_pokedex/core/utils/extension/string.dart';
import 'package:bayzat_pokedex/core/utils/pokemon_type.dart';
import 'package:bayzat_pokedex/core/widgets/gap.dart';
import 'package:bayzat_pokedex/core/widgets/image.dart';
import 'package:bayzat_pokedex/core/widgets/loading_indicator.dart';
import 'package:bayzat_pokedex/data/model/pokemon.dart';
import 'package:bayzat_pokedex/presentation/bloc/favourite_pokemom_cubit.dart';
import 'package:bayzat_pokedex/presentation/bloc/pokemon_cubit.dart';
import 'package:bayzat_pokedex/presentation/pokemon_info/widgets/floating_button.dart';
import 'package:bayzat_pokedex/presentation/pokemon_info/widgets/pokemon_info_header_delegate.dart';
import 'package:bayzat_pokedex/presentation/pokemon_info/widgets/pokemon_stats_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PokemonInfoPage extends StatefulWidget {
  final Pokemon pokemon;
  const PokemonInfoPage(this.pokemon, {Key? key}) : super(key: key);

  @override
  State<PokemonInfoPage> createState() => _PokemonInfoPageState();
}

class _PokemonInfoPageState extends State<PokemonInfoPage> {
  late ScrollController scrollController;
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()
      ..addListener(() {
        setState(() {});
      });

    context.read<PokemonCubit>().getPokemon(widget.pokemon.id);
  }

  bool get isAppBarExpanded {
    return scrollController.hasClients &&
        scrollController.offset > (200 - kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    final bool isMarkedAsFavourite = context
        .watch<FavouritePokemonCubit>()
        .state
        .favouritePokemonList
        .any((favourite) => favourite.id == widget.pokemon.id);

    final pokemonCubit = context.watch<PokemonCubit>();
    // if the an error occur fetching the updated state
    // the persisted state will be used if the pokemon is marked as favourite
    final pokemon = pokemonCubit.state.pokemon.isEmpty
        ? widget.pokemon
        : pokemonCubit.state.pokemon;

    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            leading: GestureDetector(
              onTap: () => context.pop(),
              child: const Icon(
                CupertinoIcons.chevron_back,
                color: Colors.black,
              ),
            ),
            pinned: true,
            elevation: 0,
            expandedHeight: 220,
            backgroundColor: isAppBarExpanded
                ? getTypeColor(pokemon.baseType)
                : getTypeColor(pokemon.baseType).withOpacity(0.1),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: const EdgeInsets.only(
                left: Insets.md,
                bottom: Insets.md,
              ),
              title: AnimatedPadding(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.only(
                  left: isAppBarExpanded ? 32 : 0,
                  bottom: 3,
                ),
                child: Text(
                  pokemon.pokedexId,
                  style: TextStyle(
                    color: AppColors.textPrimaryColor,
                    fontSize: isAppBarExpanded ? 15 : 12,
                  ),
                ),
              ),
              background: FlexibleBackground(pokemon),
            ),
          ),
          SliverPersistentHeader(
            delegate: PokemonInfoHeaderDelegate(
              pokemon: pokemon,
            ),
            pinned: true,
          ),
          if (pokemonCubit.state.status.isLoading) ...[
            const SliverFillRemaining(
              child: LoadingIndicator(),
            ),
          ] else
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  const ColoredBox(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(Insets.md),
                      child: Text(
                        "Base stats",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const VGap(0.5),
                  ...pokemon.stats.map((stat) => PokemonStatItem(stat)),
                  PokemonStatItem(
                    PokemonStat(
                      stat: const PokemonNameAndUrlDatum("Avg. Power", ""),
                      baseStat: pokemon.averagePower.toInt(),
                      effort: 0,
                    ),
                  ),
                  const VGap(120),
                ],
              ),
            )
        ],
      ),
      floatingActionButton: FloatingButton(
        pokemon,
        isPokemonMarkedAsFavourite: isMarkedAsFavourite,
      ),
    );
  }
}

class FlexibleBackground extends StatelessWidget {
  final Pokemon pokemon;
  const FlexibleBackground(this.pokemon, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Positioned(
          bottom: -Insets.md,
          child: Image.asset(
            Assets.pokedex,
            fit: BoxFit.contain,
            height: 200,
            color: getTypeColor(pokemon.baseType),
          ),
        ),
        Positioned(
          right: 24,
          child: Hero(
            tag: ValueKey(pokemon.id),
            child: HostedImage(
              pokemon.imageUrl,
              height: 170,
            ),
          ),
        ),
        Positioned(
          left: Insets.md,
          top: kToolbarHeight * 2,
          right: context.getWidth(0.5),
          bottom: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pokemon.name.capitalize(),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryColor,
                  fontSize: 27,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                pokemon.types
                    .map((type) => type.type.name.capitalize())
                    .join(", "),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
