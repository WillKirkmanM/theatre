import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/movie.dart';

class MovieScraper {
  static const String baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> getPopularMovies() async {
    developer.log('Fetching popular movies');
    
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/movie/popular?api_key=${dotenv.env["API_KEY"]}&language=en-US&page=1&append_to_response=videos,credits,reviews'), 
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        }
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        
        return results.map((movie) {
          return Movie(
            id: movie['id'],
            title: movie['title'],
            overview: movie['overview'],
            posterPath: movie['poster_path'] != null 
                ? 'https://image.tmdb.org/t/p/w500${movie['poster_path']}'
                : '',
            backdropPath: movie['backdrop_path'] != null 
                ? 'https://image.tmdb.org/t/p/original${movie['backdrop_path']}'
                : '',
            releaseDate: movie['release_date'] ?? '',
            voteAverage: (movie['vote_average'] ?? 0.0) * 1.0,
            voteCount: movie['vote_count'] ?? 0,
            popularity: movie['popularity'] ?? 0.0,
            originalTitle: movie['original_title'] ?? '',
            originalLanguage: movie['original_language'] ?? '',
            adult: movie['adult'] ?? false,
            genreIds: List<int>.from(movie['genre_ids'] ?? []),
            video: movie['video'] ?? false,
          );
        }).toList();
      }
      throw Exception('Failed to load movies: ${response.statusCode}');
    } catch (e) {
      developer.log('Error fetching movies: $e');
      throw Exception('Failed to fetch movies: $e');
    }
  }

  Future<Movie> getMovieDetails(int movieId) async {
    developer.log('Fetching details for movie $movieId');
    
    final response = await http.get(
      Uri.parse('$baseUrl/movie/$movieId?api_key=${dotenv.env["API_KEY"]}&append_to_response=videos,credits,reviews'),
      headers: {'Accept': 'application/json'}
    );

    if (response.statusCode == 200) {
      final movie = json.decode(response.body);
      final credits = movie['credits'];
      
      return Movie(
        id: movie['id'],
        title: movie['title'],
        overview: movie['overview'],
        posterPath: movie['poster_path'] != null 
            ? 'https://image.tmdb.org/t/p/w500${movie['poster_path']}'
            : '',
        backdropPath: movie['backdrop_path'] != null 
            ? 'https://image.tmdb.org/t/p/original${movie['backdrop_path']}'
            : '',
        releaseDate: movie['release_date'] ?? '',
        voteAverage: (movie['vote_average'] ?? 0.0) * 1.0,
        voteCount: movie['vote_count'] ?? 0,
        popularity: movie['popularity'] ?? 0.0,
        originalTitle: movie['original_title'] ?? '',
        originalLanguage: movie['original_language'] ?? '',
        adult: movie['adult'] ?? false,
        budget: movie['budget'] ?? 0,
        revenue: movie['revenue'] ?? 0,
        runtime: movie['runtime'] ?? 0,
        status: movie['status'] ?? '',
        tagline: movie['tagline'] ?? '',
        video: movie['video'] ?? false,
        genreIds: (movie['genres'] as List?)?.map((g) => g['id'] as int).toList() ?? [],
        cast: (credits['cast'] as List?)?.map((c) => {
          'id': c['id'],
          'name': c['name'],
          'character': c['character'],
          'profile_path': c['profile_path']
        }).toList() ?? [],
        videos: (movie['videos']['results'] as List?)?.map((v) => {
          'key': v['key'],
          'site': v['site'],
          'type': v['type']
        }).toList() ?? [],
      );
    }
    throw Exception('Failed to load movie details: ${response.statusCode}');
  }
}