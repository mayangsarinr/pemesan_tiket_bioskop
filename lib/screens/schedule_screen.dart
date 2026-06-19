import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Jangan lupa jalankan 'flutter pub add intl' jika belum ada
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';
import '../widgets/custom_button.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final List<DateTime> _dates =
      List.generate(3, (index) => DateTime.now().add(Duration(days: index)));

  final List<String> _times = ["13:00", "15:45", "18:30", "21:15"];

  final int _fixedPrice = 50000;

  int _selectedDateIndex = 0; // Default memilih tanggal pertama
  int _selectedTimeIndex = 0; // Default memilih jam pertama

  @override
  Widget build(BuildContext context) {
    // Mengambil argumen data film dari halaman sebelumnya
    final movie =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Pilih Jadwal',
          style: TextStyle(
              color: AppColors.textLight, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primaryDark,
        iconTheme: const IconThemeData(color: AppColors.textLight),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= SECTION PILIHAN HARI & TANGGAL =================
            const Text(
              "Pilih Hari & Tanggal",
              style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 75,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _dates.length,
                itemBuilder: (context, index) {
                  final date = _dates[index];
                  // Format Indonesia: Contoh "Jum" atau "Sab"
                  final dayName = DateFormat('E', 'id_ID').format(date);
                  // Format tanggal: Contoh "19 Juni"
                  final dayNumber = DateFormat('d MMM').format(date);
                  final isSelected = _selectedDateIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDateIndex = index;
                      });
                    },
                    child: Container(
                      width: 90,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.lightBlue
                            : AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? Colors.white
                              : AppColors.accent.withOpacity(0.3),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dayName,
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.primaryDark
                                  : AppColors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dayNumber,
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.primaryDark
                                  : AppColors.textLight,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 28),

            // ================= SECTION PILIHAN JAM TAYANG =================
            const Text(
              "Pilih Jam Tayang",
              style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12.0,
              runSpacing: 12.0,
              children: List.generate(_times.length, (index) {
                final isSelected = _selectedTimeIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTimeIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.lightBlue
                          : AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? Colors.white
                            : AppColors.accent.withOpacity(0.3),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      _times[index],
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.primaryDark
                            : AppColors.textLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
            ),

            const Spacer(),

            // ================= DETAIL HARGA FLAT Rp 50.000 =================
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.accent.withOpacity(0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Harga per Tiket",
                    style: TextStyle(color: AppColors.grey, fontSize: 15),
                  ),
                  Text(
                    "Rp $_fixedPrice",
                    style: const TextStyle(
                      color: AppColors.lightBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // ================= TOMBOL AKSI PUSH KE SEAT SELECTION =================
            CustomButton(
              text: 'Pilih Kursi',
              onPressed: () {
                final selectedDate = _dates[_selectedDateIndex];
                final formattedDate =
                    DateFormat('yyyy-MM-dd').format(selectedDate);
                final formattedDay = DateFormat('EEEE, d MMMM YYYY', 'id_ID')
                    .format(selectedDate);
                final selectedTime = _times[_selectedTimeIndex];

                // Membungkus data ke struktur map 'schedule' agar tidak merusak logic baca di SeatSelectionScreen kamu
                Navigator.pushNamed(
                  context,
                  AppRoutes.seatSelection,
                  arguments: {
                    'movie': movie,
                    'schedule': {
                      'date': formattedDate,
                      'day': formattedDay,
                      'time': selectedTime,
                      'price': _fixedPrice,
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
