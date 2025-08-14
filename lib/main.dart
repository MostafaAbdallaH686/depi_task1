import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'data/repositories/movie_repository.dart';
import 'data/repositories/movie_repository_fake.dart';
import 'features/movies/controllers/movie_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final MovieRepository movieRepository = FakeMovieRepository();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<MovieController>(
          create: (_) => MovieController(repository: movieRepository)..loadInitial(),
        ),
      ],
      child: const App(),
    ),
  );
}
