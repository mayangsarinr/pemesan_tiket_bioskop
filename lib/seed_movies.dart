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
            "https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=500&q=80", // Tema Luar Angkasa/Galaxy
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
            "https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=500&q=80", // Tema Labirin/Mimpi/Abstrak
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
            "https://images.unsplash.com/photo-1509248961158-e54f6934749c?w=500&q=80", // Tema Kota Gotham Gelap/Kelelawar
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
            "https://images.unsplash.com/photo-1635805737707-575885ab0820?w=500&q=80", // Tema Superhero/Action
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
            "https://images.unsplash.com/photo-1500485035595-cbe6f645feb1?w=500&q=80", // Tema Alam Hutan Alien/Pandora
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
            "https://images.unsplash.com/photo-1519074069444-1ba4fff16416?w=500&q=80", // Tema Pesawat Tempur/Jet
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
            "https://images.unsplash.com/photo-1531259683007-016a7b628fc3?w=500&q=80", // Tema Badut/Kriminal Psikologis
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
            "https://images.unsplash.com/photo-1500077423678-25eead48513a?w=500&q=80", // Tema Kapal Laut Besar
        "synopsis": "A romance blossoms aboard the ill-fated RMS Titanic."
      },
      {
        "title": "The Matrix",
        "rating": 8.7,
        "genre": "Sci-Fi",
        "duration": "136 min",
        "ageRating": "17+",
        "posterUrl":
            "https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=500&q=80", // Tema Kode Digital Hijau Cyberpunk
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
            "https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=500&q=80", // Tema Sihir/Simbol Mistik
        "synopsis":
            "A brilliant surgeon learns the mystic arts after a tragic accident."
      },
      {
        "title": "Spider-Man: No Way Home",
        "rating": 8.2,
        "genre": "Action",
        "duration": "148 min",
        "ageRating": "13+",
        "posterUrl":
            "https://images.unsplash.com/photo-1569336415962-a4bd9f69cd83?w=500&q=80", // Tema Jaring Laba-laba Merah
        "synopsis":
            "With Spider-Man's identity now revealed, Peter asks Doctor Strange for help."
      },
      {
        "title": "Dune: Part Two",
        "rating": 8.6,
        "genre": "Sci-Fi",
        "duration": "166 min",
        "ageRating": "13+",
        "posterUrl":
            "https://images.unsplash.com/photo-1509316975850-ff9c5deb0cd9?w=500&q=80", // Tema Gurun Pasir Luas
        "synopsis":
            "Paul Atreides unites with Chani and the Fremen while seeking revenge against the conspirators."
      },
      {
        "title": "Oppenheimer",
        "rating": 8.5,
        "genre": "History",
        "duration": "180 min",
        "ageRating": "17+",
        "posterUrl":
            "https://images.unsplash.com/photo-1447069387593-a5de0862481e?w=500&q=80", // Tema Lab/Sains Vintage/Bom
        "synopsis":
            "The story of American scientist J. Robert Oppenheimer and his role in the development of the atomic bomb."
      },
      {
        "title": "The Shawshank Redemption",
        "rating": 9.3,
        "genre": "Drama",
        "duration": "142 min",
        "ageRating": "15+",
        "posterUrl":
            "https://images.unsplash.com/photo-1589829545856-d10d557cf95f?w=500&q=80", // Tema Penjara/Hukum Gedung Tua
        "synopsis":
            "A banker unjustifiably convicted of murder faces a lifelong sentence."
      },
      {
        "title": "Pulp Fiction",
        "rating": 8.9,
        "genre": "Crime",
        "duration": "154 min",
        "ageRating": "17+",
        "posterUrl":
            "https://images.unsplash.com/photo-1593085512500-5d55148d6f0d?w=500&q=80", // Tema Retro/Gangster Kriminal
        "synopsis":
            "The lives of two mob hitmen intertwine in stories of violence."
      },
      {
        "title": "Forrest Gump",
        "rating": 8.8,
        "genre": "Drama",
        "duration": "142 min",
        "ageRating": "13+",
        "posterUrl":
            "https://images.unsplash.com/photo-1517486808906-6ca8b3f04846?w=500&q=80", // Tema Bangku Taman/Klasik Amerika
        "synopsis":
            "The history of the United States unfolds from the perspective of an Alabama man."
      },
      {
        "title": "Fight Club",
        "rating": 8.8,
        "genre": "Drama",
        "duration": "139 min",
        "ageRating": "17+",
        "posterUrl":
            "https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=500&q=80", // Tema Underground/Gedung Kota Hancur
        "synopsis": "An office worker forms an underground fight club."
      },
      {
        "title": "Gladiator",
        "rating": 8.5,
        "genre": "Action",
        "duration": "155 min",
        "ageRating": "15+",
        "posterUrl":
            "https://images.unsplash.com/photo-1558591710-4b4a1ae0f04d?w=500&q=80", // Tema Pedang/Ksatria Romawi Roma
        "synopsis":
            "A former Roman General sets out to exact vengeance against the corrupt emperor."
      },
      {
        "title": "Spirited Away",
        "rating": 8.6,
        "genre": "Animation",
        "duration": "125 min",
        "ageRating": "SU",
        "posterUrl":
            "https://images.unsplash.com/photo-1578632767115-351597cf2477?w=500&q=80", // Tema Anime/Kuil Jepang Misterius
        "synopsis":
            "A young girl wanders into a world ruled by gods, witches, and spirits."
      },
      {
        "title": "Parasite",
        "rating": 8.5,
        "genre": "Thriller",
        "duration": "132 min",
        "ageRating": "17+",
        "posterUrl":
            "https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=500&q=80", // Tema Rumah Mewah/Tangga Gelap Basement
        "synopsis":
            "Greed and class discrimination threaten a symbiotic relationship between two families."
      },
      {
        "title": "The Lion King",
        "rating": 8.5,
        "genre": "Animation",
        "duration": "88 min",
        "ageRating": "SU",
        "posterUrl":
            "https://images.unsplash.com/photo-1546182990-dffeafbe841d?w=500&q=80", // Gambar Singa Afrika Nyata
        "synopsis":
            "A young lion cub named Simba flees his kingdom after his father's murder."
      },
      {
        "title": "Your Name.",
        "rating": 8.5,
        "genre": "Animation",
        "duration": "106 min",
        "ageRating": "SU",
        "posterUrl":
            "https://images.unsplash.com/photo-1534796636912-3b95b3ab5986?w=500&q=80", // Tema Langit Malam Bintang Jatuh Komet
        "synopsis": "Two strangers find themselves linked in a bizarre way."
      },
      {
        "title": "Interstellar 2 Fake",
        "rating": 6.5,
        "genre": "Sci-Fi",
        "duration": "120 min",
        "ageRating": "13+",
        "posterUrl":
            "https://images.unsplash.com/photo-1446776811953-b23d57bd21aa?w=500&q=80", // Satelit Luar Angkasa Berbeda
        "synopsis":
            "A fictional continuation journey in deep dark galaxy spaces."
      },
      {
        "title": "Whiplash",
        "rating": 8.5,
        "genre": "Drama",
        "duration": "106 min",
        "ageRating": "15+",
        "posterUrl":
            "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=500&q=80", // Tema Alat Musik/Drum Studio
        "synopsis":
            "A promising young drummer enrolls at a cut-throat music conservatory."
      },
      {
        "title": "The Prestige",
        "rating": 8.5,
        "genre": "Mystery",
        "duration": "130 min",
        "ageRating": "13+",
        "posterUrl":
            "https://images.unsplash.com/photo-1511193311914-0346f16efe90?w=500&q=80", // Tema Panggung Sulap Tirai Teater
        "synopsis":
            "Two stage magicians engage in a battle to create the ultimate illusion."
      }
    ];

    for (var movie in movies) {
      final check = await firestore
          .collection('movies')
          .where('title', isEqualTo: movie['title'])
          .get();

      if (check.docs.isEmpty) {
        await firestore.collection('movies').add(movie);
      } else {
        final movieId = check.docs.first.id;
        await firestore.collection('movies').doc(movieId).update({
          "posterUrl": movie['posterUrl'],
        });
      }
    }

    print(
        "Semua 25 data Film BERHASIL disinkronisasi dengan gambar yang akurat & tidak kembar!");
  }
}
