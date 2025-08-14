import 'package:flutter/foundation.dart';

@immutable
class Person {
  final String id;
  final String name;
  final String role; // e.g., Actor, Director

  const Person({
    required this.id,
    required this.name,
    required this.role,
  });

  Person copyWith({String? id, String? name, String? role}) => Person(
        id: id ?? this.id,
        name: name ?? this.name,
        role: role ?? this.role,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Person && runtimeType == other.runtimeType && id == other.id && name == other.name && role == other.role;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ role.hashCode;
}

@immutable
class Movie {
  final String id;
  final String title;
  final int year;
  final String synopsis;
  final List<String> genres;
  final double rating; // 0..5
  final int runtimeMinutes;
  final String director;
  final List<Person> cast;
  final bool isFavorite;
  final int primaryColor; // ARGB hex for placeholder poster

  const Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.synopsis,
    required this.genres,
    required this.rating,
    required this.runtimeMinutes,
    required this.director,
    required this.cast,
    required this.isFavorite,
    required this.primaryColor,
  });

  Movie copyWith({
    String? id,
    String? title,
    int? year,
    String? synopsis,
    List<String>? genres,
    double? rating,
    int? runtimeMinutes,
    String? director,
    List<Person>? cast,
    bool? isFavorite,
    int? primaryColor,
  }) => Movie(
        id: id ?? this.id,
        title: title ?? this.title,
        year: year ?? this.year,
        synopsis: synopsis ?? this.synopsis,
        genres: genres ?? this.genres,
        rating: rating ?? this.rating,
        runtimeMinutes: runtimeMinutes ?? this.runtimeMinutes,
        director: director ?? this.director,
        cast: cast ?? this.cast,
        isFavorite: isFavorite ?? this.isFavorite,
        primaryColor: primaryColor ?? this.primaryColor,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Movie &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          year == other.year &&
          synopsis == other.synopsis &&
          listEquals(genres, other.genres) &&
          rating == other.rating &&
          runtimeMinutes == other.runtimeMinutes &&
          director == other.director &&
          listEquals(cast, other.cast) &&
          isFavorite == other.isFavorite &&
          primaryColor == other.primaryColor;

  @override
  int get hashCode => Object.hash(
        id,
        title,
        year,
        synopsis,
        Object.hashAll(genres),
        rating,
        runtimeMinutes,
        director,
        Object.hashAll(cast),
        isFavorite,
        primaryColor,
      );
}