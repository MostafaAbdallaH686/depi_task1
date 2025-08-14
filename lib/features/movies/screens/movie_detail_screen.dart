import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../data/models/movie_models.dart';
import '../controllers/movie_controller.dart';
import '../widgets/rating_stars.dart';
import '../widgets/genre_chip.dart';

class MovieDetailScreen extends StatelessWidget {
  final String movieId;
  const MovieDetailScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<MovieController>(
          builder: (context, controller, _) {
            final Movie? selected = controller.byId(movieId);

            if (selected == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 280,
                  actions: [
                    IconButton(
                      tooltip: selected.isFavorite ? 'Remove from favorites' : 'Add to favorites',
                      onPressed: () => controller.toggleFavorite(selected.id),
                      icon: Icon(
                        selected.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(selected.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                    background: Container(
                      color: Color(selected.primaryColor),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(Gaps.xl),
                    child: _Meta(movie: selected),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Gaps.xl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Synopsis', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: Gaps.sm),
                        Text(selected.synopsis, style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(height: Gaps.xl),
                        Text('Cast', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: Gaps.sm),
                        SizedBox(
                          height: 44,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: selected.cast.length,
                            separatorBuilder: (_, __) => const SizedBox(width: Gaps.md),
                            itemBuilder: (_, i) {
                              final p = selected.cast[i];
                              return Chip(label: Text(p.name));
                            },
                          ),
                        ),
                        const SizedBox(height: Gaps.xxl),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  final Movie movie;
  const _Meta({required this.movie});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RatingStars(rating: movie.rating, size: 18),
            const SizedBox(width: Gaps.sm),
            Text(movie.rating.toStringAsFixed(1), style: theme.textTheme.titleMedium),
            const Spacer(),
            Icon(Icons.schedule, size: 18),
            const SizedBox(width: 6),
            Text('${movie.runtimeMinutes} min'),
          ],
        ),
        const SizedBox(height: Gaps.lg),
        Wrap(
          spacing: 6,
          runSpacing: -4,
          children: [
            for (final g in movie.genres) GenreChip(label: g, selected: true, onTap: () {}),
          ],
        ),
        const SizedBox(height: Gaps.lg),
        Row(
          children: [
            Text('Director', style: theme.textTheme.titleMedium),
            const SizedBox(width: Gaps.md),
            Text(movie.director, style: theme.textTheme.bodyLarge),
            const Spacer(),
            Text(movie.year.toString(), style: theme.textTheme.bodyLarge),
          ],
        ),
      ],
    );
  }
}