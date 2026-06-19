import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('CinemaGo',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: AppColors.textLight)),
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: AppColors.lightBlue),
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.bookingHistory),
          ),
          IconButton(
            icon: const Icon(Icons.favorite, color: AppColors.lightBlue),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.favorites),
          ),
          IconButton(
            icon: const Icon(Icons.person, color: AppColors.lightBlue),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('movies').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.lightBlue));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text('Tidak ada film tersedia.',
                    style: TextStyle(color: AppColors.textLight)));
          }

          final movies = snapshot.data!.docs;

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

              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.movieDetail,
                      arguments: {'movieId': movieId, ...movieData});
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)),
                          child: movieData['posterUrl']
                                  .toString()
                                  .startsWith('http')
                              ? Image.network(movieData['posterUrl'],
                                  width: double.infinity, fit: BoxFit.cover)
                              : Container(
                                  color: AppColors.accent,
                                  child: const Icon(Icons.movie, size: 50)),
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
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 14),
                                const SizedBox(width: 4),
                                Text(movieData['rating'].toString(),
                                    style: const TextStyle(
                                        color: AppColors.textLight,
                                        fontSize: 12)),
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
        },
      ),
    );
  }
}
