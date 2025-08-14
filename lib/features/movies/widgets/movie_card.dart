import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/routing/app_router.dart';
import '../../../data/models/movie_models.dart';
import '../../../widgets/app_icon_button.dart';
import 'rating_stars.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onToggleFavorite;

  const MovieCard({super.key, required this.movie, required this.onToggleFavorite});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Radii.lg),
      onTap: () => context.goNamed(AppRoutes.detail, pathParameters: {'id': movie.id}),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 3/4,
              child: Container(
                color: Color(movie.primaryColor),
                child: Stack(
                  children: [
                    Positioned(
                      top: 4,
                      right: 4,
                      child: AppIconButton(
                        semanticLabel: movie.isFavorite ? 'Remove from favorites' : 'Add to favorites',
                        onPressed: onToggleFavorite,
                        icon: Icon(
                          movie.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Gaps.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: Gaps.xs),
                  Row(
                    children: [
                      RatingStars(rating: movie.rating, size: 14),
                      const SizedBox(width: Gaps.xs),
                      Text(
                        movie.rating.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const Spacer(),
                      Text(
                        movie.year.toString(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}