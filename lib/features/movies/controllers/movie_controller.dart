import 'package:flutter/foundation.dart';

import '../../../data/models/movie_models.dart';
import '../../../data/repositories/movie_repository.dart';

class MovieController extends ChangeNotifier {
  MovieController({required MovieRepository repository}) : _repository = repository;

  final MovieRepository _repository;

  bool _isLoading = false;
  String? _errorMessage;
  List<Movie> _allMovies = <Movie>[];
  List<Movie> _visibleMovies = <Movie>[];
  String _query = '';
  String? _selectedGenre;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Movie> get movies => _visibleMovies;
  String get query => _query;
  String? get selectedGenre => _selectedGenre;

  Future<void> loadInitial() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      _allMovies = await _repository.fetchMovies();
      _applyFilters();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refresh() async {
    await loadInitial();
  }

  void search(String value) {
    _query = value.trim();
    _applyFilters();
  }

  void selectGenre(String? genre) {
    _selectedGenre = genre;
    _applyFilters();
  }

  Future<void> toggleFavorite(String movieId) async {
    try {
      await _repository.toggleFavorite(movieId);
      final idx = _allMovies.indexWhere((m) => m.id == movieId);
      if (idx != -1) {
        final updated = await _repository.fetchMovie(movieId);
        _allMovies[idx] = updated;
        _applyFilters(notify: false);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Movie? byId(String id) {
    for (final movie in _allMovies) {
      if (movie.id == id) return movie;
    }
    return null;
  }

  void _applyFilters({bool notify = true}) {
    Iterable<Movie> iterable = _allMovies;

    if (_selectedGenre != null && _selectedGenre!.isNotEmpty) {
      iterable = iterable.where((m) => m.genres.contains(_selectedGenre));
    }

    if (_query.isNotEmpty) {
      final lower = _query.toLowerCase();
      iterable = iterable.where((m) => m.title.toLowerCase().contains(lower) || m.director.toLowerCase().contains(lower));
    }

    _visibleMovies = iterable.toList(growable: false);
    if (notify) notifyListeners();
  }

  List<String> get allGenres {
    final set = <String>{};
    for (final m in _allMovies) {
      set.addAll(m.genres);
    }
    final list = set.toList()..sort();
    return list;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}