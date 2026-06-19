import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';
import '../widgets/custom_button.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  Map<String, dynamic>? _selectedSchedule;
  @override
  Widget build(BuildContext context) {
    final movie =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Pilih Jadwal',
            style: TextStyle(color: AppColors.textLight)),
        backgroundColor: AppColors.primaryDark,
        iconTheme: const IconThemeData(color: AppColors.textLight),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('schedules')
                    .where('movieId', isEqualTo: movie['movieId'])
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.lightBlue));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text('Belum ada jadwal tayang.',
                            style: TextStyle(color: AppColors.textLight)));
                  }

                  final schedules = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: schedules.length,
                    itemBuilder: (context, index) {
                      final scheduleData =
                          schedules[index].data() as Map<String, dynamic>;
                      final scheduleId = schedules[index].id;
                      final isSelected =
                          _selectedSchedule?['scheduleId'] == scheduleId;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedSchedule = {
                              'scheduleId': scheduleId,
                              ...scheduleData
                            };
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.lightBlue
                                : AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.accent),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    scheduleData['date'] ?? '',
                                    style: TextStyle(
                                      color: isSelected
                                          ? AppColors.primaryDark
                                          : AppColors.textLight,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    scheduleData['time'] ?? '',
                                    style: TextStyle(
                                      color: isSelected
                                          ? AppColors.primaryDark
                                          : AppColors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Rp ${scheduleData['price']}',
                                style: TextStyle(
                                  color: isSelected
                                      ? AppColors.primaryDark
                                      : AppColors.lightBlue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            CustomButton(
              text: 'Pilih Kursi',
              onPressed: _selectedSchedule == null
                  ? () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Pilih jadwal terlebih dahulu')))
                  : () {
                      Navigator.pushNamed(context, AppRoutes.seatSelection,
                          arguments: {
                            'movie': movie,
                            'schedule': _selectedSchedule,
                          });
                    },
            ),
          ],
        ),
      ),
    );
  }
}
