import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import '../controllers/movie_controller.dart';
import '../widgets/movie_card.dart';
import '../widgets/genre_chip.dart';

class MoviesListScreen extends StatelessWidget {
  const MoviesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CineVault'),
      ),
      body: SafeArea(
        child: Consumer<MovieController>(
          builder: (context, controller, _) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.errorMessage != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(Gaps.xl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Something went wrong', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: Gaps.sm),
                      Text(controller.errorMessage!, textAlign: TextAlign.center),
                      const SizedBox(height: Gaps.lg),
                      OutlinedButton(
                        onPressed: controller.refresh,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final movies = controller.movies;

            return RefreshIndicator(
              onRefresh: controller.refresh,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(Gaps.md, Gaps.md, Gaps.md, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            onChanged: controller.search,
                            decoration: const InputDecoration(
                              hintText: 'Search movies, directors…',
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                          const SizedBox(height: Gaps.md),
                          SizedBox(
                            height: 40,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                GenreChip(
                                  label: 'All',
                                  selected: controller.selectedGenre == null,
                                  onTap: () => controller.selectGenre(null),
                                ),
                                ...controller.allGenres.map((g) => GenreChip(
                                      label: g,
                                      selected: controller.selectedGenre == g,
                                      onTap: () => controller.selectGenre(g),
                                    )),
                              ],
                            ),
                          ),
                          const SizedBox(height: Gaps.md),
                        ],
                      ),
                    ),
                  ),
                  if (movies.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: Text('No movies found')),
                    )
                  else
                    _MoviesGrid(moviesCount: movies.length),
                  const SliverToBoxAdapter(child: SizedBox(height: Gaps.xxl)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MoviesGrid extends StatelessWidget {
  final int moviesCount;
  const _MoviesGrid({required this.moviesCount});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<MovieController>();

    int columns;
    final width = MediaQuery.sizeOf(context).width;
    if (width <= Breakpoints.mobileMax) {
      columns = 2;
    } else if (width <= Breakpoints.tabletMax) {
      columns = 3;
    } else {
      columns = 5;
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: Gaps.md),
      sliver: SliverGrid.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: Gaps.md,
          mainAxisSpacing: Gaps.md,
          childAspectRatio: 3/4 + 0.10,
        ),
        itemCount: moviesCount,
        itemBuilder: (context, index) {
          final movie = controller.movies[index];
          return MovieCard(
            movie: movie,
            onToggleFavorite: () => controller.toggleFavorite(movie.id),
          );
        },
      ),
    );
  }
}