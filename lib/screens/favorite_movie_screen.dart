// lib/screens/favorite_movie_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';

class FavoriteMovieScreen extends StatelessWidget {
  const FavoriteMovieScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Favorit',
              style: TextStyle(color: AppColors.textLight)),
          backgroundColor: AppColors.primaryDark,
          iconTheme: const IconThemeData(color: AppColors.textLight),
        ),
        body: const Center(
          child: Text(
            'Silakan masuk untuk melihat film favorit Anda.',
            style: TextStyle(color: AppColors.textLight),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title:
            const Text('Favorit', style: TextStyle(color: AppColors.textLight)),
        backgroundColor: AppColors.primaryDark,
        iconTheme: const IconThemeData(color: AppColors.textLight),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.lightBlue));
          }

          final data = snapshot.data?.data() as Map<String, dynamic>?;
          final favs = data?['favorites'] as List<dynamic>? ?? [];

          if (favs.isEmpty) {
            return const Center(
                child: Text('Belum ada film favorit.',
                    style: TextStyle(color: AppColors.textLight)));
          }

          final List<String> favIds = favs.map((e) => e.toString()).toList();

          // Jika favorit kurang dari atau sama dengan 10 item
          if (favIds.length <= 10) {
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('movies')
                  .where(FieldPath.documentId, whereIn: favIds)
                  .snapshots(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.lightBlue));
                }
                final movies = snap.data?.docs ?? [];
                return _buildMovieGrid(movies);
              },
            );
          }

          // Jika favorit lebih dari 10 item (Menggunakan Future.wait)
          return FutureBuilder<List<DocumentSnapshot>>(
            future: Future.wait(favIds.map((id) =>
                FirebaseFirestore.instance.collection('movies').doc(id).get())),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(
                    child:
                        CircularProgressIndicator(color: AppColors.lightBlue));
              }
              final movies = snap.data?.where((d) => d.exists).toList() ?? [];
              if (movies.isEmpty) {
                return const Center(
                    child: Text('Belum ada film favorit.',
                        style: TextStyle(color: AppColors.textLight)));
              }

              return _buildMovieGrid(movies);
            },
          );
        },
      ),
    );
  }

  // Fungsi Helper untuk Grid agar kode tidak duplikat
  Widget _buildMovieGrid(List<DocumentSnapshot> movies) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movieData = movies[index].data() as Map<String, dynamic>;
        final movieId = movies[index].id;
        final posterUrl = movieData['posterUrl']?.toString() ?? '';

        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRoutes.movieDetail,
              arguments: {'movieId': movieId, ...movieData}),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: posterUrl.startsWith('http')
                        ? Image.network(posterUrl,
                            width: double.infinity, fit: BoxFit.cover)
                        : Container(
                            color: AppColors.accent,
                            child: const Icon(Icons.movie,
                                size: 50, color: Colors.white)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movieData['title'] ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: AppColors.textLight,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            (movieData['rating'] ?? '0.0').toString(),
                            style: const TextStyle(
                                color: AppColors.textLight, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
