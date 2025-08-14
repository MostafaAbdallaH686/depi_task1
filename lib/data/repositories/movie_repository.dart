import '../models/movie_models.dart';

abstract class MovieRepository {
  Future<List<Movie>> fetchMovies();
  Future<Movie> fetchMovie(String id);
  Future<void> toggleFavorite(String id);
}