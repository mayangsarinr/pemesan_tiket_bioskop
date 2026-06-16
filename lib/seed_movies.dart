import 'package:cloud_firestore/cloud_firestore.dart';

class SeedMovies {
  static Future<void> seedMovies() async {
    final firestore = FirebaseFirestore.instance;

    final movies = [
      {
        "title": "Interstellar",
        "rating": 8.7,
        "genre": "Sci-Fi",
        "duration": "169 min",
        "ageRating": "13+",
        "posterUrl":
            "https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg",
        "synopsis":
            "A team of explorers travel through a wormhole in space in an attempt to ensure humanity's survival."
      },
      {
        "title": "Inception",
        "rating": 8.8,
        "genre": "Sci-Fi",
        "duration": "148 min",
        "ageRating": "13+",
        "posterUrl":
            "https://image.tmdb.org/t/p/w500/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg",
        "synopsis":
            "A skilled thief enters people's dreams to steal secrets but is tasked with planting an idea instead."
      },
      {
        "title": "The Dark Knight",
        "rating": 9.0,
        "genre": "Action",
        "duration": "152 min",
        "ageRating": "13+",
        "posterUrl":
            "https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg",
        "synopsis":
            "Batman faces his greatest challenge when the Joker unleashes chaos upon Gotham City."
      },
      {
        "title": "Avengers: Endgame",
        "rating": 8.4,
        "genre": "Action",
        "duration": "181 min",
        "ageRating": "13+",
        "posterUrl":
            "https://image.tmdb.org/t/p/w500/or06FN3Dka5tukK1e9sl16pB3iy.jpg",
        "synopsis":
            "The Avengers assemble once more to undo the devastation caused by Thanos."
      },
      {
        "title": "Avatar",
        "rating": 7.9,
        "genre": "Adventure",
        "duration": "162 min",
        "ageRating": "13+",
        "posterUrl":
            "https://image.tmdb.org/t/p/w500/jRXYjXNq0Cs2TcJjLkki24MLp7u.jpg",
        "synopsis":
            "A paraplegic marine becomes part of an alien world called Pandora."
      },
      {
        "title": "Top Gun: Maverick",
        "rating": 8.3,
        "genre": "Action",
        "duration": "131 min",
        "ageRating": "13+",
        "posterUrl":
            "https://image.tmdb.org/t/p/w500/62HCnUTziyWcpDaBO2i1DX17ljH.jpg",
        "synopsis":
            "Maverick returns to train elite pilots for a dangerous mission."
      },
      {
        "title": "Joker",
        "rating": 8.4,
        "genre": "Drama",
        "duration": "122 min",
        "ageRating": "17+",
        "posterUrl":
            "https://image.tmdb.org/t/p/w500/udDclJoHjfjb8Ekgsd4FDteOkCU.jpg",
        "synopsis":
            "Arthur Fleck struggles with mental illness and becomes Gotham's infamous villain."
      },
      {
        "title": "Titanic",
        "rating": 7.9,
        "genre": "Romance",
        "duration": "194 min",
        "ageRating": "13+",
        "posterUrl":
            "https://image.tmdb.org/t/p/w500/9xjZS2rlVxm8SFx8kPC3aIGCOYQ.jpg",
        "synopsis":
            "A romance blossoms aboard the ill-fated RMS Titanic."
      },
      {
        "title": "The Matrix",
        "rating": 8.7,
        "genre": "Sci-Fi",
        "duration": "136 min",
        "ageRating": "17+",
        "posterUrl":
            "https://image.tmdb.org/t/p/w500/f89U3ADr1oiB1s9GkdPOEpXUk5H.jpg",
        "synopsis":
            "A hacker discovers reality is a simulation and joins a rebellion."
      },
      {
        "title": "Doctor Strange",
        "rating": 7.5,
        "genre": "Fantasy",
        "duration": "115 min",
        "ageRating": "13+",
        "posterUrl":
            "https://image.tmdb.org/t/p/w500/uGBVj3bEbCoZbDjjl9wTxcygko1.jpg",
        "synopsis":
            "A brilliant surgeon learns the mystic arts after a tragic accident."
      },
    ];

    for (var movie in movies) {
      final check = await firestore
          .collection('movies')
          .where('title', isEqualTo: movie['title'])
          .get();

      if (check.docs.isEmpty) {
        await firestore.collection('movies').add(movie);
      }
    }

    print("Movies seeded successfully!");
  }
}