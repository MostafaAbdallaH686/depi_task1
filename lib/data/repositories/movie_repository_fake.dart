import 'dart:async';
import 'dart:math';

import '../models/movie_models.dart';
import 'movie_repository.dart';

class FakeMovieRepository implements MovieRepository {
  final Map<String, Movie> _store = <String, Movie>{};
  final Random _random = Random(42);

  FakeMovieRepository() {
    _seed();
  }

  void _seed() {
    List<Movie> initial = [
      Movie(
        id: 'm1',
        title: 'Eclipse City',
        year: 2023,
        synopsis: 'In a metropolis where daylight is a luxury, a detective chases a hacker who can turn off the sun.',
        genres: ['Sci‑Fi', 'Thriller'],
        rating: 4.4,
        runtimeMinutes: 118,
        director: 'Leona Hart',
        cast: [
          const Person(id: 'p1', name: 'Ari Lennix', role: 'Actor'),
          const Person(id: 'p2', name: 'Kade Moss', role: 'Actor'),
        ],
        isFavorite: false,
        primaryColor: 0xFF5A67D8,
      ),
      Movie(
        id: 'm2',
        title: 'Harbor Lights',
        year: 2022,
        synopsis: 'A small-town lighthouse keeper confronts rising seas and an old love.',
        genres: ['Drama', 'Romance'],
        rating: 4.1,
        runtimeMinutes: 104,
        director: 'Rina Alvarez',
        cast: [
          const Person(id: 'p3', name: 'Milo Chen', role: 'Actor'),
          const Person(id: 'p4', name: 'Sofia Park', role: 'Actor'),
        ],
        isFavorite: true,
        primaryColor: 0xFF00BFA6,
      ),
      Movie(
        id: 'm3',
        title: 'Neon Wild',
        year: 2021,
        synopsis: 'Street racers, neon jungles, and a pact that could end a dynasty.',
        genres: ['Action'],
        rating: 4.0,
        runtimeMinutes: 112,
        director: 'Tomas Ibarra',
        cast: [
          const Person(id: 'p5', name: 'Noah Reyes', role: 'Actor'),
          const Person(id: 'p6', name: 'Jade Okoye', role: 'Actor'),
        ],
        isFavorite: false,
        primaryColor: 0xFFFF6B6B,
      ),
      Movie(
        id: 'm4',
        title: 'Ivory Garden',
        year: 2020,
        synopsis: 'A botanist discovers a plant that sings, drawing the attention of a reclusive composer.',
        genres: ['Drama', 'Music'],
        rating: 4.6,
        runtimeMinutes: 129,
        director: 'Mara Duvall',
        cast: [
          const Person(id: 'p7', name: 'Rhea Patel', role: 'Actor'),
          const Person(id: 'p8', name: 'Jonah Brooks', role: 'Actor'),
        ],
        isFavorite: false,
        primaryColor: 0xFF8D7BFE,
      ),
      Movie(
        id: 'm5',
        title: 'Paper Skies',
        year: 2019,
        synopsis: 'Two siblings attempt to circumnavigate the world in a homemade glider.',
        genres: ['Adventure', 'Family'],
        rating: 3.9,
        runtimeMinutes: 97,
        director: 'Imani Rivers',
        cast: [
          const Person(id: 'p9', name: 'Theo Watts', role: 'Actor'),
          const Person(id: 'p10', name: 'Lia Moreno', role: 'Actor'),
        ],
        isFavorite: false,
        primaryColor: 0xFFFFB84D,
      ),
      Movie(
        id: 'm6',
        title: 'Midnight Pantry',
        year: 2024,
        synopsis: 'A culinary heist film set in a 24-hour market where flavors hide secrets.',
        genres: ['Comedy', 'Heist'],
        rating: 4.2,
        runtimeMinutes: 106,
        director: 'Kenji Watanabe',
        cast: [
          const Person(id: 'p11', name: 'Asha Rahman', role: 'Actor'),
          const Person(id: 'p12', name: 'Carter Hale', role: 'Actor'),
        ],
        isFavorite: true,
        primaryColor: 0xFF57CC99,
      ),
      Movie(
        id: 'm7',
        title: 'Dust & Stars',
        year: 2018,
        synopsis: 'A rancher-astronomer prepares his daughter for a once-in-a-century meteor storm.',
        genres: ['Family', 'Drama'],
        rating: 4.3,
        runtimeMinutes: 110,
        director: 'Rory Finch',
        cast: [
          const Person(id: 'p13', name: 'Callie Rhodes', role: 'Actor'),
          const Person(id: 'p14', name: 'Emir Novak', role: 'Actor'),
        ],
        isFavorite: false,
        primaryColor: 0xFF4D96FF,
      ),
      Movie(
        id: 'm8',
        title: 'Gilded Echoes',
        year: 2022,
        synopsis: 'A sound engineer uncovers a lost recording that could rewrite music history.',
        genres: ['Mystery', 'Music'],
        rating: 4.5,
        runtimeMinutes: 121,
        director: 'Sienna Kaur',
        cast: [
          const Person(id: 'p15', name: 'Xavier Li', role: 'Actor'),
          const Person(id: 'p16', name: 'Priya Anand', role: 'Actor'),
        ],
        isFavorite: false,
        primaryColor: 0xFFF59E0B,
      ),
      Movie(
        id: 'm9',
        title: 'Winter Atlas',
        year: 2020,
        synopsis: 'Cartographers race to map a melting archipelago before the thaw erases its borders.',
        genres: ['Adventure', 'Drama'],
        rating: 4.0,
        runtimeMinutes: 115,
        director: 'Etta Grimes',
        cast: [
          const Person(id: 'p17', name: 'Nico Vidal', role: 'Actor'),
          const Person(id: 'p18', name: 'Harper Quinn', role: 'Actor'),
        ],
        isFavorite: false,
        primaryColor: 0xFF60A5FA,
      ),
      Movie(
        id: 'm10',
        title: 'Copper Veins',
        year: 2017,
        synopsis: 'A geologist returns to her mining town to expose a corporate cover-up.',
        genres: ['Thriller'],
        rating: 3.8,
        runtimeMinutes: 108,
        director: 'Veronica Cruz',
        cast: [
          const Person(id: 'p19', name: 'Mika Torres', role: 'Actor'),
          const Person(id: 'p20', name: 'Rowan Beck', role: 'Actor'),
        ],
        isFavorite: false,
        primaryColor: 0xFFEF4444,
      ),
      Movie(
        id: 'm11',
        title: 'Silent Orbit',
        year: 2024,
        synopsis: 'An astronaut attempts the first solo repair mission on a defunct satellite.',
        genres: ['Sci‑Fi', 'Drama'],
        rating: 4.7,
        runtimeMinutes: 132,
        director: 'Iris Tan',
        cast: [
          const Person(id: 'p21', name: 'Elio Navarro', role: 'Actor'),
          const Person(id: 'p22', name: 'Zara Voss', role: 'Actor'),
        ],
        isFavorite: true,
        primaryColor: 0xFF10B981,
      ),
      Movie(
        id: 'm12',
        title: 'Crimson Ledger',
        year: 2019,
        synopsis: 'A forensic accountant uncovers a trail of revenge hidden in balance sheets.',
        genres: ['Crime', 'Thriller'],
        rating: 4.1,
        runtimeMinutes: 101,
        director: 'Dane Holloway',
        cast: [
          const Person(id: 'p23', name: 'Jules Hart', role: 'Actor'),
          const Person(id: 'p24', name: 'Nadia Cross', role: 'Actor'),
        ],
        isFavorite: false,
        primaryColor: 0xFFDB2777,
      ),
    ];

    for (final m in initial) {
      _store[m.id] = m;
    }
  }

  Future<T> _withLatency<T>(T Function() fn) async {
    await Future.delayed(Duration(milliseconds: 200 + _random.nextInt(300)));
    return fn();
  }

  @override
  Future<List<Movie>> fetchMovies() => _withLatency(() => _store.values.toList(growable: false));

  @override
  Future<Movie> fetchMovie(String id) => _withLatency(() {
        final movie = _store[id];
        if (movie == null) {
          throw StateError('Movie not found: $id');
        }
        return movie;
      });

  @override
  Future<void> toggleFavorite(String id) => _withLatency(() {
        final movie = _store[id];
        if (movie == null) {
          throw StateError('Movie not found: $id');
        }
        _store[id] = movie.copyWith(isFavorite: !movie.isFavorite);
      });
}