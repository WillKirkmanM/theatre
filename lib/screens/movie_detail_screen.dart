import 'package:flutter/material.dart';
import '../models/movie.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(movie.title),
              background: movie.backdropPath.isNotEmpty
                  ? Image.network(
                      movie.backdropPath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[300],
                        child: Icon(Icons.movie, size: 50),
                      ),
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: Icon(Icons.movie, size: 50),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Poster
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          movie.posterPath,
                          height: 180,
                          errorBuilder: (_, __, ___) =>
                              Container(
                                height: 180,
                                width: 120,
                                color: Colors.grey[300],
                                child: Icon(Icons.image),
                              ),
                        ),
                      ),
                      SizedBox(width: 16),
                      // Movie Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (movie.tagline != null && movie.tagline!.isNotEmpty)
                              Text(
                                movie.tagline!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 20),
                                SizedBox(width: 4),
                                Text(
                                  '${movie.voteAverage.toStringAsFixed(1)}/10',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  ' (${movie.voteCount} votes)',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            if (movie.runtime != null)
                              Row(
                                children: [
                                  Icon(Icons.access_time, size: 20),
                                  SizedBox(width: 4),
                                  Text('${movie.runtime} minutes'),
                                ],
                              ),
                            SizedBox(height: 8),
                            Text(
                              'Released: ${movie.releaseDate}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Overview',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8),
                  Text(movie.overview),
                  if (movie.cast != null && movie.cast!.isNotEmpty) ...[
                    SizedBox(height: 24),
                    Text(
                      'Cast',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      height: 140,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: movie.cast!.length,
                        itemBuilder: (context, index) {
                          final actor = movie.cast![index];
                          return Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 45,
                                  backgroundImage: actor['profile_path'] != null
                                      ? NetworkImage(
                                          'https://image.tmdb.org/t/p/w200${actor['profile_path']}',
                                        )
                                      : null,
                                  child: actor['profile_path'] == null
                                      ? Icon(Icons.person, size: 40)
                                      : null,
                                ),
                                SizedBox(height: 8),
                                SizedBox(
                                  width: 90,
                                  child: Text(
                                    actor['name'],
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  if (movie.videos != null && movie.videos!.isNotEmpty) ...[
                    SizedBox(height: 24),
                    Text(
                      'Videos',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: movie.videos!.length,
                        itemBuilder: (context, index) {
                          final video = movie.videos![index];
                          return Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: InkWell(
                              onTap: () async {
                                final url = 'https://www.youtube.com/watch?v=${video['key']}';
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(Uri.parse(url));                                
                                }
                                },
                              child: Column(
                                children: [
                                  Container(
                                    width: 160,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(Icons.play_circle_outline, size: 40),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    video['type'],
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}