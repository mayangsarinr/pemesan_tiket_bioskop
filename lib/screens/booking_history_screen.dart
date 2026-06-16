import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/app_colors.dart';

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({Key? key}) : super(key: key);

  String _formatCurrency(int value) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(value);
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return '-';
    final date = timestamp.toDate();
    return DateFormat('dd MMM yyyy HH:mm', 'id_ID').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Riwayat Booking', style: TextStyle(color: AppColors.textLight)),
          backgroundColor: AppColors.primaryDark,
          iconTheme: const IconThemeData(color: AppColors.textLight),
          elevation: 0,
        ),
        body: const Center(
          child: Text('Silakan masuk untuk melihat riwayat booking Anda.', style: TextStyle(color: AppColors.textLight)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Riwayat Booking', style: TextStyle(color: AppColors.textLight)),
        backgroundColor: AppColors.primaryDark,
        iconTheme: const IconThemeData(color: AppColors.textLight),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('userId', isEqualTo: user.uid)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.lightBlue));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('Belum ada booking.', style: TextStyle(color: AppColors.textLight)),
            );
          }

          final bookings = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final data = bookings[index].data() as Map<String, dynamic>;
              final seats = (data['seats'] as List<dynamic>?)?.cast<String>() ?? <String>[];
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data['movieTitle'] ?? '-', style: const TextStyle(color: AppColors.textLight, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${data['date'] ?? '-'} • ${data['time'] ?? '-'}', style: const TextStyle(color: AppColors.grey)),
                        Text(_formatDate(data['createdAt'] as Timestamp?), style: const TextStyle(color: AppColors.lightBlue, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Kursi: ${seats.join(', ')}', style: const TextStyle(color: AppColors.textLight)),
                    const SizedBox(height: 8),
                    Text('Total: ${_formatCurrency(data['total'] ?? 0)}', style: const TextStyle(color: AppColors.lightBlue, fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
