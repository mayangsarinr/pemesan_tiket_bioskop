import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';
import '../widgets/custom_button.dart';

class MovieDetailScreen extends StatefulWidget {
  const MovieDetailScreen({Key? key}) : super(key: key);

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final movie = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final movieId = movie['movieId'] as String? ?? '';

    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: AppColors.primaryDark,
            iconTheme: const IconThemeData(color: AppColors.textLight),
            actions: [
              if (user != null)
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
                  builder: (context, snap) {
                    bool isFav = false;
                    if (snap.hasData && snap.data!.exists) {
                      final data = snap.data!.data() as Map<String, dynamic>?;
                      final favs = data?['favorites'] as List<dynamic>?;
                      if (favs != null) isFav = favs.contains(movieId);
                    }

                    return IconButton(
                      icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.pinkAccent),
                      onPressed: () async {
                        try {
                          final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
                          if (isFav) {
                            await userRef.update({
                              'favorites': FieldValue.arrayRemove([movieId])
                            });
                          } else {
                            await userRef.set({'favorites': FieldValue.arrayUnion([movieId])}, SetOptions(merge: true));
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal update favorite: $e')));
                        }
                      },
                    );
                  },
                )
              else
                IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.pinkAccent),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Silakan masuk untuk menambahkan favorite')));
                    Navigator.pushNamed(context, AppRoutes.signIn);
                  },
                )
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: movie['posterUrl'].toString().startsWith('http')
                  ? Image.network(movie['posterUrl'], fit: BoxFit.cover)
                  : Container(color: AppColors.accent),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie['title'] ?? '',
                        style: const TextStyle(
                            color: AppColors.textLight,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(4)),
                          child: Text(movie['genre'] ?? '', style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(movie['rating'].toString(), style: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 12),
                        const Icon(Icons.access_time, color: AppColors.grey, size: 16),
                        const SizedBox(width: 4),
                        Text(movie['duration'] ?? '', style: const TextStyle(color: AppColors.textLight)),
                      ],
                    ),
                    const Divider(color: AppColors.accent, height: 32),
                    const Text('Sinopsis', style: TextStyle(color: AppColors.textLight, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(movie['synopsis'] ?? '', style: const TextStyle(color: AppColors.grey, height: 1.5, fontSize: 14)),
                    const SizedBox(height: 40),
                    CustomButton(
                      text: 'Pesan Tiket Sekarang',
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.schedule, arguments: movie);
                      },
                    ),
                  ],
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}
