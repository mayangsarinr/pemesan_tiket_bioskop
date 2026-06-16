import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';
import '../widgets/custom_button.dart';

class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movie =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: AppColors.primaryDark,
            iconTheme: const IconThemeData(color: AppColors.textLight),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(4)),
                          child: Text(movie['genre'] ?? '',
                              style: const TextStyle(
                                  color: AppColors.textLight, fontSize: 12)),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(movie['rating'].toString(),
                            style: const TextStyle(
                                color: AppColors.textLight,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(width: 12),
                        const Icon(Icons.access_time,
                            color: AppColors.grey, size: 16),
                        const SizedBox(width: 4),
                        Text(movie['duration'] ?? '',
                            style: const TextStyle(color: AppColors.textLight)),
                      ],
                    ),
                    const Divider(color: AppColors.accent, height: 32),
                    const Text('Sinopsis',
                        style: TextStyle(
                            color: AppColors.textLight,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(movie['synopsis'] ?? '',
                        style: const TextStyle(
                            color: AppColors.grey, height: 1.5, fontSize: 14)),
                    const SizedBox(height: 40),
                    CustomButton(
                      text: 'Pesan Tiket Sekarang',
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.schedule,
                            arguments: movie);
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
