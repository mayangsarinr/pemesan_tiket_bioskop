import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';
import '../widgets/custom_button.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  bool _isProcessing = false;

  void _actionConfirmBooking(Map<String, dynamic> data) async {
    setState(() => _isProcessing = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final movie = data['movie'] as Map<String, dynamic>;
      final schedule = data['schedule'] as Map<String, dynamic>;

      final bookingId =
          FirebaseFirestore.instance.collection('bookings').doc().id;

      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .set({
        'bookingId': bookingId,
        'userId': user.uid,
        'movieId': movie['movieId'],
        'movieTitle': movie['title'],
        'scheduleId': schedule['scheduleId'],
        'date': schedule['date'],
        'time': schedule['time'],
        'selectedSeats': data['selectedSeats'],
        'totalPrice': data['totalPrice'],
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.cardBackground,
          title: const Text('Sukses',
              style: TextStyle(color: AppColors.textLight)),
          content: const Text('Tiket Anda berhasil dipesan!',
              style: TextStyle(color: AppColors.grey)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutes.home, (route) => false);
              },
              child: const Text('OK',
                  style: TextStyle(color: AppColors.lightBlue)),
            )
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final movie = data['movie'] as Map<String, dynamic>;
    final schedule = data['schedule'] as Map<String, dynamic>;
    final List<String> seats = List<String>.from(data['selectedSeats']);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Ringkasan Pembayaran',
            style: TextStyle(color: AppColors.textLight)),
        backgroundColor: AppColors.primaryDark,
        iconTheme: const IconThemeData(color: AppColors.textLight),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie['title'] ?? '',
                      style: const TextStyle(
                          color: AppColors.textLight,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(movie['genre'] ?? '',
                      style: const TextStyle(color: AppColors.grey)),
                  const Divider(color: AppColors.accent, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Jadwal:',
                          style: TextStyle(color: AppColors.grey)),
                      Text('${schedule['date']} | ${schedule['time']}',
                          style: const TextStyle(
                              color: AppColors.textLight,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Kursi:',
                          style: TextStyle(color: AppColors.grey)),
                      Text(seats.join(', '),
                          style: const TextStyle(
                              color: AppColors.textLight,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Bayar:',
                      style:
                          TextStyle(color: AppColors.textLight, fontSize: 16)),
                  Text('Rp ${data['totalPrice']}',
                      style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const Spacer(),
            CustomButton(
              text: 'Konfirmasi Pemesanan',
              isLoading: _isProcessing,
              onPressed: () => _actionConfirmBooking(data),
            )
          ],
        ),
      ),
    );
  }
}
