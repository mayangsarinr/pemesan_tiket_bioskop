import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';
import '../widgets/custom_button.dart';

class BookingScreen extends StatefulWidget {
  final String movieTitle;
  final String date;
  final String time;
  final List<String> seats;
  final int total;

  const BookingScreen({
    Key? key,
    required this.movieTitle,
    required this.date,
    required this.time,
    required this.seats,
    required this.total,
  }) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  bool _isSaving = false;

  String _formatCurrency(int value) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatter.format(value);
  }

  String get _formattedDate {
    try {
      final dateTime = DateTime.parse(widget.date);
      return DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(dateTime);
    } catch (_) {
      return widget.date;
    }
  }

  Future<void> _confirmBooking() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan masuk untuk melanjutkan pemesanan.')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final bookingData = {
      'userId': user.uid,
      'userEmail': user.email,
      'movieTitle': widget.movieTitle,
      'date': widget.date,
      'time': widget.time,
      'seats': widget.seats,
      'total': widget.total,
      'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance.collection('bookings').add(bookingData);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking berhasil disimpan!')),
      );
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.bookingHistory, (route) => false);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan booking: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Ringkasan Booking', style: TextStyle(color: AppColors.textLight)),
        backgroundColor: AppColors.primaryDark,
        iconTheme: const IconThemeData(color: AppColors.textLight),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(widget.movieTitle,
                  style: const TextStyle(color: AppColors.textLight, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Tanggal: $_formattedDate', style: const TextStyle(color: AppColors.grey)),
              const SizedBox(height: 4),
              Text('Waktu: ${widget.time}', style: const TextStyle(color: AppColors.grey)),
              const SizedBox(height: 18),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Detail Pesanan', style: TextStyle(color: AppColors.textLight, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _buildDetailRow('Jumlah Kursi', '${widget.seats.length}'),
                    const SizedBox(height: 8),
                    _buildDetailRow('Kursi', widget.seats.join(', ')),
                    const SizedBox(height: 8),
                    _buildDetailRow('Harga per Kursi', _formatCurrency(widget.total ~/ (widget.seats.isNotEmpty ? widget.seats.length : 1))),
                    const SizedBox(height: 8),
                    _buildDetailRow('Total Bayar', _formatCurrency(widget.total), bold: true),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text('Metode Pembayaran', style: TextStyle(color: AppColors.textLight, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: const Text('Pembayaran akan diproses setelah booking dikonfirmasi. Untuk demo, data akan disimpan ke Firebase Firestore.',
                    style: TextStyle(color: AppColors.grey)),
              ),

              const Spacer(),
              CustomButton(
                text: 'Konfirmasi Booking',
                isLoading: _isSaving,
                onPressed: _confirmBooking,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.grey)),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: AppColors.textLight,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
